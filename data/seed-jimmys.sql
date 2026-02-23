-- ============================================
-- SEED: Jimmy's Famous Seafood
-- The business that started the movement
-- ============================================

INSERT OR IGNORE INTO businesses (
  slug,
  name,
  category_id,
  city,
  state,
  street_address,
  postal_code,
  latitude,
  longitude,
  website,
  twitter_handle,
  phone,
  short_description,
  story,
  veteran_owned,
  woman_owned,
  family_owned,
  immigrant_owned,
  made_in_usa,
  ships_nationwide,
  brick_and_mortar,
  featured,
  verified,
  source,
  source_row_id
) VALUES (
  'jimmys-famous-seafood',
  'Jimmy''s Famous Seafood',
  (SELECT id FROM categories WHERE slug = 'restaurants-food'),
  'Baltimore',
  'MD',
  '6526 Holabird Ave',
  '21224',
  39.2847,
  -76.5497,
  'https://jimmysfamousseafood.com',
  'JimmysSeafood',
  '(410) 633-4040',
  'The Baltimore seafood institution that sparked a movement. Famous for their crab cakes — and for saying what millions of Americans were thinking.',
  'Jimmy''s Famous Seafood has been a Baltimore institution for decades, run by immigrant brothers Tony and John Minadakis. They built their reputation on the best crab cakes in Maryland — hand-picked, never frozen, made the way Baltimore intended.

On February 21, 2026, when a major media outlet suggested that American pride during the Winter Olympics was something to be embarrassed about, Jimmy''s replied with two words that went viral. Their post earned 200,000+ likes, 9 million+ views, and 255,000 new followers in a single day. Their website crashed from the surge of Americans ordering crab cakes in solidarity.

Tony and John didn''t set out to start a movement. They just said what they believed. That''s the American way — and that''s exactly why this directory exists.',
  0,
  0,
  1,
  1,
  0,
  1,
  1,
  1,
  1,
  'manual',
  'seed-jimmys'
);

-- Assign badges
INSERT OR IGNORE INTO business_badges (business_id, badge_id)
SELECT b.id, ba.id FROM businesses b, badges ba
WHERE b.slug = 'jimmys-famous-seafood'
  AND ba.slug = 'original-thread';

INSERT OR IGNORE INTO business_badges (business_id, badge_id)
SELECT b.id, ba.id FROM businesses b, badges ba
WHERE b.slug = 'jimmys-famous-seafood'
  AND ba.slug = 'went-viral';

INSERT OR IGNORE INTO business_badges (business_id, badge_id)
SELECT b.id, ba.id FROM businesses b, badges ba
WHERE b.slug = 'jimmys-famous-seafood'
  AND ba.slug = 'immigrant-founded';

INSERT OR IGNORE INTO business_badges (business_id, badge_id)
SELECT b.id, ba.id FROM businesses b, badges ba
WHERE b.slug = 'jimmys-famous-seafood'
  AND ba.slug = 'family-business';

INSERT OR IGNORE INTO business_badges (business_id, badge_id)
SELECT b.id, ba.id FROM businesses b, badges ba
WHERE b.slug = 'jimmys-famous-seafood'
  AND ba.slug = 'ships-nationwide';
