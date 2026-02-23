# Patriot Directory — Technical Architecture

> Architecture notes for site-patriot-directory. Follows conventions from
> `site-directory-factory/SITE-FACTORY-PLAYBOOK.md` and proven patterns
> from `site-recordstore-directory` (recordstops.com).

---

## Table of Contents

1. [Tech Stack Decision](#tech-stack-decision)
2. [D1 Schema](#d1-schema)
3. [SSR vs SSG Decision](#ssr-vs-ssg-decision)
4. [Mapbox UX Architecture](#mapbox-ux-architecture)
5. [Google Sheets to D1 Data Pipeline](#google-sheets-to-d1-data-pipeline)
6. [Page Structure & URL Patterns](#page-structure--url-patterns)
7. [AdSense Placement Strategy](#adsense-placement-strategy)

---

## Tech Stack Decision

Following Brian's preferred stack and existing directory site patterns:

| Layer | Technology | Notes |
|-------|-----------|-------|
| **Framework** | Astro | Static-first, island architecture, proven in recordstops.com |
| **Styling** | Tailwind CSS | Consistent with all other directory sites |
| **Database** | Cloudflare D1 | Brian's preferred DB. 8 of 50k limit used. Per-site tables per playbook. |
| **Hosting** | Cloudflare Pages | Unlimited bandwidth, global CDN, auto-SSL |
| **Maps** | Mapbox GL JS v3.3 | Already licensed, used in recordstops.com. 50k free loads/month. |
| **Ads** | Google AdSense | Display ads. Upgrade to Mediavine at 50k sessions/month. |
| **Forms** | Web3Forms | 250 submissions/month free. Not needed for v1 (no self-submit). |
| **Analytics** | Plausible or Umami | Privacy-friendly, lightweight |

**Why D1 over Supabase for this site:**
- Brian's newer sites use D1 (recordstops.com migrated to D1)
- Simpler infrastructure (no external service dependency)
- Cheaper at scale (included in Cloudflare paid plan)
- All data access stays within Cloudflare's edge network
- SQLite is simpler for a read-heavy directory site

**Database name:** `patriot_directory_db`
**D1 binding name:** `DB` (consistent with recordstops.com pattern)

---

## D1 Schema

### `categories` Table

```sql
-- ============================================
-- CATEGORIES
-- ============================================
CREATE TABLE IF NOT EXISTS categories (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  slug TEXT UNIQUE NOT NULL,
  name TEXT NOT NULL,
  description TEXT,
  icon TEXT,                          -- emoji or icon name for UI
  sort_order INTEGER DEFAULT 0,
  created_at TEXT DEFAULT CURRENT_TIMESTAMP
);

-- Seed categories (8-12 based on research)
INSERT OR IGNORE INTO categories (slug, name, description, icon, sort_order) VALUES
  ('restaurants', 'Restaurants & Food', 'American-owned restaurants, diners, BBQ, and food trucks', 'utensils', 1),
  ('retail', 'Retail & Shopping', 'Clothing, general stores, and specialty retail', 'shopping-bag', 2),
  ('outdoor', 'Outdoor & Recreation', 'Gear shops, ranges, outfitters, and recreation', 'mountain', 3),
  ('home-services', 'Home Services', 'Contractors, plumbers, electricians, and home improvement', 'wrench', 4),
  ('auto', 'Auto & Powersports', 'Dealerships, mechanics, detailing, and parts', 'truck', 5),
  ('fitness', 'Fitness & Wellness', 'Gyms, martial arts, wellness, and health services', 'dumbbell', 6),
  ('professional', 'Professional Services', 'Legal, financial, insurance, and consulting', 'briefcase', 7),
  ('agriculture', 'Agriculture & Farming', 'Farms, ranches, feed stores, and ag services', 'tractor', 8),
  ('manufacturing', 'Manufacturing & Trades', 'Fabrication, welding, construction, and skilled trades', 'hammer', 9),
  ('tech', 'Technology & Media', 'Tech companies, media outlets, podcasts, and digital services', 'monitor', 10),
  ('education', 'Education & Training', 'Schools, tutoring, training programs, and youth orgs', 'book', 11),
  ('faith-community', 'Faith & Community', 'Churches, nonprofits, veteran orgs, and community groups', 'heart', 12);
```

### `businesses` Table

```sql
-- ============================================
-- BUSINESSES
-- ============================================
CREATE TABLE IF NOT EXISTS businesses (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  slug TEXT UNIQUE NOT NULL,
  name TEXT NOT NULL,

  -- Categorization
  category_id INTEGER NOT NULL,

  -- Location
  city TEXT NOT NULL,
  state TEXT NOT NULL,
  street_address TEXT,
  postal_code TEXT,
  latitude REAL,
  longitude REAL,

  -- Contact & Social
  website TEXT,
  twitter_handle TEXT,             -- X/Twitter handle (without @)
  phone TEXT,
  email TEXT,

  -- Content
  short_description TEXT,          -- 1-2 sentence tagline for cards
  story TEXT,                      -- Longer origin story / "why patriot" narrative

  -- Media
  photo_url TEXT,                  -- Primary photo
  logo_url TEXT,

  -- Status & Curation
  verified INTEGER DEFAULT 0,     -- 1 = business owner confirmed listing
  featured INTEGER DEFAULT 0,     -- 1 = shows on homepage / top of category

  -- Source tracking
  source TEXT DEFAULT 'spreadsheet', -- spreadsheet, manual, submission
  source_row_id TEXT,               -- Row ID from Google Sheets for dedup

  -- Metadata
  created_at TEXT DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT DEFAULT CURRENT_TIMESTAMP,

  FOREIGN KEY (category_id) REFERENCES categories(id)
);

-- Indexes for common queries
CREATE INDEX IF NOT EXISTS idx_businesses_slug ON businesses(slug);
CREATE INDEX IF NOT EXISTS idx_businesses_category ON businesses(category_id);
CREATE INDEX IF NOT EXISTS idx_businesses_state ON businesses(state);
CREATE INDEX IF NOT EXISTS idx_businesses_city ON businesses(city);
CREATE INDEX IF NOT EXISTS idx_businesses_state_city ON businesses(state, city);
CREATE INDEX IF NOT EXISTS idx_businesses_featured ON businesses(featured);
CREATE INDEX IF NOT EXISTS idx_businesses_source_row ON businesses(source_row_id);
```

### `submissions` Table (for future v2 self-submit)

```sql
-- ============================================
-- SUBMISSIONS (v2 — not used in v1)
-- ============================================
CREATE TABLE IF NOT EXISTS submissions (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  type TEXT NOT NULL DEFAULT 'business_submit',

  -- Business info
  business_name TEXT NOT NULL,
  category_slug TEXT,
  city TEXT,
  state TEXT,
  website TEXT,
  twitter_handle TEXT,
  description TEXT,

  -- Submitter info
  contact_name TEXT,
  contact_email TEXT NOT NULL,

  -- Status
  status TEXT DEFAULT 'pending',   -- pending, approved, rejected, spam
  notes TEXT,

  -- Metadata
  created_at TEXT DEFAULT CURRENT_TIMESTAMP,
  reviewed_at TEXT
);

CREATE INDEX IF NOT EXISTS idx_submissions_status ON submissions(status);
```

### Design Notes

- **INTEGER PRIMARY KEY AUTOINCREMENT** — D1/SQLite pattern (not UUID like Supabase)
- **TEXT for timestamps** — D1 uses `CURRENT_TIMESTAMP` which returns ISO text
- **INTEGER for booleans** — SQLite convention (0/1 instead of true/false)
- **FOREIGN KEY on category_id** — Enforces valid category references
- **source_row_id** — Deduplication key for Google Sheets imports; prevents re-importing the same row
- **Indexes on state, city, category_id** — Covers all filter/query patterns

---

## SSR vs SSG Decision

### Recommendation: Hybrid (`output: 'server'` with `prerender: true` on most pages)

This is the same pattern used by recordstops.com. Here is the justification:

```javascript
// astro.config.mjs
import { defineConfig } from 'astro/config';
import cloudflare from '@astrojs/cloudflare';
import tailwind from '@astrojs/tailwind';
import sitemap from '@astrojs/sitemap';

export default defineConfig({
  site: 'https://patriotdirectory.com', // TBD
  output: 'server',
  adapter: cloudflare({
    platformProxy: { enabled: true },
  }),
  integrations: [tailwind(), sitemap()],
});
```

### Why Hybrid (Not Pure SSG or Pure SSR)

| Approach | Pros | Cons | Verdict |
|----------|------|------|---------|
| **Pure SSG** | Fastest load, cheapest | Can't query D1 at build time (D1 is runtime-only on CF Pages) | Not possible with D1 |
| **Pure SSR** | Full D1 access, dynamic filtering | Every page hit runs on CF Workers | Unnecessary overhead for static content |
| **Hybrid** | Best of both: prerender static pages, SSR for dynamic ones | Slight config complexity | **Best fit** |

**The key constraint:** Cloudflare D1 is only accessible at runtime via `Astro.locals.runtime.env.DB`. You cannot query D1 during `astro build`. This means all pages that read from D1 must be SSR (`export const prerender = false`).

### Page Rendering Strategy

| Page | Render Mode | Why |
|------|-------------|-----|
| `/` (Home) | SSR (`prerender = false`) | Queries D1 for featured businesses, counts |
| `/directory` | SSR | Queries D1 for all businesses with filters |
| `/category/[slug]` | SSR | Queries D1 for businesses in category |
| `/[state]/[city]` | SSR | Queries D1 for businesses in city |
| `/business/[slug]` | SSR | Queries D1 for single business |
| `/map` | SSR | Queries D1 for all businesses with coordinates |
| `/about` | SSG (`prerender = true`) | Static content, no DB |
| `/privacy` | SSG | Static content |
| `/terms` | SSG | Static content |

> **Note:** At recordstops.com, Brian uses `output: 'server'` (default SSR) and only
> marks static pages with `export const prerender = true`. This is the simplest approach.
> Pages that need D1 don't need any annotation — they're SSR by default.

### Performance Considerations

- **CF Workers are fast:** ~5-15ms cold start, D1 queries are sub-ms on edge
- **Smart caching:** Add `Cache-Control` headers on SSR responses for pages that don't change often (e.g., business detail pages can cache for 1 hour)
- **Mapbox loads client-side:** No SSR penalty for the map; it initializes in the browser

---

## Mapbox UX Architecture

### Overview

The map is the core differentiator for this site. Users should be able to find patriot
businesses near them visually. The implementation follows the proven pattern from
recordstops.com's `StoreMap.astro` component but adds category filtering and a
sidebar list.

### Map Page UX (`/map`)

**Layout: Split-screen on desktop, stacked on mobile**

```
Desktop (lg+):
┌──────────────────────────────────────────────────┐
│  Filters: [Category ▾] [State ▾] [Search...]     │
├────────────────────┬─────────────────────────────┤
│                    │                             │
│   Sidebar List     │       Mapbox Map            │
│   (scrollable)     │       (clustered markers)   │
│                    │                             │
│   Business 1  ▸    │       [cluster: 12]         │
│   Business 2  ▸    │                  •          │
│   Business 3  ▸    │          •                  │
│   Business 4  ▸    │     [cluster: 5]  •         │
│   ...              │                             │
│                    │                             │
│  Showing 42 of 129 │                             │
├────────────────────┴─────────────────────────────┤
│  Footer                                          │
└──────────────────────────────────────────────────┘

Mobile:
┌────────────────────┐
│ Filters (collapsed)│
├────────────────────┤
│                    │
│   Mapbox Map       │
│   (full width)     │
│   height: 50vh     │
│                    │
├────────────────────┤
│   List View        │
│   (scrollable)     │
│   Business 1  ▸    │
│   Business 2  ▸    │
│   ...              │
└────────────────────┘
```

### Mapbox Feature Breakdown

#### 1. Marker Clustering

When zoomed out, markers cluster into numbered circles. This prevents the map from
becoming a mess with 129+ pins.

```javascript
// Use Mapbox's built-in clustering via GeoJSON source
map.addSource('businesses', {
  type: 'geojson',
  data: geojsonData,
  cluster: true,
  clusterMaxZoom: 14,
  clusterRadius: 50,
});

// Cluster circle layer
map.addLayer({
  id: 'clusters',
  type: 'circle',
  source: 'businesses',
  filter: ['has', 'point_count'],
  paint: {
    'circle-color': '#1e40af',      // Patriotic blue
    'circle-radius': ['step', ['get', 'point_count'], 20, 10, 30, 50, 40],
  },
});

// Cluster count text
map.addLayer({
  id: 'cluster-count',
  type: 'symbol',
  source: 'businesses',
  filter: ['has', 'point_count'],
  layout: {
    'text-field': ['get', 'point_count_abbreviated'],
    'text-size': 14,
  },
  paint: { 'text-color': '#ffffff' },
});
```

**Why clustering over individual markers:**
- 129+ markers at zoom level 4 (USA view) would overlap badly
- Clusters give a sense of density ("there are 12 businesses near Dallas")
- Click-to-zoom on cluster is intuitive
- Mapbox's built-in clustering is performant and renders on GPU

#### 2. Category Filtering on Map

Filters update both the sidebar list AND the map markers simultaneously.

```javascript
// When category filter changes:
function filterByCategory(categorySlug) {
  const filtered = allBusinesses.filter(b =>
    !categorySlug || b.category_slug === categorySlug
  );

  // Update GeoJSON source (re-renders markers + clusters)
  map.getSource('businesses').setData(toGeoJSON(filtered));

  // Update sidebar list
  updateSidebarList(filtered);
}
```

#### 3. Popup on Marker Click

Clicking a marker shows a popup with:
- Business name
- Category badge
- City, State
- Short description (truncated)
- "View Details" link to `/business/[slug]`

This matches the recordstops.com pattern from `StoreMap.astro`.

#### 4. Sidebar List Interaction

- Hovering a sidebar item highlights the corresponding marker on the map
- Clicking a sidebar item flies the map to that marker and opens its popup
- The sidebar list updates when map bounds change (optional v2 enhancement)

#### 5. "Find Near Me" / Geolocation

```javascript
// Browser geolocation API
map.addControl(
  new mapboxgl.GeolocateControl({
    positionOptions: { enableHighAccuracy: true },
    trackUserLocation: false,
    showUserHeading: false,
  }),
  'top-right'
);
```

The Mapbox `GeolocateControl` button lets users center the map on their location.
Combined with clustering, they immediately see nearby businesses.

#### 6. "Show me restaurants near Baltimore" UX Flow

1. User selects **"Restaurants & Food"** from category dropdown
2. Map filters to show only restaurant markers/clusters
3. User either:
   - a. Clicks the geolocation button (if near Baltimore), OR
   - b. Types "Baltimore" in the search box, which uses Mapbox Geocoding to fly to Baltimore
4. Map zooms to Baltimore area, clusters expand to show individual restaurants
5. Sidebar list updates to show only visible restaurants
6. User clicks a marker or sidebar item to see details

**Mapbox Geocoding for search (optional but recommended):**
```javascript
// Mapbox Geocoder control for place search
import MapboxGeocoder from '@mapbox/mapbox-gl-geocoder';

map.addControl(
  new MapboxGeocoder({
    accessToken: mapboxgl.accessToken,
    mapboxgl: mapboxgl,
    placeholder: 'Search city or zip...',
    countries: 'us',
    types: 'place,postcode',
  }),
  'top-left'
);
```

### Color Scheme for Map

Patriotic theme:
- **Cluster circles:** Navy blue (`#1e40af`)
- **Individual markers:** Red (`#dc2626`) or custom flag-themed pin
- **Popup accent:** Navy blue header, red CTA button
- **Map style:** `mapbox://styles/mapbox/light-v11` (clean, doesn't compete with markers)

### Mapbox Token

Stored as environment variable: `PUBLIC_MAPBOX_TOKEN`
Injected via `<meta name="mapbox-token">` tag in BaseLayout (same pattern as recordstops.com).

---

## Google Sheets to D1 Data Pipeline

### Recommendation: Option (a) — Manual CSV Export + Import Script

**Why this is the right v1 approach:**

| Option | Complexity | Maintenance | When to Use |
|--------|-----------|-------------|-------------|
| **(a) CSV export + script** | Low | None | v1 — data changes infrequently |
| (b) Worker cron + Sheets API | Medium | Google API key management, error handling | v2 — if data updates weekly+ |
| (c) Admin page with paste | Medium | UI to build/maintain | v2 — if non-technical person manages data |

The spreadsheet has ~129 businesses. This is a one-time initial import with occasional
updates. A script is the simplest, most reliable approach.

### Import Workflow

```
Google Spreadsheet
    │
    ├── File → Download → CSV
    │
    ▼
scripts/import-csv.js
    │
    ├── Reads CSV
    ├── Validates required fields (name, city, state, category)
    ├── Generates slugs
    ├── Geocodes addresses (Mapbox Geocoding API) for lat/lng
    ├── Maps spreadsheet categories → category_id
    ├── Deduplicates by source_row_id
    │
    ▼
Cloudflare D1 (via wrangler d1 execute)
```

### Import Script (`scripts/import-csv.js`)

```javascript
// scripts/import-csv.js
// Usage: node scripts/import-csv.js data/businesses.csv
//
// Expected CSV columns:
//   Name, Category, City, State, Website, Twitter, Short Description, Story
//
// Outputs: data/import.sql (run with wrangler d1 execute)

import { parse } from 'csv-parse/sync';
import fs from 'fs';

const csvPath = process.argv[2];
if (!csvPath) {
  console.error('Usage: node scripts/import-csv.js <path-to-csv>');
  process.exit(1);
}

const CATEGORY_MAP = {
  'Restaurants': 1,
  'Retail': 2,
  'Outdoor': 3,
  // ... map all spreadsheet categories to category IDs
};

const csv = fs.readFileSync(csvPath, 'utf-8');
const records = parse(csv, { columns: true, skip_empty_lines: true });

function slugify(text) {
  return text.toLowerCase()
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/(^-|-$)/g, '');
}

const statements = records.map((row, i) => {
  const slug = slugify(row['Name']);
  const categoryId = CATEGORY_MAP[row['Category']] || 1;

  return `INSERT OR IGNORE INTO businesses
    (slug, name, category_id, city, state, website, twitter_handle,
     short_description, story, source, source_row_id)
  VALUES
    ('${slug}', '${row['Name'].replace(/'/g, "''")}', ${categoryId},
     '${row['City'].replace(/'/g, "''")}', '${row['State']}',
     ${row['Website'] ? `'${row['Website']}'` : 'NULL'},
     ${row['Twitter'] ? `'${row['Twitter'].replace('@', '')}'` : 'NULL'},
     ${row['Short Description'] ? `'${row['Short Description'].replace(/'/g, "''")}'` : 'NULL'},
     ${row['Story'] ? `'${row['Story'].replace(/'/g, "''")}'` : 'NULL'},
     'spreadsheet', '${i + 1}');`;
});

fs.writeFileSync('data/import.sql', statements.join('\n\n'));
console.log(`Generated ${statements.length} INSERT statements → data/import.sql`);
console.log('Run: npx wrangler d1 execute patriot_directory_db --file=data/import.sql');
```

### Geocoding Script (`scripts/geocode.js`)

After initial import, run a separate geocoding pass to fill in lat/lng:

```javascript
// scripts/geocode.js
// Reads businesses without coordinates from D1, geocodes via Mapbox, updates D1
//
// Usage: npx wrangler d1 execute patriot_directory_db \
//          --command="SELECT id, name, city, state FROM businesses WHERE latitude IS NULL" \
//          --json | node scripts/geocode.js

// Uses Mapbox Geocoding API: GET https://api.mapbox.com/geocoding/v5/mapbox.places/{query}.json
// Free tier: 100k requests/month (more than enough for 129 businesses)
```

### Future v2: Worker Cron + Google Sheets API

If the spreadsheet grows and updates frequently, build a Cloudflare Worker cron:

```
Worker cron (daily/weekly)
    │
    ├── Fetch Google Sheets API (read-only, published sheet)
    ├── Compare with existing D1 data
    ├── Insert new rows, update changed rows
    ├── Log sync results
    │
    ▼
D1 database updated
```

This is NOT needed for v1. The spreadsheet has 129 rows and manual CSV import takes
under 5 minutes.

---

## Page Structure & URL Patterns

### All Pages

| Page | URL | Purpose | Render |
|------|-----|---------|--------|
| **Home** | `/` | Hero, featured businesses, category grid, CTA | SSR |
| **Directory** | `/directory` | All businesses with search, filters, grid/map toggle | SSR |
| **Category** | `/category/[slug]` | Businesses filtered by category (e.g., `/category/restaurants`) | SSR |
| **State** | `/[state]` | Businesses in state (e.g., `/texas`, `/virginia`) | SSR |
| **City** | `/[state]/[city]` | Businesses in city (e.g., `/texas/dallas`) — programmatic SEO | SSR |
| **Business Detail** | `/business/[slug]` | Full detail page with story, map pin, contact info | SSR |
| **Map** | `/map` | Full-screen map with sidebar list, filters | SSR |
| **About** | `/about` | Mission, story behind the directory | SSG |
| **Privacy** | `/privacy` | Privacy policy | SSG |
| **Terms** | `/terms` | Terms of service | SSG |

### URL Conventions

- **State slugs:** Lowercase, hyphenated: `/north-carolina`, `/new-york`
- **City slugs:** Lowercase, hyphenated: `/texas/san-antonio`
- **Category slugs:** Match `categories.slug` column: `/category/restaurants`
- **Business slugs:** Generated from business name: `/business/joes-bbq-shack`

### SEO Page Strategy

**City pages (`/[state]/[city]`)** are the biggest SEO opportunity. Each page targets:
- "patriot businesses in [City], [State]"
- "pro-American businesses [City]"
- "conservative-friendly businesses near [City]"

Even with 129 businesses across maybe 40-60 unique cities, that's 40-60 indexable
city pages, each with unique content.

**Category pages (`/category/[slug]`)** target:
- "patriot [category] businesses"
- "American-owned [category]"
- "pro-American restaurants" / "patriot contractors" etc.

### Page Content Details

#### Home (`/`)

```
┌─────────────────────────────────────────────────┐
│  Hero: "Support American Businesses"             │
│  Subtitle: "Find 129+ pro-American businesses"   │
│  [Browse Directory]  [View Map]                  │
├─────────────────────────────────────────────────┤
│  Category Grid (3x4 cards with icons)            │
│  Restaurants  Retail  Outdoor  Home Services ...  │
├─────────────────────────────────────────────────┤
│  Featured Businesses (4-6 cards)                 │
├─────────────────────────────────────────────────┤
│  [AdSense: in-content]                           │
├─────────────────────────────────────────────────┤
│  Browse by State (grid of state links)           │
├─────────────────────────────────────────────────┤
│  "Know a patriot business?" CTA                  │
│  (links to submission form in v2, or contact)    │
└─────────────────────────────────────────────────┘
```

#### Business Detail (`/business/[slug]`)

```
┌─────────────────────────────────────────────────┐
│  Breadcrumb: Home > Restaurants > Joe's BBQ      │
├─────────────────────────────────────────────────┤
│  Business Name          [Category Badge]         │
│  City, State            [Verified Badge]         │
│  ★★★★☆ (if rated)                               │
├─────────────────────────────────────────────────┤
│  Photo (if available)                            │
├─────────────────────────────────────────────────┤
│  Story / Origin                                  │
│  "Joe started this BBQ joint in 2012..."         │
├─────────────────────────────────────────────────┤
│  Contact Info                                    │
│  Website | Twitter | Phone                       │
├─────────────────────────────────────────────────┤
│  [AdSense: in-content]                           │
├─────────────────────────────────────────────────┤
│  Mini Map (single pin)                           │
├─────────────────────────────────────────────────┤
│  "More [Category] Businesses" (3-4 cards)        │
└─────────────────────────────────────────────────┘
```

### Schema.org Markup

Every business detail page includes LocalBusiness structured data:

```json
{
  "@context": "https://schema.org",
  "@type": "LocalBusiness",
  "name": "Joe's BBQ Shack",
  "description": "Family-owned BBQ joint since 2012...",
  "address": {
    "@type": "PostalAddress",
    "addressLocality": "Dallas",
    "addressRegion": "TX"
  },
  "url": "https://joes-bbq.com",
  "geo": {
    "@type": "GeoCoordinates",
    "latitude": 32.7767,
    "longitude": -96.7970
  }
}
```

---

## AdSense Placement Strategy

### Principles

1. **Never block the primary content** — Ads supplement, not interrupt
2. **No ads above the fold on mobile** — Google penalizes this
3. **Maximum 3 ad units per page** — Keep it clean
4. **Use responsive ad units** — Let Google optimize sizing

### Placements by Page Type

#### Home Page

| Position | Ad Type | Notes |
|----------|---------|-------|
| Below category grid | In-feed / display | Between sections, natural break point |
| Above footer | Display (728x90 or responsive) | Low-impact, high viewability |

**No ads in:** Hero section, featured businesses row

#### Directory / Category / City Pages

| Position | Ad Type | Notes |
|----------|---------|-------|
| After every 8 business cards | In-feed | Blends with card grid |
| Sidebar (desktop only) | Display (300x250) | Only if layout has sidebar |

**No ads in:** Filter bar, search area, map view

#### Business Detail Page

| Position | Ad Type | Notes |
|----------|---------|-------|
| Below story section | In-article | After the main content, before contact info |
| After "More Businesses" section | Display | End of page, before footer |

**No ads in:** Contact info section, map, breadcrumbs

#### Map Page

| Position | Ad Type | Notes |
|----------|---------|-------|
| Below map (mobile only) | Display | Map is the feature — don't obstruct it |

**No ads in:** Map overlay, sidebar list, filter bar

### AdSense Component

```astro
<!-- src/components/AdSlot.astro -->
---
interface Props {
  slot: 'in-content' | 'sidebar' | 'footer' | 'in-feed';
  class?: string;
}

const { slot, class: className = '' } = Astro.props;
---

<div class={`ad-container my-6 ${className}`} data-ad-slot={slot}>
  <!-- Replace with actual AdSense code when approved -->
  <!-- <ins class="adsbygoogle"
       style="display:block"
       data-ad-client="ca-pub-XXXXX"
       data-ad-slot="YYYYY"
       data-ad-format="auto"
       data-full-width-responsive="true"></ins>
  <script>(adsbygoogle = window.adsbygoogle || []).push({});</script> -->
</div>
```

**Comment out ad code until AdSense is approved.** This is the playbook pattern —
build the slots, hide until live.

---

## Appendix: Project File Structure

```
site-patriot-directory/
├── src/
│   ├── components/
│   │   ├── Header.astro
│   │   ├── Footer.astro
│   │   ├── BusinessCard.astro
│   │   ├── BusinessGrid.astro
│   │   ├── BusinessMap.astro          # Mapbox component (from StoreMap pattern)
│   │   ├── CategoryCard.astro
│   │   ├── FilterBar.astro
│   │   ├── AdSlot.astro
│   │   └── SEOHead.astro
│   │
│   ├── layouts/
│   │   └── BaseLayout.astro
│   │
│   ├── pages/
│   │   ├── index.astro                # Home
│   │   ├── directory.astro            # Browse all
│   │   ├── map.astro                  # Full map view
│   │   ├── about.astro
│   │   ├── privacy.astro
│   │   ├── terms.astro
│   │   ├── category/
│   │   │   └── [slug].astro           # Category pages
│   │   ├── business/
│   │   │   └── [slug].astro           # Business detail
│   │   └── [state]/
│   │       ├── index.astro            # State page
│   │       └── [city].astro           # City page (SEO)
│   │
│   ├── lib/
│   │   ├── db.ts                      # D1 query helpers
│   │   └── utils.ts                   # Slug helpers, formatters
│   │
│   ├── data/
│   │   ├── categories.json            # Category definitions
│   │   └── site-config.json           # Site branding/settings
│   │
│   └── styles/
│       └── global.css
│
├── scripts/
│   ├── import-csv.js                  # Google Sheets CSV → D1 SQL
│   └── geocode.js                     # Batch geocoding for lat/lng
│
├── data/
│   ├── businesses.csv                 # Exported from Google Sheets
│   └── import.sql                     # Generated by import script
│
├── db/
│   └── schema.sql                     # Full D1 schema (categories + businesses + submissions)
│
├── public/
│   ├── favicon.ico
│   ├── og-image.png
│   └── robots.txt
│
├── astro.config.mjs
├── tailwind.config.mjs
├── wrangler.toml
├── package.json
├── .env.example
├── CLAUDE.md
└── progress.txt
```

### `wrangler.toml`

```toml
name = "patriot-directory"
compatibility_date = "2024-12-01"
pages_build_output_dir = "./dist"

[[d1_databases]]
binding = "DB"
database_name = "patriot_directory_db"
database_id = "TBD"  # Created via: npx wrangler d1 create patriot_directory_db
```

### `.env.example`

```
PUBLIC_MAPBOX_TOKEN=pk.xxxxx
PUBLIC_SITE_URL=https://patriotdirectory.com
```

---

## Summary of Key Decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Database | Cloudflare D1 | Brian's preferred DB, same as recordstops.com |
| Rendering | Hybrid (server default, prerender static) | D1 requires runtime access; matches recordstops pattern |
| Map library | Mapbox GL JS v3.3 | Already licensed, proven in portfolio |
| Map UX | Clustered markers + sidebar + category filter | Handles 129+ markers cleanly, intuitive UX |
| Data ingestion | CSV export + import script | Simplest for v1; 129 rows, infrequent updates |
| Categories | 12 seeded categories | Covers all business types in patriot niche |
| URL structure | `/[state]/[city]` for SEO, `/business/[slug]` for detail | Maximizes programmatic SEO surface area |
| Ad placement | 3 units max per page, never above fold on mobile | Clean UX, follows AdSense best practices |
