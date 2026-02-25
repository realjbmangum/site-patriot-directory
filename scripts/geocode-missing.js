#!/usr/bin/env node
/**
 * geocode-missing.js — Geocode the 45 csv-batch businesses using Nominatim
 *
 * No API key required. Rate-limited to 1 req/sec per Nominatim policy.
 * Output: data/geocode-missing.sql
 * Apply:  npx wrangler d1 execute patriot_directory_db --remote --file=data/geocode-missing.sql
 */

import { writeFileSync } from 'fs';

const OUTPUT = 'data/geocode-missing.sql';

// Businesses needing geocoding — city/state from seed SQL
// Businesses with city='Unknown' and state='USA' are skipped (no useful location)
const BUSINESSES = [
  // Group A
  { slug: 'humming-meadow-honey',          city: null,           state: 'VT' },
  { slug: 'kiel-james-patrick',            city: 'Newport',      state: 'RI' },
  { slug: 'the-buffalo-wool-co',           city: null,           state: 'TX' },
  { slug: 'the-woolshire',                 city: null,           state: 'ID' },
  { slug: 'fox-and-root',                  city: null,           state: 'MI' },
  { slug: 'ambrosian-candle-co',           city: null,           state: 'NY' },
  { slug: 'tamburn-bindery',               city: null,           state: 'VA' },
  { slug: 'middleborne-arms',              city: 'Carpenter',    state: 'MO' },
  { slug: 'black-wolf-homestead',          city: 'Richmond',     state: 'VA' },
  { slug: 'baritus-catholic-illustration', city: null,           state: 'GA' },
  // Group B
  { slug: 'orthodox-mason',                city: 'Saxtons River', state: 'VT' },
  { slug: 'seraphim-print-studio',         city: 'Trinity',      state: 'AL' },
  { slug: 'gubba-homestead',               city: 'Seattle',      state: 'WA' },
  { slug: 'wading-smith-woodworks',        city: null,           state: 'PA' },
  { slug: 'cottage-pastures',              city: 'Vevay',        state: 'IN' },
  { slug: 'wasson-watch-co',               city: 'Richardson',   state: 'TX' },
  { slug: 'peaces-of-indigo',              city: null,           state: 'TN' },
  { slug: 'nicholas-hayford-jewelry',      city: 'Memphis',      state: 'TN' },
  { slug: 'eli-sherbondy-machining',       city: null,           state: 'PA' },
  { slug: 'primal-aromas',                 city: null,           state: 'IA' },
  { slug: 'evers-forge-works',             city: 'Eagle Pass',   state: 'TX' },
  { slug: 'silver-gold-honey-company',     city: null,           state: 'WI' },
  { slug: 'armadillo-acres-farm',          city: 'Indianola',    state: 'IA' },
  { slug: 'tlc-ranch',                     city: 'Burneyville',  state: 'OK' },
  // Group C
  { slug: 'puresteel-co',                  city: 'Austin',       state: 'TX' },
  { slug: 'taylor-shellfish-farms',        city: 'Shelton',      state: 'WA' },
  { slug: 'appalachian-wood-homestead',    city: null,           state: 'SC' },
  { slug: 'parros-gun-shop',               city: 'Waterbury',    state: 'VT' },
  { slug: 'benford-brewing',               city: 'Lancaster',    state: 'SC' },
  { slug: 'louisiana-crawfish-company',    city: 'Natchitoches', state: 'LA' },
  { slug: 'she-must-be-loved',             city: 'Pickerington', state: 'OH' },
];

