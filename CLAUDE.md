# Patriot Business Directory

> A free, fast, map-first directory of patriot-owned and pro-American small businesses.

## Stack

- **Framework:** Astro (SSR via `@astrojs/cloudflare`)
- **Styling:** Tailwind CSS
- **Database:** Cloudflare D1 (SQLite)
- **Hosting:** Cloudflare Pages
- **Maps:** Mapbox GL JS v3.3
- **Charts:** Chart.js (stats on home page)
- **Ads:** Google AdSense (commented out until approved)

## Key Configuration

- **D1 database name:** `patriot_directory_db`
- **D1 binding:** `DB` (accessed via `Astro.locals.runtime.env.DB`)
- **Rendering:** `output: 'server'` (SSR default). Static pages: `/about`, `/privacy`, `/terms`

## Commands

```bash
npm run dev              # Local dev server
npm run build            # Production build
npx wrangler pages dev ./dist --d1=DB   # Local dev with D1
```

## Environment Variables

| Variable | Purpose |
|----------|---------|
| `PUBLIC_MAPBOX_TOKEN` | Mapbox GL JS access token (client-side) |
| `PUBLIC_SITE_URL` | Canonical site URL |

The D1 binding (`DB`) is configured in `wrangler.toml`, not as an env var.

## Design System

**God Bless America Theme:**

| Token | Color | Hex |
|-------|-------|-----|
| Navy | Primary backgrounds, headers | `#1e2d4f` |
| Crimson | CTAs, accents, badges | `#c41e3a` |
| Gold | Highlights, stars, featured | `#d4a017` |
| White | Card backgrounds, body text bg | `#ffffff` |
| Cream | Section backgrounds | `#faf8f5` |

## Database Schema

Schema: `db/schema.sql`

**Tables:**
- `categories` — 12 business categories (restaurants, farms, brewing, etc.)
- `businesses` — Core listing table with location, contact, ownership flags
- `badges` — 7 badge types (Original Thread, Veteran Owned, Made in USA, etc.)
- `business_badges` — Many-to-many junction table
- `submissions` — v2, not used in v1

## Data Pipeline

```
Google Spreadsheet → Export CSV → data/businesses.csv
  → node scripts/import-csv.js data/businesses.csv → data/import.sql
  → npx wrangler d1 execute patriot_directory_db --file=data/import.sql
  → MAPBOX_TOKEN=xxx node scripts/geocode.js data/businesses.csv → data/geocode-update.sql
  → npx wrangler d1 execute patriot_directory_db --file=data/geocode-update.sql
```

## Key Files

| File | Purpose |
|------|---------|
| `PRD.md` | Full product requirements document |
| `db/schema.sql` | D1 schema with seed data |
| `scripts/import-csv.js` | CSV to SQL import script |
| `scripts/geocode.js` | Batch Mapbox geocoding |
| `src/lib/db.ts` | D1 query helpers |
| `src/lib/utils.ts` | Slug helpers, formatters |
| `src/data/site-config.json` | Site branding/settings |

## Pages

| Route | File | Description |
|-------|------|-------------|
| `/` | `index.astro` | Home — hero, categories, featured, states |
| `/directory` | `directory.astro` | Browse all with filters |
| `/map` | `map.astro` | Full Mapbox map |
| `/category/[slug]` | `category/[slug].astro` | Category listings |
| `/business/[slug]` | `business/[slug].astro` | Business detail |
| `/[state]` | `[state]/index.astro` | State listings |
| `/[state]/[city]` | `[state]/[city].astro` | City listings (SEO) |
| `/about` | `about.astro` | About page (static) |
| `/privacy` | `privacy.astro` | Privacy policy (static) |
| `/terms` | `terms.astro` | Terms of service (static) |

---

## Session History

<!-- Add session entries below this line -->
