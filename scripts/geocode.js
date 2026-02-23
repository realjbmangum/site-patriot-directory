#!/usr/bin/env node

/**
 * geocode.js — Batch geocoding for patriot directory businesses
 *
 * Reads the same CSV used for import, geocodes each row that has
 * city+state, and outputs UPDATE SQL statements.
 *
 * Usage:
 *   MAPBOX_TOKEN=pk.xxx node scripts/geocode.js data/businesses.csv
 *
 * Output: data/geocode-update.sql
 *
 * The script uses Mapbox Geocoding API (free tier: 100k req/month).
 * Rate limited to 100ms between requests (10 req/sec).
 */

const fs = require('fs');
const path = require('path');

// ---------------------------------------------------------------------------
// CSV PARSER (same as import-csv.js)
// ---------------------------------------------------------------------------

function parseCSV(text) {
  const rows = [];
  let current = '';
  let inQuotes = false;
  const lines = [];

  for (let i = 0; i < text.length; i++) {
    const ch = text[i];
    if (ch === '"') {
      inQuotes = !inQuotes;
      current += ch;
    } else if ((ch === '\n' || ch === '\r') && !inQuotes) {
      if (ch === '\r' && text[i + 1] === '\n') i++;
      if (current.trim()) lines.push(current);
      current = '';
    } else {
      current += ch;
    }
  }
  if (current.trim()) lines.push(current);

  for (const line of lines) {
    const fields = [];
    let field = '';
    let quoted = false;

    for (let i = 0; i < line.length; i++) {
      const ch = line[i];
      if (ch === '"') {
        if (quoted && line[i + 1] === '"') {
          field += '"';
          i++;
        } else {
          quoted = !quoted;
        }
      } else if (ch === ',' && !quoted) {
        fields.push(field.trim());
        field = '';
      } else {
        field += ch;
      }
    }
    fields.push(field.trim());
    rows.push(fields);
  }

  if (rows.length < 2) return [];

  const headers = rows[0].map(h => h.toLowerCase().replace(/[^a-z0-9]+/g, '_').replace(/^_|_$/g, ''));
  const result = [];
  for (let i = 1; i < rows.length; i++) {
    const obj = {};
    for (let j = 0; j < headers.length; j++) {
      obj[headers[j]] = rows[i][j] || '';
    }
    obj._row_index = i;
    result.push(obj);
  }
  return result;
}

// ---------------------------------------------------------------------------
// SLUG GENERATOR (same as import-csv.js — needed to match businesses)
// ---------------------------------------------------------------------------

function slugify(text) {
  return text
    .toString()
    .toLowerCase()
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '')
    .replace(/['']/g, '')
    .replace(/&/g, 'and')
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-+|-+$/g, '')
    .replace(/-{2,}/g, '-');
}

// ---------------------------------------------------------------------------
// STATE ABBREVIATIONS
// ---------------------------------------------------------------------------

const STATE_ABBREVS = {
  'alabama': 'AL', 'alaska': 'AK', 'arizona': 'AZ', 'arkansas': 'AR',
  'california': 'CA', 'colorado': 'CO', 'connecticut': 'CT', 'delaware': 'DE',
  'florida': 'FL', 'georgia': 'GA', 'hawaii': 'HI', 'idaho': 'ID',
  'illinois': 'IL', 'indiana': 'IN', 'iowa': 'IA', 'kansas': 'KS',
  'kentucky': 'KY', 'louisiana': 'LA', 'maine': 'ME', 'maryland': 'MD',
  'massachusetts': 'MA', 'michigan': 'MI', 'minnesota': 'MN', 'mississippi': 'MS',
  'missouri': 'MO', 'montana': 'MT', 'nebraska': 'NE', 'nevada': 'NV',
  'new hampshire': 'NH', 'new jersey': 'NJ', 'new mexico': 'NM', 'new york': 'NY',
  'north carolina': 'NC', 'north dakota': 'ND', 'ohio': 'OH', 'oklahoma': 'OK',
  'oregon': 'OR', 'pennsylvania': 'PA', 'rhode island': 'RI', 'south carolina': 'SC',
  'south dakota': 'SD', 'tennessee': 'TN', 'texas': 'TX', 'utah': 'UT',
  'vermont': 'VT', 'virginia': 'VA', 'washington': 'WA', 'west virginia': 'WV',
  'wisconsin': 'WI', 'wyoming': 'WY', 'district of columbia': 'DC',
};

function normalizeState(raw) {
  if (!raw) return '';
  const trimmed = raw.trim();
  if (/^[A-Z]{2}$/.test(trimmed)) return trimmed;
  if (/^[a-z]{2}$/.test(trimmed)) return trimmed.toUpperCase();
  const abbrev = STATE_ABBREVS[trimmed.toLowerCase()];
  return abbrev || trimmed.toUpperCase().slice(0, 2);
}

// ---------------------------------------------------------------------------
// MAPBOX GEOCODING
// ---------------------------------------------------------------------------

const MAPBOX_TOKEN = process.env.MAPBOX_TOKEN;

async function geocode(query) {
  const encoded = encodeURIComponent(query);
  const url = `https://api.mapbox.com/geocoding/v5/mapbox.places/${encoded}.json?country=us&types=place&limit=1&access_token=${MAPBOX_TOKEN}`;

  const res = await fetch(url);
  if (!res.ok) {
    throw new Error(`Mapbox API error: ${res.status} ${res.statusText}`);
  }

  const data = await res.json();
  if (data.features && data.features.length > 0) {
    const [lng, lat] = data.features[0].center;
    return { lat, lng };
  }
  return null;
}