// State centroids as fallback when city is null
const STATE_CENTROIDS = {
  AL: [32.806671, -86.791130], AK: [61.370716, -152.404419],
  AZ: [33.729759, -111.431221], AR: [34.969704, -92.373123],
  CA: [36.116203, -119.681564], CO: [39.059811, -105.311104],
  CT: [41.597782, -72.755371], DE: [39.318523, -75.507141],
  FL: [27.766279, -81.686783], GA: [33.040619, -83.643074],
  HI: [21.094318, -157.498337], ID: [44.240459, -114.478828],
  IL: [40.349457, -88.986137], IN: [39.849426, -86.258278],
  IA: [42.011539, -93.210526], KS: [38.526600, -96.726486],
  KY: [37.668140, -84.670067], LA: [31.169960, -91.867805],
  ME: [44.693947, -69.381927], MD: [39.063946, -76.802101],
  MA: [42.230171, -71.530106], MI: [43.326618, -84.536095],
  MN: [45.694454, -93.900192], MS: [32.741646, -89.678696],
  MO: [38.456085, -92.288368], MT: [46.921925, -110.454353],
  NE: [41.125370, -98.268082], NV: [38.313515, -117.055374],
  NH: [43.452492, -71.563896], NJ: [40.298904, -74.521011],
  NM: [34.840515, -106.248482], NY: [42.165726, -74.948051],
  NC: [35.630066, -79.806419], ND: [47.528912, -99.784012],
  OH: [40.388783, -82.764915], OK: [35.565342, -96.928917],
  OR: [44.572021, -122.070938], PA: [40.590752, -77.209755],
  RI: [41.680893, -71.511780], SC: [33.856892, -80.945007],
  SD: [44.299782, -99.438828], TN: [35.747845, -86.692345],
  TX: [31.054487, -97.563461], UT: [40.150032, -111.862434],
  VT: [44.045876, -72.710686], VA: [37.769337, -78.169968],
  WA: [47.400902, -121.490494], WV: [38.491226, -80.954453],
  WI: [44.268543, -89.616508], WY: [42.755966, -107.302490],
};

function sleep(ms) { return new Promise(r => setTimeout(r, ms)); }

async function geocodeNominatim(city, state) {
  const q = city ? `${city}, ${state}, USA` : `${state}, USA`;
  const url = `https://nominatim.openstreetmap.org/search?q=${encodeURIComponent(q)}&format=json&limit=1&countrycodes=us`;

  const res = await fetch(url, {
    headers: { 'User-Agent': 'PatriotDirectory/1.0 (geocoding batch script)' },
    signal: AbortSignal.timeout(10000),
  });

  if (!res.ok) throw new Error(`HTTP ${res.status}`);
  const data = await res.json();
  if (data.length > 0) {
    return { lat: parseFloat(data[0].lat), lng: parseFloat(data[0].lon) };
  }
  return null;
}

async function main() {
  const updates = [];
  const fallbacks = [];
  const failed = [];

  for (const biz of BUSINESSES) {
    const label = `${biz.slug} (${biz.city ?? 'state-only'}, ${biz.state})`;
    process.stdout.write(`📍 ${label} ... `);

    // Try Nominatim first
    let coords = null;
    try {
      coords = await geocodeNominatim(biz.city, biz.state);
      await sleep(1100); // Nominatim: max 1 req/sec
    } catch (err) {
      console.log(`✗ ${err.message}`);
    }

    if (coords) {
      console.log(`✓ ${coords.lat.toFixed(4)}, ${coords.lng.toFixed(4)}`);
      updates.push(`UPDATE businesses SET latitude = ${coords.lat}, longitude = ${coords.lng} WHERE slug = '${biz.slug}';`);
    } else if (!biz.city && STATE_CENTROIDS[biz.state]) {
      // Fall back to state centroid
      const [lat, lng] = STATE_CENTROIDS[biz.state];
      console.log(`↩ state centroid ${lat.toFixed(4)}, ${lng.toFixed(4)}`);
      updates.push(`UPDATE businesses SET latitude = ${lat}, longitude = ${lng} WHERE slug = '${biz.slug}';`);
      fallbacks.push(biz.slug);
    } else {
      console.log('✗ no result');
      failed.push(biz.slug);
    }
  }

  const sql = [
    '-- Auto-generated by scripts/geocode-missing.js',
    '-- Apply: npx wrangler d1 execute patriot_directory_db --remote --file=data/geocode-missing.sql',
    '',
    ...updates,
  ].join('\n');

  writeFileSync(OUTPUT, sql);

  console.log('\n─────────────────────────────────────────');
  console.log(`✓ ${updates.length - fallbacks.length} geocoded via Nominatim`);
  console.log(`↩ ${fallbacks.length} used state centroid: ${fallbacks.join(', ')}`);
  console.log(`✗ ${failed.length} failed: ${failed.join(', ')}`);
  console.log(`\nSQL written to ${OUTPUT}`);
}

main().catch(err => { console.error(err); process.exit(1); });
