# Patriot Business Directory — Product Requirements Document

> **Status:** Ready to build
> **Author:** PRD Agent (compiled from research + architecture notes)
> **Date:** February 23, 2026
> **Stack:** Astro + Cloudflare D1 + Cloudflare Pages + Mapbox
> **Domain:** TBD

---

## Table of Contents

1. [Overview](#1-overview)
2. [Target Audience](#2-target-audience)
3. [Goals & Non-Goals](#3-goals--non-goals)
4. [User Stories](#4-user-stories)
5. [Feature List](#5-feature-list)
6. [Data Model](#6-data-model)
7. [Page Structure](#7-page-structure)
8. [Business Categories](#8-business-categories)
9. [Badge System](#9-badge-system)
10. [Data Ingestion Flow](#10-data-ingestion-flow)
11. [Mapbox Integration](#11-mapbox-integration)
12. [SEO Strategy](#12-seo-strategy)
13. [Monetization](#13-monetization)
14. [Tech Stack](#14-tech-stack)
15. [Out of Scope (v1)](#15-out-of-scope-v1)
16. [Launch Checklist](#16-launch-checklist)

---

## 1. Overview

### What Is This

A free, fast, map-first directory of patriot-owned and pro-American small businesses. Users browse by category, location, or interactive map to discover businesses worth supporting. Each listing has a story — who the owners are, why they started, and what makes them proudly American.

### Why It Exists

On February 21, 2026, HuffPost published an article framing patriotic pride during the Winter Olympics as uncomfortable. Jimmy's Famous Seafood — a Baltimore restaurant run by immigrant brothers Tony and John Minadakis — replied on X with two words that went viral. The response earned 200K+ likes, 9M+ views, 255K+ new followers, and crashed their website from order volume.

The moment did not stop there. A crowdsourced X thread surfaced 129+ pro-American small businesses that people wanted to support. Consumers were ready to act, but had no organized way to find these businesses. That thread is the seed data for this directory.

### The Opportunity

> [!success] Three forces converging at once:
> 1. **Cultural moment** — Jimmy's/Olympics/HuffPost backlash created massive demand
> 2. **Consumer trend** — "Made in USA" searches have doubled since early 2025; Amazon searches for American-made products up 220% YoY
> 3. **Competitor gap** — 7 competitors analyzed. None are free, fast, map-first, AND born from this moment. Most are paywalled, politically narrow, poorly designed, or lack geographic discovery.

### Strategic Positioning

> **The only patriot business directory born from the viral Jimmy's Seafood moment — fast, free, map-first, and proudly American without being political.**

### Tone

> [!warning] The site should feel **celebratory, not angry**. Patriotic, not partisan.

- Lead with celebration of American entrepreneurship and pride
- Feature real stories — who are these people, why did they start their business
- Avoid culture-war framing (no "anti-woke" language, no boycott lists, no blacklists)
- Let the businesses speak for themselves
- Emphasize: "Support American businesses you can be proud of"

---

## 2. Target Audience

### Primary: The "Vote With Your Wallet" Consumer

- **Who:** Americans who actively choose businesses based on values alignment
- **Age:** 25-55, skewing slightly older
- **Behavior:** Saw the Jimmy's moment on X, shared the thread, ordered crab cakes. Wants to keep supporting businesses like this but has no organized way to find them.
- **Need:** "I want to find patriot businesses near me or that ship to me."
- **Geography hotspots:** Southern states, Mountain West, Midwest, and rural northern states (Wyoming, New Hampshire, Maine, Vermont) index highest for "Made in USA" searches

### Secondary: The Patriot Small Business Owner

- **Who:** Owners of small American businesses who want visibility
- **Need:** "I want my business listed so patriotic consumers can find me."
- **v1 behavior:** Brian adds them from the crowdsourced spreadsheet. Self-submission comes in v2.

### Tertiary: Organic Search Browsers

- **Who:** People searching "patriot businesses near me," "American-owned restaurants in Baltimore," or "pro-American businesses list"
- **Need:** A well-indexed, authoritative result that answers their query
- **Acquisition channel:** Google organic via programmatic city/category pages

---

## 3. Goals & Non-Goals

### Goals (v1)

| # | Goal | Success Metric |
|---|------|---------------|
| G1 | Launch with 129+ businesses from the viral thread | Seed data imported and live |
| G2 | Interactive map with category filtering and "find near me" | Mapbox map functional on `/map` |
| G3 | Individual business pages with rich stories | Every listing has a detail page at `/business/[slug]` |
| G4 | Programmatic SEO pages for city + state + category combos | 40-60 city pages, 12 category pages, 50 state pages indexed |
| G5 | Fast, clean, mobile-first experience | Lighthouse score 90+ on mobile |
| G6 | Ship within 48-72 hours of starting build | Moment is time-sensitive |
| G7 | AdSense-ready ad slots (code inserted once approved) | Slots built, commented out until live |

### Non-Goals (v1)

| # | Non-Goal | Why |
|---|----------|-----|
| NG1 | Self-submit form | Brian curates data from the spreadsheet. Self-submit adds moderation burden. v2. |
| NG2 | User accounts or login | No need for user-facing auth in a read-only directory. |
| NG3 | Premium/featured listings (paid) | Monetize with AdSense first. Paid listings come after traction. |
| NG4 | E-commerce or transactions | We are a discovery directory, not a marketplace. |
| NG5 | Email alerts or newsletters | Not needed for launch. v2/v3. |
| NG6 | Ratings or reviews | Adds moderation complexity. v2. |
| NG7 | Blog or content section | Ship the directory first. Blog content comes after launch. |
| NG8 | Mobile app | Web-first. Astro PWA considerations can come later. |

---

## 4. User Stories

### US-1: Browse the Directory

> As a patriotic consumer, I want to browse a directory of pro-American businesses so that I can discover businesses to support.

**Acceptance criteria:**
- User lands on home page and sees category grid + featured businesses
- User clicks "Browse Directory" and sees all businesses in a filterable grid
- User can filter by category and state
- Each business card shows: name, category, city/state, short description, badges

### US-2: Find Businesses Near Me

> As a user, I want to view businesses on a map and find ones near my location so I can support local patriot businesses.

**Acceptance criteria:**
- `/map` page shows all businesses as clustered markers on a Mapbox map
- User clicks "Find Near Me" button; map centers on their location via browser geolocation
- User can search by city name or zip code; map flies to that location
- Category dropdown filters both map markers and sidebar list simultaneously
- Clicking a marker shows a popup with business name, category, city, and "View Details" link

### US-3: Read a Business Story

> As a user, I want to read the story behind a business so I can feel a personal connection before visiting or ordering.

**Acceptance criteria:**
- `/business/[slug]` page shows: business name, category badge, city/state, photo (if available), full story, contact info, mini map with single pin
- "More [Category] Businesses" section at bottom links to related listings
- Page includes LocalBusiness schema.org structured data

### US-4: Browse by Location

> As a user, I want to browse businesses in my state or city so I can find ones nearby.

**Acceptance criteria:**
- `/[state]` page lists all businesses in that state with a map and business count
- `/[state]/[city]` page lists businesses in that city
- Home page has a "Browse by State" section with links to all states that have listings

### US-5: Discover via Search Engine

> As a Google user searching for "patriot businesses in Austin TX," I want to find a relevant, well-organized result.

**Acceptance criteria:**
- City pages have unique title tags: "Patriot Businesses in Austin, TX | [Site Name]"
- Category pages target: "American-Owned Restaurants | [Site Name]"
- Business detail pages have LocalBusiness structured data
- Sitemap includes all dynamic pages
- Pages load fast (Lighthouse 90+)

---

## 5. Feature List

### P0 — Must Have at Launch

| # | Feature | Description |
|---|---------|-------------|
| F1 | **Home page** | Hero, category grid, featured businesses, browse-by-state links, submission CTA |
| F2 | **Directory page** | All businesses in filterable card grid. Filter by category and state. |
| F3 | **Business detail page** | Full listing with story, contact info, badges, mini map, related businesses |
| F4 | **Category pages** | `/category/[slug]` — businesses filtered by category |
| F5 | **State pages** | `/[state]` — businesses in a state with map and count |
| F6 | **City pages** | `/[state]/[city]` — businesses in a city (programmatic SEO) |
| F7 | **Map page** | Full Mapbox map with clustered markers, category filter, sidebar list, "find near me" |
| F8 | **Badge system** | Visual badges on business cards (Veteran Owned, From the Original Thread, etc.) |
| F9 | **Responsive design** | Mobile-first, works on all screen sizes |
| F10 | **SEO infrastructure** | Unique meta tags per page, sitemap, robots.txt, LocalBusiness schema |
| F11 | **AdSense slots** | Ad containers built into layouts, commented out until approved |
| F12 | **Data import pipeline** | CSV export from Google Sheets, import script, geocoding script |

### P1 — Soon After Launch

| # | Feature | Description |
|---|---------|-------------|
| F13 | Self-submit form | Web3Forms-powered form for business owners to request listing |
| F14 | Blog / stories section | Content pieces: "The Jimmy's Seafood Story," listicles, trend articles |
| F15 | Search functionality | Full-text search across business names and descriptions |
| F16 | Admin approval queue | Simple admin page (behind Cloudflare Access) to approve/reject submissions |
| F17 | Social sharing | Open Graph images and share buttons on business detail pages |

### P2 — Future / If Traction

| # | Feature | Description |
|---|---------|-------------|
| F18 | Email alerts | "New businesses in your state" weekly digest |
| F19 | Premium/featured listings | Paid placement for business owners |
| F20 | Ratings and reviews | User-generated reviews with moderation |
| F21 | Automated Sheets sync | Worker cron that pulls from Google Sheets API on schedule |
| F22 | Mediavine migration | Upgrade from AdSense when traffic exceeds 50k sessions/month |
| F23 | "Suggest an Edit" | Let users flag incorrect info on listings |

---

## 6. Data Model

### Overview

Three tables in Cloudflare D1. The `businesses` table is the core entity. `categories` defines the 12 business types. `badges` tracks special designations assigned manually by Brian. A junction table `business_badges` supports many-to-many.

> [!info] Database name: `patriot_directory_db`
> D1 binding: `DB`
> Pattern follows `site-recordstore-directory` conventions.

### Full Schema (CREATE TABLE SQL)

```sql
-- ============================================
-- PATRIOT DIRECTORY — D1 SCHEMA
-- ============================================

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
  state TEXT NOT NULL,              -- 2-char abbreviation (e.g., "MD")
  street_address TEXT,
  postal_code TEXT,
  latitude REAL,
  longitude REAL,

  -- Contact & Social
  website TEXT,
  twitter_handle TEXT,             -- X/Twitter handle (without @)
  phone TEXT,
  email TEXT,                      -- Not displayed publicly

  -- Content
  short_description TEXT,          -- 1-2 sentence tagline for cards (500 char max)
  story TEXT,                      -- Longer origin story for detail page (2000 char max)

  -- Media
  photo_url TEXT,                  -- Primary photo
  logo_url TEXT,

  -- Ownership attributes
  veteran_owned INTEGER DEFAULT 0,
  woman_owned INTEGER DEFAULT 0,
  family_owned INTEGER DEFAULT 0,
  immigrant_owned INTEGER DEFAULT 0,
  made_in_usa INTEGER DEFAULT 0,
  ships_nationwide INTEGER DEFAULT 0,
  brick_and_mortar INTEGER DEFAULT 1,

  -- Business metadata
  founded_year INTEGER,
  employee_count TEXT,             -- "1-5", "6-25", "26-100", "100+"

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

-- ============================================
-- BADGES
-- ============================================
CREATE TABLE IF NOT EXISTS badges (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  slug TEXT UNIQUE NOT NULL,
  name TEXT NOT NULL,
  description TEXT,
  icon TEXT,                        -- emoji for display
  color TEXT,                       -- Tailwind color class (e.g., "blue", "red", "amber")
  sort_order INTEGER DEFAULT 0
);

-- ============================================
-- BUSINESS_BADGES (junction table)
-- ============================================
CREATE TABLE IF NOT EXISTS business_badges (
  business_id INTEGER NOT NULL,
  badge_id INTEGER NOT NULL,
  assigned_at TEXT DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (business_id, badge_id),
  FOREIGN KEY (business_id) REFERENCES businesses(id),
  FOREIGN KEY (badge_id) REFERENCES badges(id)
);

CREATE INDEX IF NOT EXISTS idx_business_badges_business ON business_badges(business_id);
CREATE INDEX IF NOT EXISTS idx_business_badges_badge ON business_badges(badge_id);

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

### Seed Data: Categories

```sql
INSERT OR IGNORE INTO categories (slug, name, description, icon, sort_order) VALUES
  ('restaurants-food', 'Restaurants & Food', 'American-owned restaurants, diners, BBQ, seafood, and food trucks', 'utensils', 1),
  ('farms-agriculture', 'Farms & Agriculture', 'Farms, ranches, feed stores, and agricultural services', 'tractor', 2),
  ('brewing-spirits', 'Brewing & Spirits', 'Craft breweries, distilleries, wineries, and taprooms', 'beer-mug', 3),
  ('handmade-artisan', 'Handmade & Artisan', 'Woodworkers, leather crafters, jewelers, and artisan makers', 'hammer', 4),
  ('apparel-accessories', 'Apparel & Accessories', 'American-made clothing, accessories, and footwear', 'shirt', 5),
  ('firearms-outdoors', 'Firearms & Outdoors', 'Gun shops, ranges, outfitters, hunting, and outdoor gear', 'target', 6),
  ('home-building', 'Home & Building', 'Contractors, builders, home goods, and home improvement', 'house', 7),
  ('faith-family', 'Faith & Family', 'Faith-based businesses, family services, and community organizations', 'heart', 8),
  ('health-wellness', 'Health & Wellness', 'Gyms, wellness services, supplements, and natural products', 'leaf', 9),
  ('services-trades', 'Services & Trades', 'Plumbers, electricians, mechanics, and skilled tradespeople', 'wrench', 10),
  ('books-media', 'Books & Media', 'Publishers, bookstores, podcasters, and content creators', 'book', 11),
  ('pets-animals', 'Pets & Animals', 'Pet food, supplies, grooming, and animal services', 'paw', 12);
```

### Seed Data: Badges

```sql
INSERT OR IGNORE INTO badges (slug, name, description, icon, color, sort_order) VALUES
  ('original-thread', 'From the Original Thread', 'Listed in the viral X thread of 129+ patriot businesses', 'fire', 'amber', 1),
  ('went-viral', 'Went Viral', 'Business had its own viral patriotic moment', 'rocket', 'red', 2),
  ('veteran-owned', 'Veteran Owned', 'Owned by a U.S. military veteran', 'shield', 'blue', 3),
  ('made-in-usa', 'Made in USA', 'Products manufactured in the United States', 'flag', 'red', 4),
  ('ships-nationwide', 'Ships Nationwide', 'Available for online ordering and shipping across the US', 'truck', 'green', 5),
  ('family-business', 'Family Business', 'Family-owned and operated', 'users', 'purple', 6),
  ('immigrant-founded', 'Immigrant Founded', 'Founded by immigrants living the American Dream', 'star', 'indigo', 7);
```

### Design Notes

- **INTEGER PRIMARY KEY AUTOINCREMENT** — D1/SQLite convention
- **TEXT for timestamps** — D1 `CURRENT_TIMESTAMP` returns ISO text strings
- **INTEGER for booleans** — SQLite convention (0/1)
- **FOREIGN KEY on category_id** — Enforces valid category references
- **source_row_id** — Deduplication key for Google Sheets imports; prevents re-importing the same row
- **business_badges junction table** — Allows a business to have multiple badges and a badge to apply to multiple businesses. Brian assigns badges manually.
- **Indexes cover all query patterns:** by slug (detail page), category (category page), state/city (location pages), featured (home page)

---

## 7. Page Structure

### All Pages

| Page | URL Pattern | Purpose | Render | SEO Title Pattern |
|------|-------------|---------|--------|-------------------|
| **Home** | `/` | Hero, category grid, featured businesses, state browse, CTA | SSR | `[Site Name] — Support American Businesses` |
| **Directory** | `/directory` | All businesses, search/filter, grid view | SSR | `Browse All Patriot Businesses | [Site Name]` |
| **Category** | `/category/[slug]` | Businesses in one category | SSR | `American-Owned [Category] | [Site Name]` |
| **State** | `/[state]` | Businesses in one state with map | SSR | `Patriot Businesses in [State] | [Site Name]` |
| **City** | `/[state]/[city]` | Businesses in one city (programmatic SEO) | SSR | `Patriot Businesses in [City], [State] | [Site Name]` |
| **Business Detail** | `/business/[slug]` | Full listing: story, contact, mini map, related | SSR | `[Business Name] — [City], [State] | [Site Name]` |
| **Map** | `/map` | Full interactive map with sidebar and filters | SSR | `Find Patriot Businesses Near You | [Site Name]` |
| **About** | `/about` | Mission, story, origin of the directory | SSG | `About | [Site Name]` |
| **Privacy** | `/privacy` | Privacy policy | SSG | `Privacy Policy | [Site Name]` |
| **Terms** | `/terms` | Terms of service | SSG | `Terms of Service | [Site Name]` |

### URL Conventions

- **State slugs:** Full lowercase name, hyphenated: `/north-carolina`, `/new-york`, `/texas`
- **City slugs:** Lowercase, hyphenated: `/texas/san-antonio`, `/maryland/baltimore`
- **Category slugs:** Match `categories.slug` column: `/category/restaurants-food`
- **Business slugs:** Auto-generated from business name: `/business/jimmys-famous-seafood`

### Page Layouts

#### Home (`/`)

```
Hero Section
  - Headline: "Support American Businesses"
  - Subtitle: "Discover 129+ proudly American businesses born from the movement"
  - CTA buttons: [Browse Directory] [View Map]

Category Grid (3x4 on desktop, 2x6 on mobile)
  - 12 category cards with icon, name, business count

Featured Businesses (horizontal scroll or 4-col grid)
  - 4-6 editorially featured business cards

[AdSense: in-content slot]

Browse by State
  - Grid of state name links with business counts
  - Only shows states that have listings

"Know a Patriot Business?" CTA
  - Contact link (v1) or submission form link (v2)

Footer
```

#### Business Detail (`/business/[slug]`)

```
Breadcrumb: Home > [Category] > [Business Name]

Business Header
  - Name, category badge, city/state
  - Badges row (Veteran Owned, From the Original Thread, etc.)

Photo (if available)

Story Section
  - Full origin narrative / "why patriot" story

Contact Info
  - Website link, Twitter/X link, phone (if provided)

[AdSense: in-article slot]

Mini Map (single pin, non-interactive or simple)

More [Category] Businesses (3-4 related cards)

[AdSense: end-of-page slot]

Footer
```

#### Map (`/map`)

```
Desktop (lg+):
  Filter Bar: [Category dropdown] [State dropdown] [City/Zip search]

  Split Layout:
    Left (30%): Scrollable sidebar list of matching businesses
    Right (70%): Mapbox map with clustered markers

  Sidebar item interaction:
    - Hover highlights marker
    - Click flies map to marker and opens popup

Mobile:
  Collapsed filter bar (tap to expand)
  Map (50vh height, full width)
  List below map (scrollable)
```

### Schema.org Structured Data

Every business detail page includes `LocalBusiness` JSON-LD:

```json
{
  "@context": "https://schema.org",
  "@type": "LocalBusiness",
  "name": "Jimmy's Famous Seafood",
  "description": "Immigrant-owned Baltimore seafood institution...",
  "address": {
    "@type": "PostalAddress",
    "streetAddress": "6526 Holabird Ave",
    "addressLocality": "Baltimore",
    "addressRegion": "MD",
    "postalCode": "21224"
  },
  "url": "https://jimmysfamousseafood.com",
  "geo": {
    "@type": "GeoCoordinates",
    "latitude": 39.2847,
    "longitude": -76.5497
  },
  "telephone": "+1-410-633-4040"
}
```

---

## 8. Business Categories

> [!info] 12 categories selected based on the viral thread composition, competitor analysis, and local search opportunity.

| # | Emoji | Category Name | Slug | Description | Thread Examples |
|---|-------|--------------|------|-------------|-----------------|
| 1 | :fork_and_knife: | Restaurants & Food | `restaurants-food` | Restaurants, diners, BBQ, seafood, food trucks | Jimmy's Famous Seafood, Louisiana Crawfish Co. |
| 2 | :ear_of_corn: | Farms & Agriculture | `farms-agriculture` | Farms, ranches, feed stores, ag services | Taylor Shellfish Farms, Appalachian Wood Homestead |
| 3 | :beer: | Brewing & Spirits | `brewing-spirits` | Breweries, distilleries, wineries, taprooms | Benford Brewing |
| 4 | :hammer: | Handmade & Artisan | `handmade-artisan` | Woodworkers, leather crafters, jewelers, makers | BowTied Woodwork, Chooch Skookum, Flying Monk Leather |
| 5 | :shirt: | Apparel & Accessories | `apparel-accessories` | American-made clothing, accessories, footwear | American Lictor, Vintage Mama's Cottage |
| 6 | :dart: | Firearms & Outdoors | `firearms-outdoors` | Gun shops, ranges, outfitters, outdoor gear | Parro's Gun Shop & Indoor Range |
| 7 | :house: | Home & Building | `home-building` | Contractors, builders, home goods | Puresteel Co. |
| 8 | :pray: | Faith & Family | `faith-family` | Faith-based businesses, family services, community orgs | She Must Be Loved, Ave Maria Every Day |
| 9 | :herb: | Health & Wellness | `health-wellness` | Gyms, wellness, supplements, natural products | — |
| 10 | :wrench: | Services & Trades | `services-trades` | Plumbers, electricians, mechanics, tradespeople | — |
| 11 | :books: | Books & Media | `books-media` | Publishers, bookstores, podcasters, creators | — |
| 12 | :dog: | Pets & Animals | `pets-animals` | Pet food, supplies, grooming, animal services | — |

### Category Notes

- **Multi-category support:** A business has one `category_id` (primary). Multi-tagging is a v2 enhancement if needed. The primary category determines the URL path.
- **"Services & Trades" is the sleeper hit.** Local search intent ("patriot plumber near me") is strong here. No competitor serves this.
- **"Faith & Family" inclusion:** Authentic to the movement (many thread businesses are faith-based). Kept broad enough ("family services, community orgs") to avoid exclusionary framing.
- **Categories can be added later.** The schema supports adding new categories at any time via INSERT.

---

## 9. Badge System

### What Badges Are

Badges are visual labels displayed on business cards and detail pages. They convey special attributes at a glance. Brian assigns them manually — there is no automated badge logic in v1.

### Badge Definitions

| Badge | Slug | Icon | Color | Criteria | Assigned By |
|-------|------|------|-------|----------|-------------|
| **From the Original Thread** | `original-thread` | :fire: | Amber | Business was listed in the viral X thread of 129+ patriot businesses | Brian (on import) |
| **Went Viral** | `went-viral` | :rocket: | Red | Business had its own viral patriotic moment (Jimmy's, etc.) | Brian (manual) |
| **Veteran Owned** | `veteran-owned` | :shield: | Blue | Owned by a U.S. military veteran | Brian (from spreadsheet data) |
| **Made in USA** | `made-in-usa` | :us: | Red | Products manufactured in the United States | Brian (from spreadsheet data) |
| **Ships Nationwide** | `ships-nationwide` | :truck: | Green | Available for online ordering and nationwide shipping | Brian (from spreadsheet data) |
| **Family Business** | `family-business` | :family: | Purple | Family-owned and operated | Brian (from spreadsheet data) |
| **Immigrant Founded** | `immigrant-founded` | :star: | Indigo | Founded by immigrants living the American Dream | Brian (from spreadsheet data) |

### Badge Display

- **Business card (grid view):** Show up to 3 badges as small pills below the business name. If more than 3, show first 3 + "+N more."
- **Business detail page:** Show all badges in a horizontal row below the business header. Each badge shows icon + name.
- **Badge rendering:** Tailwind-styled pill components. Each badge has a `color` field that maps to a Tailwind color class for background tint.

### Data Model

Badges use a many-to-many junction table (`business_badges`). See the [Data Model](#6-data-model) section for the full schema. This allows:
- A business to have multiple badges (e.g., "Veteran Owned" + "Made in USA" + "From the Original Thread")
- A badge to apply to many businesses (e.g., all 129 thread businesses get "From the Original Thread")

### Assignment Workflow

1. During initial import: the import script tags all spreadsheet businesses with the `original-thread` badge
2. Brian manually assigns other badges via D1 SQL or a future admin UI
3. No automated badge detection in v1

---

## 10. Data Ingestion Flow

### Overview

Data flows from a Google Spreadsheet (crowdsourced by Brian) through a CSV export and import script into Cloudflare D1. This is a manual process for v1 — the spreadsheet has ~129 rows and updates infrequently.

### Step-by-Step Pipeline

```
Step 1: Brian maintains Google Spreadsheet
         ↓
Step 2: File → Download as CSV → save to data/businesses.csv
         ↓
Step 3: Run import script
         node scripts/import-csv.js data/businesses.csv
         → outputs data/import.sql
         ↓
Step 4: Execute SQL against D1
         npx wrangler d1 execute patriot_directory_db --file=data/import.sql
         ↓
Step 5: Run geocoding script (fills in lat/lng for businesses missing coordinates)
         node scripts/geocode.js
         → outputs data/geocode-update.sql
         ↓
Step 6: Execute geocoding updates
         npx wrangler d1 execute patriot_directory_db --file=data/geocode-update.sql
         ↓
Step 7: Assign badges
         npx wrangler d1 execute patriot_directory_db --file=data/assign-badges.sql
```

### Expected Spreadsheet Columns

| Column | Required | Maps To |
|--------|----------|---------|
| Name | Yes | `businesses.name` |
| Category | Yes | Mapped to `businesses.category_id` via lookup |
| City | Yes | `businesses.city` |
| State | Yes | `businesses.state` |
| Website | No | `businesses.website` |
| Twitter | No | `businesses.twitter_handle` |
| Short Description | No | `businesses.short_description` |
| Story | No | `businesses.story` |
| Street Address | No | `businesses.street_address` |
| Zip | No | `businesses.postal_code` |
| Veteran Owned | No | `businesses.veteran_owned` (0/1) |
| Family Owned | No | `businesses.family_owned` (0/1) |
| Ships Nationwide | No | `businesses.ships_nationwide` (0/1) |
| Made in USA | No | `businesses.made_in_usa` (0/1) |

### Import Script Responsibilities

The `scripts/import-csv.js` script:

1. Reads the CSV file
2. Validates required fields (name, city, state, category) — skips invalid rows with a warning
3. Generates URL-safe slugs from business names
4. Maps spreadsheet category names to `category_id` integers
5. Uses `source_row_id` for deduplication (INSERT OR IGNORE prevents duplicates on re-import)
6. Escapes single quotes in text fields for SQL safety
7. Outputs a `.sql` file of INSERT statements

### Geocoding Script Responsibilities

The `scripts/geocode.js` script:

1. Queries D1 for businesses where `latitude IS NULL`
2. For each, calls the Mapbox Geocoding API with `"{city}, {state}"` (or full street address if available)
3. Outputs UPDATE SQL statements with lat/lng values
4. Respects Mapbox rate limits (10 requests/second on free tier; 100k/month)
5. Logs any businesses that could not be geocoded for manual review

### When to Re-Run

- **Adding new businesses:** Export updated CSV, re-run import script (INSERT OR IGNORE handles dedup), re-run geocoding for new entries
- **Updating existing businesses:** For now, manual SQL updates via `wrangler d1 execute`. A future admin UI would replace this.

---

## 11. Mapbox Integration

### Map Page UX (`/map`)

> [!tip] The map is the core differentiator. No competitor does map-based discovery well.

#### Desktop Layout (lg+)

```
┌──────────────────────────────────────────────────────┐
│  Filters: [Category ▾]  [State ▾]  [Search city/zip] │
├────────────────────┬─────────────────────────────────┤
│                    │                                 │
│   Sidebar List     │        Mapbox Map               │
│   (scrollable)     │        (clustered markers)      │
│                    │                                 │
│   Business 1  ▸    │        [cluster: 12]            │
│   Business 2  ▸    │                     ●           │
│   Business 3  ▸    │           ●                     │
│   Business 4  ▸    │      [cluster: 5]    ●          │
│   ...              │                                 │
│                    │                                 │
│  Showing 42 of 129 │                                 │
├────────────────────┴─────────────────────────────────┤
│  Footer                                              │
└──────────────────────────────────────────────────────┘
```

#### Mobile Layout

```
┌────────────────────┐
│ Filters (collapsed) │
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

### Feature Breakdown

#### 1. Marker Clustering

Clustered markers prevent visual clutter at low zoom levels. Mapbox's built-in GeoJSON clustering renders on GPU for smooth performance.

- **Cluster circles:** Navy blue (`#1e40af`), sized by count (20px at 1-9, 30px at 10-49, 40px at 50+)
- **Count labels:** White text centered in cluster circles
- **Click-to-zoom:** Clicking a cluster zooms in to expand it
- **Individual markers:** Red pins (`#dc2626`) or custom flag-themed markers

#### 2. Category Filtering

Selecting a category from the dropdown filters both the map markers and the sidebar list simultaneously. Implemented by updating the GeoJSON source data on the map.

#### 3. Marker Popup

Clicking an individual marker shows a popup containing:
- Business name (bold)
- Category badge (small pill)
- City, State
- Short description (truncated to 80 chars)
- "View Details →" link to `/business/[slug]`

#### 4. Sidebar List Interaction

- **Hover** a sidebar item: corresponding marker highlights on the map
- **Click** a sidebar item: map flies to that marker and opens its popup
- Sidebar shows: business name, category, city, first badge (if any)
- Count displayed at bottom: "Showing X of Y businesses"

#### 5. "Find Near Me" (Geolocation)

Uses Mapbox's built-in `GeolocateControl`:
- Blue "locate me" button in the top-right corner of the map
- Requests browser geolocation permission
- Centers and zooms map to user's location
- User immediately sees nearby business markers/clusters

#### 6. City/Zip Search

Uses Mapbox Geocoder control:
- Search input in the top-left of the map (or in the filter bar)
- Placeholder: "Search city or zip..."
- Restricted to US results (`countries: 'us'`, `types: 'place,postcode'`)
- Selecting a result flies the map to that location

### Color Scheme

| Element | Color | Hex |
|---------|-------|-----|
| Cluster circles | Navy blue | `#1e40af` |
| Individual markers | Red | `#dc2626` |
| Popup header | Navy blue | `#1e40af` |
| Popup CTA | Red | `#dc2626` |
| Map base style | Light | `mapbox://styles/mapbox/light-v11` |

### Technical Notes

- **Mapbox token:** Stored as `PUBLIC_MAPBOX_TOKEN` environment variable, injected via `<meta>` tag in BaseLayout (same pattern as recordstops.com)
- **Mapbox GL JS version:** v3.3 (already licensed in Brian's account)
- **Free tier:** 50k map loads/month — sufficient for launch
- **GeoJSON data:** Served as an SSR API endpoint (`/api/businesses.json`) or inlined in the map page response
- **Geocoder plugin:** `@mapbox/mapbox-gl-geocoder` (separate npm package)

---

## 12. SEO Strategy

### Target Keyword Tiers

#### Tier 1: High-Intent Directory Keywords (Home + Directory pages)

| Keyword | Competition | Target Page |
|---------|-------------|-------------|
| patriot owned businesses | Medium | Home, Directory |
| buy american directory | Low-Medium | Home, Directory |
| pro american businesses | Low | Home, Directory |
| support american businesses | Low-Medium | Home |
| american owned businesses near me | Low | Map page |
| patriot business directory | Low | Home |
| made in america products | Medium-High | Directory |

#### Tier 2: Category + Location (Programmatic Pages)

| Pattern | Example | Target Page |
|---------|---------|-------------|
| `{category} in {city}` | "american restaurants in Baltimore" | City page |
| `american owned {category}` | "american owned breweries" | Category page |
| `{state} american businesses` | "Texas patriot businesses" | State page |
| `patriot businesses in {city} {state}` | "patriot businesses in Austin TX" | City page |

#### Tier 3: Trending Keywords (Time-Sensitive)

| Keyword | Target |
|---------|--------|
| jimmy's famous seafood | Blog content (v2) |
| huffpost patriotic businesses | Blog content (v2) |
| pro american businesses list | Directory page |
| patriotic businesses to order from | Directory page |

### Meta Tag Patterns

| Page Type | Title | Description |
|-----------|-------|-------------|
| Home | `[Site Name] — Support American Businesses` | `Discover 129+ proudly American businesses. Browse by category, find near you on the map, and support businesses that make America great.` |
| Category | `American-Owned [Category] — [Site Name]` | `Browse [count] American-owned [category] businesses. Find patriot [category] near you.` |
| State | `Patriot Businesses in [State] — [Site Name]` | `Find [count] patriot-owned businesses in [State]. Restaurants, services, farms, and more.` |
| City | `Patriot Businesses in [City], [ST] — [Site Name]` | `Support [count] American businesses in [City], [State]. Browse local patriot-owned [top categories].` |
| Business | `[Business Name] — [City], [ST] — [Site Name]` | `[Short description]. [Category] in [City], [State]. Learn their story and show your support.` |
| Map | `Find Patriot Businesses Near You — [Site Name]` | `Interactive map of 129+ patriot businesses across America. Filter by category, search by city, or find businesses near you.` |

### Programmatic SEO Surface Area

With 129 businesses across an estimated 40-60 unique cities, 20-30 states, and 12 categories:

| Page Type | Est. Count | Keyword Target |
|-----------|-----------|----------------|
| City pages | 40-60 | "patriot businesses in [city], [state]" |
| State pages | 20-30 | "[state] patriot businesses" |
| Category pages | 12 | "american owned [category]" |
| Business detail pages | 129+ | "[business name] [city]" |
| **Total indexable pages** | **~200-230** | |

### Internal Linking Strategy

- **Business cards** always link to `/business/[slug]`
- **Category badges** on cards and detail pages link to `/category/[slug]`
- **City/State text** on cards and detail pages link to `/[state]/[city]`
- **Breadcrumbs** on every page: Home > Category > Business (or Home > State > City)
- **"More in [Category]"** section on business detail pages links to sibling listings
- **"Browse by State"** section on home page links to all state pages

### Technical SEO

- **Sitemap:** Auto-generated via `@astrojs/sitemap` integration. Includes all dynamic SSR pages.
- **robots.txt:** Allow all. No pages need blocking.
- **Canonical URLs:** Set on every page to prevent duplicate content.
- **Open Graph tags:** Title, description, and image for social sharing on every page.

---

## 13. Monetization

### Phase 1: AdSense (at launch)

> [!info] AdSense ad code slots are built into page templates but **commented out** until the AdSense application is approved. Google typically requires 20-30 pages of quality content before approving.

#### Ad Placements by Page Type

**Home Page:**

| Position | Ad Format | Notes |
|----------|-----------|-------|
| Below category grid | In-feed / responsive display | Natural section break |
| Above footer | Responsive display (728x90) | Low-impact, high viewability |

**Directory / Category / State / City Pages:**

| Position | Ad Format | Notes |
|----------|-----------|-------|
| After every 8 business cards | In-feed | Blends with card grid |
| Sidebar (desktop only) | Display (300x250) | Only if layout supports sidebar |

**Business Detail Page:**

| Position | Ad Format | Notes |
|----------|-----------|-------|
| Below story section | In-article | After main content, before contact info |
| After "More Businesses" section | Responsive display | End of page, before footer |

**Map Page:**

| Position | Ad Format | Notes |
|----------|-----------|-------|
| Below map (mobile only) | Responsive display | Map is the feature — do not obstruct |

#### Ad Rules

- Maximum 3 ad units per page
- No ads above the fold on mobile (Google penalizes this)
- No ads in: hero section, filter bars, map overlay, contact info sections
- All ad code lives in a reusable `AdSlot.astro` component

#### AdSense Application Timing

Apply for AdSense when:
- Site has 50+ pages indexed in Google Search Console
- Site has been live for at least 2 weeks
- All pages have real content (no thin/placeholder pages)

### Phase 2: Mediavine (at 50k+ sessions/month)

Upgrade from AdSense to Mediavine for significantly higher RPMs once traffic qualifies.

### Phase 3: Premium Listings (if traction)

- Featured placement for business owners ($X/month)
- "Verified" badge for claimed listings
- Sponsored category pages

---

## 14. Tech Stack

| Layer | Technology | Version / Notes |
|-------|-----------|-----------------|
| **Framework** | Astro | Latest stable. Static-first with island architecture. |
| **Styling** | Tailwind CSS | v3.x. Utility-first, consistent with all Brian's sites. |
| **Database** | Cloudflare D1 | SQLite-based. DB name: `patriot_directory_db`. Binding: `DB`. |
| **Hosting** | Cloudflare Pages | Unlimited bandwidth, global CDN, auto-SSL. |
| **Server Runtime** | Cloudflare Workers | Via `@astrojs/cloudflare` adapter. SSR pages run on Workers. |
| **Maps** | Mapbox GL JS | v3.3. Already licensed. 50k free loads/month. |
| **Map Geocoder** | `@mapbox/mapbox-gl-geocoder` | City/zip search on map page. |
| **Ads** | Google AdSense | Commented out until approved. Upgrade to Mediavine at 50k sessions. |
| **Analytics** | Plausible or Umami | Privacy-friendly, lightweight. |
| **Sitemap** | `@astrojs/sitemap` | Auto-generated from all routes. |
| **Forms (v2)** | Web3Forms | 250 submissions/month free. Not needed for v1. |

### Rendering Strategy

- **Default:** `output: 'server'` — all pages are SSR by default (can query D1)
- **Static pages:** `/about`, `/privacy`, `/terms` marked with `export const prerender = true`
- **Rationale:** D1 is only accessible at runtime on Cloudflare Pages. You cannot query D1 during `astro build`. This is the same hybrid pattern used by recordstops.com.

### Environment Variables

| Variable | Purpose |
|----------|---------|
| `PUBLIC_MAPBOX_TOKEN` | Mapbox GL JS access token (public, client-side) |
| `PUBLIC_SITE_URL` | Canonical site URL |

> [!warning] The D1 binding (`DB`) is configured in `wrangler.toml`, not as an environment variable. It is accessed via `Astro.locals.runtime.env.DB` in SSR pages.

### Project File Structure

```
site-patriot-directory/
├── src/
│   ├── components/
│   │   ├── Header.astro
│   │   ├── Footer.astro
│   │   ├── BusinessCard.astro
│   │   ├── BusinessGrid.astro
│   │   ├── BusinessMap.astro       # Mapbox component
│   │   ├── CategoryCard.astro
│   │   ├── FilterBar.astro
│   │   ├── BadgePill.astro         # Reusable badge display
│   │   ├── AdSlot.astro
│   │   └── SEOHead.astro
│   ├── layouts/
│   │   └── BaseLayout.astro
│   ├── pages/
│   │   ├── index.astro             # Home
│   │   ├── directory.astro         # Browse all
│   │   ├── map.astro               # Full map view
│   │   ├── about.astro
│   │   ├── privacy.astro
│   │   ├── terms.astro
│   │   ├── category/
│   │   │   └── [slug].astro        # Category pages
│   │   ├── business/
│   │   │   └── [slug].astro        # Business detail
│   │   └── [state]/
│   │       ├── index.astro         # State page
│   │       └── [city].astro        # City page (SEO)
│   ├── lib/
│   │   ├── db.ts                   # D1 query helpers
│   │   └── utils.ts                # Slug helpers, formatters
│   ├── data/
│   │   ├── categories.json         # Category definitions (for static reference)
│   │   └── site-config.json        # Site branding/settings
│   └── styles/
│       └── global.css
├── scripts/
│   ├── import-csv.js               # Google Sheets CSV → D1 SQL
│   └── geocode.js                  # Batch geocoding for lat/lng
├── data/
│   ├── businesses.csv              # Exported from Google Sheets
│   └── import.sql                  # Generated by import script
├── db/
│   └── schema.sql                  # Full D1 schema
├── public/
│   ├── favicon.ico
│   ├── og-image.png
│   └── robots.txt
├── astro.config.mjs
├── tailwind.config.mjs
├── wrangler.toml
├── package.json
├── .env.example
├── CLAUDE.md
├── PRD.md                          # This file
└── progress.txt
```

---

## 15. Out of Scope (v1)

> [!warning] These features are explicitly NOT being built for the initial launch. This keeps the build focused and shippable within 48-72 hours.

| Feature | Why Not v1 | When |
|---------|-----------|------|
| **Self-submit form** | Adds moderation burden. Brian curates from spreadsheet. | P1 (soon after launch) |
| **User accounts / login** | No user-facing auth needed for a read-only directory. | P2 (if ever) |
| **Premium / featured listings (paid)** | Monetize with AdSense first. Need traction before charging businesses. | P2 |
| **E-commerce / transactions** | We are a discovery directory, not a marketplace. | Never (this is not our model) |
| **Email alerts / newsletters** | Nice-to-have, not launch critical. | P2 |
| **Ratings or reviews** | Moderation complexity. One-way content only for now. | P2 |
| **Blog / content section** | Ship the directory first. Blog can be added to an existing Astro site trivially. | P1 |
| **Mobile app** | Web-first. Astro renders fast on mobile. No app needed. | P2 (if ever) |
| **Automated Google Sheets sync** | Manual CSV import is fine for 129 rows. Automate when data grows. | P1 |
| **Multi-category tagging** | Each business gets one primary category. Multi-tag is a data model extension. | P1 |
| **Admin panel** | Brian uses `wrangler d1 execute` and direct SQL for v1. Admin UI later. | P1 |
| **Social media integrations** | No auto-posting, no embedded feeds. Simple links to profiles only. | P2 |
| **Upvoting / community features** | Adds anonymous interaction complexity. Not needed for discovery. | P2 |
| **Internationalization** | English only. US businesses only. | Never (for this site) |

---

## 16. Launch Checklist

> [!tip] Ordered by dependency. Complete top-to-bottom.

### Infrastructure Setup

- [ ] Create Cloudflare Pages project
- [ ] Create D1 database: `npx wrangler d1 create patriot_directory_db`
- [ ] Run schema SQL against D1: `npx wrangler d1 execute patriot_directory_db --file=db/schema.sql`
- [ ] Configure `wrangler.toml` with D1 database ID
- [ ] Set `PUBLIC_MAPBOX_TOKEN` in Cloudflare Pages environment variables
- [ ] Set `PUBLIC_SITE_URL` in Cloudflare Pages environment variables

### Data Pipeline

- [ ] Brian creates and populates the Google Spreadsheet with 129+ businesses
- [ ] Export spreadsheet as CSV to `data/businesses.csv`
- [ ] Run import script: `node scripts/import-csv.js data/businesses.csv`
- [ ] Execute import SQL: `npx wrangler d1 execute patriot_directory_db --file=data/import.sql`
- [ ] Run geocoding script: `node scripts/geocode.js`
- [ ] Execute geocoding SQL: `npx wrangler d1 execute patriot_directory_db --file=data/geocode-update.sql`
- [ ] Assign badges (especially "From the Original Thread" for all seed businesses)
- [ ] Verify data in D1: spot-check 10 random listings

### Build & Pages

- [ ] Scaffold Astro project with Cloudflare adapter
- [ ] Build BaseLayout with Header, Footer, SEOHead
- [ ] Build Home page (`/`)
- [ ] Build Directory page (`/directory`) with filter controls
- [ ] Build Category pages (`/category/[slug]`)
- [ ] Build State pages (`/[state]`)
- [ ] Build City pages (`/[state]/[city]`)
- [ ] Build Business Detail pages (`/business/[slug]`) with LocalBusiness schema
- [ ] Build Map page (`/map`) with Mapbox, clustering, sidebar, filters, geolocation, geocoder
- [ ] Build About page (`/about`)
- [ ] Build Privacy page (`/privacy`)
- [ ] Build Terms page (`/terms`)

### Components

- [ ] BusinessCard component (name, category, city, badges, link)
- [ ] BusinessGrid component (responsive card grid)
- [ ] BusinessMap component (Mapbox with clustering, popups)
- [ ] CategoryCard component (icon, name, count)
- [ ] FilterBar component (category + state dropdowns)
- [ ] BadgePill component (icon + name, colored background)
- [ ] AdSlot component (commented out, ready for AdSense)

### SEO & Analytics

- [ ] Unique `<title>` and `<meta name="description">` on every page (per patterns in Section 12)
- [ ] LocalBusiness JSON-LD on every business detail page
- [ ] Open Graph meta tags on every page
- [ ] `robots.txt` in `/public/`
- [ ] Sitemap via `@astrojs/sitemap`
- [ ] Set up Plausible or Umami analytics
- [ ] Submit sitemap to Google Search Console

### Quality

- [ ] Lighthouse audit: target 90+ on mobile for Performance, Accessibility, Best Practices, SEO
- [ ] Test on mobile (iOS Safari, Chrome)
- [ ] Test on desktop (Chrome, Firefox)
- [ ] Verify all Mapbox features work: clustering, popups, geolocation, geocoder search, category filter
- [ ] Verify all page types render correctly with real data
- [ ] Check that no page returns a 404 or 500

### Domain & Launch

- [ ] Purchase and configure domain (TBD)
- [ ] Point domain to Cloudflare Pages
- [ ] SSL auto-configured by Cloudflare
- [ ] Final deploy to production
- [ ] Smoke test all pages on production domain
- [ ] Share link

---

> [!success] **This PRD covers everything needed to build v1.** The research notes and architecture notes in this directory provide additional context and rationale for the decisions documented here. Reference them as needed during the build.

**Key files in this directory:**
- [[site-patriot-directory/PRD.md|PRD]] (this file)
- [[site-patriot-directory/research-notes.md|Research Notes]]
- [[site-patriot-directory/architecture-notes.md|Architecture Notes]]
