#!/usr/bin/env node

/**
 * import-csv.js — Google Sheets CSV -> D1 SQL import script
 *
 * Usage: node scripts/import-csv.js data/businesses.csv
 * Output: data/import.sql
 *
 * Reads a CSV exported from Google Sheets, validates rows,
 * maps categories, generates slugs, and outputs INSERT statements
 * for the patriot_directory_db D1 database.
 */

const fs = require('fs');
const path = require('path');

// ---------------------------------------------------------------------------
// CSV PARSER (lightweight, handles quoted fields with commas and newlines)
// ---------------------------------------------------------------------------

function parseCSV(text) {
  const rows = [];
  let current = '';
  let inQuotes = false;
  const lines = [];

  // Split into lines respecting quoted newlines
  for (let i = 0; i < text.length; i++) {
    const ch = text[i];
    if (ch === '"') {
      inQuotes = !inQuotes;
      current += ch;
    } else if ((ch === '\n' || ch === '\r') && !inQuotes) {
      if (ch === '\r' && text[i + 1] === '\n') i++; // skip \r\n
      if (current.trim()) lines.push(current);
      current = '';
    } else {
      current += ch;
    }
  }
  if (current.trim()) lines.push(current);

  // Parse each line into fields
  for (const line of lines) {
    const fields = [];
    let field = '';
    let quoted = false;

    for (let i = 0; i < line.length; i++) {
      const ch = line[i];
      if (ch === '"') {
        if (quoted && line[i + 1] === '"') {
          field += '"';
          i++; // escaped quote
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

  // Convert to objects using header row
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
// SLUG GENERATOR
// ---------------------------------------------------------------------------

function slugify(text) {
  return text
    .toString()
    .toLowerCase()
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '')  // strip diacritics
    .replace(/['']/g, '')             // remove apostrophes
    .replace(/&/g, 'and')             // ampersands
    .replace(/[^a-z0-9]+/g, '-')     // non-alphanumeric to hyphens
    .replace(/^-+|-+$/g, '')         // trim leading/trailing hyphens
    .replace(/-{2,}/g, '-');         // collapse multiple hyphens
}

// ---------------------------------------------------------------------------
// CATEGORY MAPPING
// ---------------------------------------------------------------------------

const CATEGORY_RULES = [
  { slugs: ['restaurants-food'], patterns: ['restaurant', 'food', 'seafood', 'bbq', 'diner', 'cafe', 'bakery', 'grill', 'kitchen', 'catering', 'meat', 'sauce', 'spice', 'coffee', 'tea', 'snack', 'candy', 'chocolate', 'jerky', 'crawfish', 'crab'] },
  { slugs: ['farms-agriculture'], patterns: ['farm', 'ranch', 'agriculture', 'ag ', 'feed', 'seed', 'homestead', 'honey', 'maple', 'orchard'] },
  { slugs: ['brewing-spirits'], patterns: ['brew', 'beer', 'distill', 'spirit', 'winery', 'wine', 'whiskey', 'bourbon', 'vodka', 'taproom', 'mead', 'cider'] },
  { slugs: ['handmade-artisan'], patterns: ['handmade', 'artisan', 'craft', 'wood', 'leather', 'jewel', 'maker', 'custom', 'blacksmith', 'forge', 'pottery', 'ceramics', 'candle', 'soap'] },
  { slugs: ['apparel-accessories'], patterns: ['apparel', 'clothing', 'clothes', 'wear', 'shirt', 'hat', 'boot', 'shoe', 'fashion', 'accessori', 'textile'] },
  { slugs: ['firearms-outdoors'], patterns: ['firearm', 'gun', 'outdoor', 'hunt', 'fish', 'ammo', 'range', 'tactical', 'knife', 'knives', 'outfitter'] },
  { slugs: ['home-building'], patterns: ['home', 'build', 'construct', 'contractor', 'renovation', 'furniture', 'cabinet', 'roof', 'plumb', 'hvac', 'steel', 'metal', 'iron'] },
  { slugs: ['faith-family'], patterns: ['faith', 'christian', 'church', 'catholic', 'bible', 'ministry', 'prayer', 'gospel', 'religious'] },
  { slugs: ['health-wellness'], patterns: ['health', 'wellness', 'gym', 'fitness', 'supplement', 'vitamin', 'natural', 'organic', 'yoga', 'chiropractic'] },
  { slugs: ['services-trades'], patterns: ['service', 'trade', 'repair', 'mechanic', 'electric', 'weld', 'landscap', 'clean', 'auto ', 'truck'] },
  { slugs: ['books-media'], patterns: ['book', 'media', 'author', 'publish', 'podcast', 'news', 'magazine', 'print'] },
  { slugs: ['pets-animals'], patterns: ['pet', 'animal', 'dog', 'cat', 'vet ', 'grooming'] },
];

// Category slug -> id mapping (must match seed data sort_order)
const CATEGORY_IDS = {
  'restaurants-food': 1,
  'farms-agriculture': 2,
  'brewing-spirits': 3,
  'handmade-artisan': 4,
  'apparel-accessories': 5,
  'firearms-outdoors': 6,
  'home-building': 7,
  'faith-family': 8,
  'health-wellness': 9,
  'services-trades': 10,
  'books-media': 11,
  'pets-animals': 12,
};

function mapCategory(rawCategory) {
  if (!rawCategory) return null;
  const lower = rawCategory.toLowerCase().trim();

  // Direct slug match
  if (CATEGORY_IDS[lower]) return lower;

  // Pattern matching
  for (const rule of CATEGORY_RULES) {
    for (const pattern of rule.patterns) {
      if (lower.includes(pattern)) {
        return rule.slugs[0];
      }
    }
  }

  return null;
}

// ---------------------------------------------------------------------------
// SQL ESCAPING
// ---------------------------------------------------------------------------

function esc(value) {
  if (value === null || value === undefined || value === '') return 'NULL';
  return "'" + String(value).replace(/'/g, "''") + "'";
}

function escInt(value) {
  if (value === null || value === undefined || value === '') return '0';
  const str = String(value).toLowerCase().trim();
  if (str === '1' || str === 'yes' || str === 'true' || str === 'y' || str === 'x') return '1';
  return '0';
}

// ---------------------------------------------------------------------------
// STATE ABBREVIATION MAPPING
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
  // Already a 2-char abbreviation
  if (/^[A-Z]{2}$/.test(trimmed)) return trimmed;
  if (/^[a-z]{2}$/.test(trimmed)) return trimmed.toUpperCase();
  // Full name lookup
  const abbrev = STATE_ABBREVS[trimmed.toLowerCase()];
  return abbrev || trimmed.toUpperCase().slice(0, 2);
}

// ---------------------------------------------------------------------------
// MAIN
// ---------------------------------------------------------------------------

function main() {
  const csvPath = process.argv[2];
  if (!csvPath) {
    console.error('Usage: node scripts/import-csv.js <csv-file>');
    console.error('Example: node scripts/import-csv.js data/businesses.csv');
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

  const sql = [];
  let imported = 0;
  let skipped = 0;
  const slugsSeen = new Set();

  // Header comment
  sql.push('-- ============================================');
  sql.push('-- PATRIOT DIRECTORY — IMPORT SQL');
  sql.push(`-- Generated: ${new Date().toISOString()}`);
  sql.push(`-- Source: ${path.basename(csvPath)}`);
  sql.push('-- ============================================');
  sql.push('');

  // Category inserts (idempotent — these match schema seed data)
  sql.push('-- Categories (INSERT OR IGNORE — safe to re-run)');
  sql.push("INSERT OR IGNORE INTO categories (slug, name, description, icon, sort_order) VALUES");
  sql.push("  ('restaurants-food', 'Restaurants & Food', 'American-owned restaurants, diners, BBQ, seafood, and food trucks', 'utensils', 1),");
  sql.push("  ('farms-agriculture', 'Farms & Agriculture', 'Farms, ranches, feed stores, and agricultural services', 'tractor', 2),");
  sql.push("  ('brewing-spirits', 'Brewing & Spirits', 'Craft breweries, distilleries, wineries, and taprooms', 'beer-mug', 3),");
  sql.push("  ('handmade-artisan', 'Handmade & Artisan', 'Woodworkers, leather crafters, jewelers, and artisan makers', 'hammer', 4),");
  sql.push("  ('apparel-accessories', 'Apparel & Accessories', 'American-made clothing, accessories, and footwear', 'shirt', 5),");
  sql.push("  ('firearms-outdoors', 'Firearms & Outdoors', 'Gun shops, ranges, outfitters, hunting, and outdoor gear', 'target', 6),");
  sql.push("  ('home-building', 'Home & Building', 'Contractors, builders, home goods, and home improvement', 'house', 7),");
  sql.push("  ('faith-family', 'Faith & Family', 'Faith-based businesses, family services, and community organizations', 'heart', 8),");
  sql.push("  ('health-wellness', 'Health & Wellness', 'Gyms, wellness services, supplements, and natural products', 'leaf', 9),");
  sql.push("  ('services-trades', 'Services & Trades', 'Plumbers, electricians, mechanics, and skilled tradespeople', 'wrench', 10),");
  sql.push("  ('books-media', 'Books & Media', 'Publishers, bookstores, podcasters, and content creators', 'book', 11),");
  sql.push("  ('pets-animals', 'Pets & Animals', 'Pet food, supplies, grooming, and animal services', 'paw', 12);");
  sql.push('');

  // Badge inserts (idempotent)
  sql.push('-- Badges (INSERT OR IGNORE — safe to re-run)');
  sql.push("INSERT OR IGNORE INTO badges (slug, name, description, icon, color, sort_order) VALUES");
  sql.push("  ('original-thread', 'From the Original Thread', 'Listed in the viral X thread of 129+ patriot businesses', 'fire', 'amber', 1),");
  sql.push("  ('went-viral', 'Went Viral', 'Business had its own viral patriotic moment', 'rocket', 'red', 2),");
  sql.push("  ('veteran-owned', 'Veteran Owned', 'Owned by a U.S. military veteran', 'shield', 'blue', 3),");
  sql.push("  ('made-in-usa', 'Made in USA', 'Products manufactured in the United States', 'flag', 'red', 4),");
  sql.push("  ('ships-nationwide', 'Ships Nationwide', 'Available for online ordering and shipping across the US', 'truck', 'green', 5),");
  sql.push("  ('family-business', 'Family Business', 'Family-owned and operated', 'users', 'purple', 6),");
  sql.push("  ('immigrant-founded', 'Immigrant Founded', 'Founded by immigrants living the American Dream', 'star', 'indigo', 7);");
  sql.push('');

  // Business inserts
  sql.push('-- ============================================');
  sql.push('-- BUSINESSES');
  sql.push('-- ============================================');
  sql.push('');

  for (const row of rows) {
    // Find the name field (try common column names)
    const name = row.name || row.business_name || row.business || '';
    const city = row.city || row.location_city || '';
    const state = normalizeState(row.state || row.location_state || '');
    const rawCategory = row.category || row.type || row.business_type || '';

    // Validate required fields
    if (!name.trim()) {
      console.warn(`  SKIP row ${row._row_index}: missing name`);
      skipped++;
      continue;
    }
    if (!city.trim()) {
      console.warn(`  SKIP row ${row._row_index} (${name}): missing city`);
      skipped++;
      continue;
    }
    if (!state.trim()) {
      console.warn(`  SKIP row ${row._row_index} (${name}): missing state`);
      skipped++;
      continue;
    }

    const categorySlug = mapCategory(rawCategory);
    if (!categorySlug) {
      console.warn(`  SKIP row ${row._row_index} (${name}): unknown category "${rawCategory}"`);
      skipped++;
      continue;
    }

    const categoryId = CATEGORY_IDS[categorySlug];

    // Generate unique slug
    let baseSlug = slugify(name);
    let slug = baseSlug;
    let suffix = 2;
    while (slugsSeen.has(slug)) {
      slug = `${baseSlug}-${suffix}`;
      suffix++;
    }
    slugsSeen.add(slug);

    // Extract optional fields
    const website = row.website || row.url || row.site || '';
    const twitter = (row.twitter || row.twitter_handle || row.x || row.x_handle || '').replace(/^@/, '');
    const shortDesc = row.short_description || row.description || row.tagline || '';
    const story = row.story || row.long_description || row.about || '';
    const streetAddress = row.street_address || row.address || '';
    const postalCode = row.postal_code || row.zip || row.zipcode || '';
    const phone = row.phone || row.telephone || '';
    const email = row.email || '';
    const photoUrl = row.photo_url || row.photo || row.image || '';
    const logoUrl = row.logo_url || row.logo || '';

    // Boolean flags
    const veteranOwned = escInt(row.veteran_owned || row.veteran);
    const familyOwned = escInt(row.family_owned || row.family);
    const shipsNationwide = escInt(row.ships_nationwide || row.ships);
    const madeInUsa = escInt(row.made_in_usa || row.made_in_america || row.usa);
    const womanOwned = escInt(row.woman_owned || row.women_owned);
    const immigrantOwned = escInt(row.immigrant_owned || row.immigrant);

    const sourceRowId = String(row._row_index);

    sql.push(`INSERT OR IGNORE INTO businesses (slug, name, category_id, city, state, street_address, postal_code, website, twitter_handle, phone, email, short_description, story, photo_url, logo_url, veteran_owned, woman_owned, family_owned, immigrant_owned, made_in_usa, ships_nationwide, source, source_row_id)`);
    sql.push(`  VALUES (${esc(slug)}, ${esc(name.trim())}, ${categoryId}, ${esc(city.trim())}, ${esc(state)}, ${esc(streetAddress)}, ${esc(postalCode)}, ${esc(website)}, ${esc(twitter)}, ${esc(phone)}, ${esc(email)}, ${esc(shortDesc)}, ${esc(story)}, ${esc(photoUrl)}, ${esc(logoUrl)}, ${veteranOwned}, ${womanOwned}, ${familyOwned}, ${immigrantOwned}, ${madeInUsa}, ${shipsNationwide}, 'spreadsheet', ${esc(sourceRowId)});`);
    sql.push('');

    imported++;
  }

  // Badge assignments — all imported businesses get 'original-thread' badge
  sql.push('-- ============================================');
  sql.push('-- BADGE ASSIGNMENTS');
  sql.push("-- All imported businesses get the 'original-thread' badge");
  sql.push('-- ============================================');
  sql.push('');
  sql.push("INSERT OR IGNORE INTO business_badges (business_id, badge_id)");
  sql.push("  SELECT b.id, (SELECT id FROM badges WHERE slug = 'original-thread')");
  sql.push("  FROM businesses b");
  sql.push("  WHERE b.source = 'spreadsheet';");
  sql.push('');

  // Write output
  const outputDir = path.resolve(path.dirname(csvPath));
  const outputPath = path.join(outputDir, 'import.sql');
  fs.writeFileSync(outputPath, sql.join('\n'), 'utf-8');

  console.log('');
  console.log('=== Import Summary ===');
  console.log(`  Imported: ${imported} businesses`);
  console.log(`  Skipped:  ${skipped} rows`);
  console.log(`  Output:   ${outputPath}`);
  console.log('');
  console.log('Next steps:');
  console.log(`  npx wrangler d1 execute patriot_directory_db --file=${outputPath}`);
}

main();