function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

// ---------------------------------------------------------------------------
// SQL ESCAPING
// ---------------------------------------------------------------------------

function esc(value) {
  if (value === null || value === undefined || value === '') return 'NULL';
  return "'" + String(value).replace(/'/g, "''") + "'";
}

// ---------------------------------------------------------------------------
// MAIN
// ---------------------------------------------------------------------------

async function main() {
  const csvPath = process.argv[2];
  if (!csvPath) {
    console.error('Usage: MAPBOX_TOKEN=pk.xxx node scripts/geocode.js <csv-file>');
    console.error('Example: MAPBOX_TOKEN=pk.xxx node scripts/geocode.js data/businesses.csv');
    process.exit(1);
  }

  if (!MAPBOX_TOKEN) {
    console.error('Error: MAPBOX_TOKEN environment variable is required.');
    console.error('Usage: MAPBOX_TOKEN=pk.xxx node scripts/geocode.js data/businesses.csv');
    process.exit(1);
  }

  const fullPath = path.resolve(csvPath);
  if (!fs.existsSync(fullPath)) {
    console.error(`File not found: ${fullPath}`);
    process.exit(1);
  }

  const raw = fs.readFileSync(fullPath, 'utf-8');
  const rows = parseCSV(raw);

  if (rows.length === 0) {
    console.error('No data rows found in CSV.');
    process.exit(1);
  }

  console.log(`Parsed ${rows.length} rows from CSV.`);
  console.log('Geocoding businesses...');
  console.log('');

  const sql = [];
  let geocoded = 0;
  let failed = 0;
  let alreadyHasCoords = 0;
  const failedBusinesses = [];

  sql.push('-- ============================================');
  sql.push('-- PATRIOT DIRECTORY — GEOCODING UPDATE SQL');
  sql.push(`-- Generated: ${new Date().toISOString()}`);
  sql.push(`-- Source: ${path.basename(csvPath)}`);
  sql.push('-- ============================================');
  sql.push('');

  // Track slugs for dedup (same logic as import script)
  const slugsSeen = new Set();

  for (const row of rows) {
    const name = (row.name || row.business_name || row.business || '').trim();
    const city = (row.city || row.location_city || '').trim();
    const state = normalizeState(row.state || row.location_state || '');

    if (!name || !city || !state) continue;

    // Generate matching slug
    let baseSlug = slugify(name);
    let slug = baseSlug;
    let suffix = 2;
    while (slugsSeen.has(slug)) {
      slug = `${baseSlug}-${suffix}`;
      suffix++;
    }
    slugsSeen.add(slug);

    // Skip if row already has coordinates
    const existingLat = row.latitude || row.lat || '';
    const existingLng = row.longitude || row.lng || row.lon || '';
    if (existingLat && existingLng) {
      const lat = parseFloat(existingLat);
      const lng = parseFloat(existingLng);
      if (!isNaN(lat) && !isNaN(lng)) {
        sql.push(`-- ${name} — coordinates from CSV`);
        sql.push(`UPDATE businesses SET latitude = ${lat}, longitude = ${lng} WHERE slug = ${esc(slug)};`);
        alreadyHasCoords++;
        continue;
      }
    }

    // Build geocoding query
    const streetAddress = (row.street_address || row.address || '').trim();
    const query = streetAddress
      ? `${streetAddress}, ${city}, ${state}`
      : `${city}, ${state}`;

    try {
      const result = await geocode(query);
      if (result) {
        sql.push(`-- ${name} — ${city}, ${state}`);
        sql.push(`UPDATE businesses SET latitude = ${result.lat}, longitude = ${result.lng} WHERE slug = ${esc(slug)};`);
        geocoded++;
        process.stdout.write(`  [OK] ${name} — ${result.lat.toFixed(4)}, ${result.lng.toFixed(4)}\n`);
      } else {
        failed++;
        failedBusinesses.push(`${name} (${city}, ${state})`);
        process.stdout.write(`  [FAIL] ${name} — no results for "${query}"\n`);
      }
    } catch (err) {
      failed++;
      failedBusinesses.push(`${name} (${city}, ${state}): ${err.message}`);
      process.stdout.write(`  [ERROR] ${name} — ${err.message}\n`);
    }

    // Rate limit: 100ms between requests
    await sleep(100);
  }

  // Write output
  const outputDir = path.resolve(path.dirname(csvPath));
  const outputPath = path.join(outputDir, 'geocode-update.sql');
  fs.writeFileSync(outputPath, sql.join('\n'), 'utf-8');

  console.log('');
  console.log('=== Geocoding Summary ===');
  console.log(`  Geocoded:           ${geocoded} businesses`);
  console.log(`  From CSV coords:    ${alreadyHasCoords} businesses`);
  console.log(`  Failed:             ${failed} businesses`);
  console.log(`  Output:             ${outputPath}`);

  if (failedBusinesses.length > 0) {
    console.log('');
    console.log('Failed businesses (need manual coordinates):');
    for (const b of failedBusinesses) {
      console.log(`  - ${b}`);
    }
  }

  console.log('');
  console.log('Next steps:');
  console.log(`  npx wrangler d1 execute patriot_directory_db --file=${outputPath}`);
}

main().catch(err => {
  console.error('Fatal error:', err);
  process.exit(1);
});
