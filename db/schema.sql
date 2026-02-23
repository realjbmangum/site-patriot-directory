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
  icon TEXT,
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
  state TEXT NOT NULL,
  street_address TEXT,
  postal_code TEXT,
  latitude REAL,
  longitude REAL,

  -- Contact & Social
  website TEXT,
  twitter_handle TEXT,
  phone TEXT,
  email TEXT,

  -- Content
  short_description TEXT,
  story TEXT,

  -- Media
  photo_url TEXT,
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
  employee_count TEXT,

  -- Status & Curation
  verified INTEGER DEFAULT 0,
  featured INTEGER DEFAULT 0,

  -- Source tracking
  source TEXT DEFAULT 'spreadsheet',
  source_row_id TEXT,

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
  icon TEXT,
  color TEXT,
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
  status TEXT DEFAULT 'pending',
  notes TEXT,

  -- Metadata
  created_at TEXT DEFAULT CURRENT_TIMESTAMP,
  reviewed_at TEXT
);

CREATE INDEX IF NOT EXISTS idx_submissions_status ON submissions(status);

-- ============================================
-- SEED DATA: CATEGORIES
-- ============================================
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

-- ============================================
-- SEED DATA: BADGES
-- ============================================
INSERT OR IGNORE INTO badges (slug, name, description, icon, color, sort_order) VALUES
  ('original-thread', 'From the Original Thread', 'Listed in the viral X thread of 129+ patriot businesses', 'fire', 'amber', 1),
  ('went-viral', 'Went Viral', 'Business had its own viral patriotic moment', 'rocket', 'red', 2),
  ('veteran-owned', 'Veteran Owned', 'Owned by a U.S. military veteran', 'shield', 'blue', 3),
  ('made-in-usa', 'Made in USA', 'Products manufactured in the United States', 'flag', 'red', 4),
  ('ships-nationwide', 'Ships Nationwide', 'Available for online ordering and shipping across the US', 'truck', 'green', 5),
  ('family-business', 'Family Business', 'Family-owned and operated', 'users', 'purple', 6),
  ('immigrant-founded', 'Immigrant Founded', 'Founded by immigrants living the American Dream', 'star', 'indigo', 7);
