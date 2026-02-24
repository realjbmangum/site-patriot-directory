-- ============================================
-- SEED: Original Thread Businesses
-- 12 businesses from the Feb 21, 2026 viral X thread
-- ============================================

-- ============================================
-- 1. Ex Umbris Designs
-- ============================================
INSERT OR IGNORE INTO businesses (
  slug, name, category_id, city, state, street_address, postal_code,
  latitude, longitude, website, twitter_handle, phone,
  short_description,
  veteran_owned, woman_owned, family_owned, immigrant_owned,
  made_in_usa, ships_nationwide, brick_and_mortar, featured, verified, source, source_row_id
) VALUES (
  'ex-umbris-designs', 'Ex Umbris Designs',
  (SELECT id FROM categories WHERE slug = 'firearms-outdoors'),
  'Ellensburg', 'WA', '430 Cricklewood Ln', '98926',
  46.9970635, -120.5451220,
  'https://exumbrisdesigns.com', 'ExUmbrisDesigns', '(682) 226-2982',
  'Veteran-owned manufacturer of tactical gun belts, medical kits, and modular softgoods founded by a former Green Beret.',
  1, 0, 0, 0, 1, 1, 0, 0, 1, 'manual', 'seed-thread-1'
);

-- ============================================
-- 2. Toor Knives
-- ============================================
INSERT OR IGNORE INTO businesses (
  slug, name, category_id, city, state, street_address, postal_code,
  latitude, longitude, website, twitter_handle, phone,
  short_description,
  veteran_owned, woman_owned, family_owned, immigrant_owned,
  made_in_usa, ships_nationwide, brick_and_mortar, featured, verified, source, source_row_id
) VALUES (
  'toor-knives', 'Toor Knives',
  (SELECT id FROM categories WHERE slug = 'firearms-outdoors'),
  'El Cajon', 'CA', '1488 Pioneer Way, Ste 4', '92020',
  32.8154603, -116.9684350,
  'https://toorknives.com', 'ToorKnives', '(619) 328-6118',
  'Veteran-operated knife manufacturer producing American-made EDC, tactical, and outdoor knives with a largely veteran workforce.',
  1, 0, 1, 0, 1, 1, 1, 0, 1, 'manual', 'seed-thread-2'
);

-- ============================================
-- 3. From Logo to Leather
-- ============================================
INSERT OR IGNORE INTO businesses (
  slug, name, category_id, city, state, street_address, postal_code,
  latitude, longitude, website, twitter_handle, phone,
  short_description,
  veteran_owned, woman_owned, family_owned, immigrant_owned,
  made_in_usa, ships_nationwide, brick_and_mortar, featured, verified, source, source_row_id
) VALUES (
  'from-logo-to-leather', 'From Logo to Leather',
  (SELECT id FROM categories WHERE slug = 'handmade-artisan'),
  'Tampa', 'FL', NULL, NULL,
  27.9449854, -82.4583107,
  NULL, 'vicberggren', NULL,
  'Family-owned custom leather patch business specializing in laser-engraved logos on genuine leather for hats and apparel — find them on X.',
  0, 0, 1, 0, 1, 1, 0, 0, 1, 'manual', 'seed-thread-3'
);

-- ============================================
-- 4. Chagrin Valley Soap & Salve
-- ============================================
INSERT OR IGNORE INTO businesses (
  slug, name, category_id, city, state, street_address, postal_code,
  latitude, longitude, website, twitter_handle, phone,
  short_description,
  veteran_owned, woman_owned, family_owned, immigrant_owned,
  made_in_usa, ships_nationwide, brick_and_mortar, featured, verified, source, source_row_id
) VALUES (
  'chagrin-valley-soap-salve', 'Chagrin Valley Soap & Salve',
  (SELECT id FROM categories WHERE slug = 'health-wellness'),
  'Solon', 'OH', '29425 Aurora Rd', '44139',
  41.3991077, -81.4714949,
  'https://www.chagrinvalleysoapandsalve.com', 'ChagrinSoap', '(440) 248-7627',
  'Family-owned organic skincare company handcrafting over 300 natural soaps, shampoo bars, salves, and body care products since 2001.',
  0, 1, 1, 0, 1, 1, 1, 0, 1, 'manual', 'seed-thread-4'
);

-- ============================================
-- 5. Little Seed Farm
-- ============================================
INSERT OR IGNORE INTO businesses (
  slug, name, category_id, city, state, street_address, postal_code,
  latitude, longitude, website, twitter_handle, phone,
  short_description,
  veteran_owned, woman_owned, family_owned, immigrant_owned,
  made_in_usa, ships_nationwide, brick_and_mortar, featured, verified, source, source_row_id
) VALUES (
  'little-seed-farm', 'Little Seed Farm',
  (SELECT id FROM categories WHERE slug = 'health-wellness'),
  'Lebanon', 'TN', '1275 Whippoorwill Rd', '37090',
  36.2080, -86.2911,
  'https://littleseedfarm.com', 'LittleSeedFarm', '(505) 440-7934',
  'Solar-powered regenerative family farm producing goat milk soaps, natural deodorants, and skincare products shipped nationwide.',
  0, 0, 1, 0, 1, 1, 1, 0, 1, 'manual', 'seed-thread-5'
);

-- ============================================
-- 6. Debra Bruner Studio & Little Cow Mountain Farm
-- ============================================
INSERT OR IGNORE INTO businesses (
  slug, name, category_id, city, state, street_address, postal_code,
  latitude, longitude, website, twitter_handle, phone,
  short_description,
  veteran_owned, woman_owned, family_owned, immigrant_owned,
  made_in_usa, ships_nationwide, brick_and_mortar, featured, verified, source, source_row_id
) VALUES (
  'debra-bruner-studio', 'Debra Bruner Studio & Little Cow Mountain Farm',
  (SELECT id FROM categories WHERE slug = 'farms-agriculture'),
  'Caldwell', 'ID', '11494 Rio Lobo', '83607',
  43.6679, -116.6894,
  'https://www.debrabrunerstudio.com', 'debralynnbruner', '(208) 249-1011',
  'Family regenerative farm raising Aberdeen Angus beef, free-range eggs, and pastured poultry alongside a watercolor art studio.',
  0, 1, 1, 0, 1, 0, 1, 0, 1, 'manual', 'seed-thread-6'
);

-- ============================================
-- 7. ENAK Flavors
-- ============================================
INSERT OR IGNORE INTO businesses (
  slug, name, category_id, city, state, street_address, postal_code,
  latitude, longitude, website, twitter_handle, phone,
  short_description,
  veteran_owned, woman_owned, family_owned, immigrant_owned,
  made_in_usa, ships_nationwide, brick_and_mortar, featured, verified, source, source_row_id
) VALUES (
  'enak-flavors', 'ENAK Flavors',
  (SELECT id FROM categories WHERE slug = 'restaurants-food'),
  'Tuscaloosa', 'AL', NULL, NULL,
  33.2096, -87.5675,
  'https://enakflavors.com', 'enakflavors', NULL,
  'Family-run artisan seasoning company crafting internationally inspired spice blends proudly made in the USA with natural ingredients.',
  0, 0, 1, 0, 1, 1, 0, 0, 1, 'manual', 'seed-thread-7'
);

-- ============================================
-- 8. Infiniti Crafting Company
-- ============================================
INSERT OR IGNORE INTO businesses (
  slug, name, category_id, city, state, street_address, postal_code,
  latitude, longitude, website, twitter_handle, phone,
  short_description,
  veteran_owned, woman_owned, family_owned, immigrant_owned,
  made_in_usa, ships_nationwide, brick_and_mortar, featured, verified, source, source_row_id
) VALUES (
  'infiniti-crafting-company', 'Infiniti Crafting Company',
  (SELECT id FROM categories WHERE slug = 'handmade-artisan'),
  'St. Louis', 'MO', NULL, NULL,
  38.6254, -90.1900,
  'https://www.infiniticraftingcompany.com', 'InfinitiCraftCo', NULL,
  'Christian indie crochet and knit pattern designer offering handmade accessories, tutorials, and self-paced crafting courses.',
  0, 1, 1, 0, 1, 1, 0, 0, 1, 'manual', 'seed-thread-8'
);

-- ============================================
-- 9. The Doghouse Coffee
-- ============================================
INSERT OR IGNORE INTO businesses (
  slug, name, category_id, city, state, street_address, postal_code,
  latitude, longitude, website, twitter_handle, phone,
  short_description,
  veteran_owned, woman_owned, family_owned, immigrant_owned,
  made_in_usa, ships_nationwide, brick_and_mortar, featured, verified, source, source_row_id
) VALUES (
  'the-doghouse-coffee', 'The Doghouse Coffee',
  (SELECT id FROM categories WHERE slug = 'restaurants-food'),
  'Lapeer', 'MI', '454 W Nepessing St', '48446',
  43.0536285, -83.3132543,
  'https://thedoghouse.coffee', 'TheDoghouseHQ', '(810) 660-7160',
  'Woman and veteran-owned coffee roaster and pup-friendly cafe that donates a portion of every purchase to animal rescues and no-kill shelters.',
  1, 1, 1, 0, 1, 1, 1, 0, 1, 'manual', 'seed-thread-9'
);

-- ============================================
-- 10. Original Appearance Manufacturing
-- ============================================
INSERT OR IGNORE INTO businesses (
  slug, name, category_id, city, state, street_address, postal_code,
  latitude, longitude, website, twitter_handle, phone,
  short_description,
  veteran_owned, woman_owned, family_owned, immigrant_owned,
  made_in_usa, ships_nationwide, brick_and_mortar, featured, verified, source, source_row_id
) VALUES (
  'original-appearance-manufacturing', 'Original Appearance Manufacturing',
  (SELECT id FROM categories WHERE slug = 'services-trades'),
  'Ames', 'IA', '2248 229th Place, Unit A', '50014',
  42.0258913, -93.6647526,
  'https://oamusa.com', 'zachkowalik', '(515) 233-3244',
  'Family-owned Iowa manufacturer of precision-molded truck rocker panel covers and cab corner covers, designed and produced with US-sourced materials.',
  0, 0, 1, 0, 1, 1, 0, 0, 1, 'manual', 'seed-thread-10'
);

-- ============================================
-- 11. Kickin' Back Kreations
-- ============================================
INSERT OR IGNORE INTO businesses (
  slug, name, category_id, city, state, street_address, postal_code,
  latitude, longitude, website, twitter_handle, phone,
  short_description,
  veteran_owned, woman_owned, family_owned, immigrant_owned,
  made_in_usa, ships_nationwide, brick_and_mortar, featured, verified, source, source_row_id
) VALUES (
  'kickin-back-kreations', 'Kickin'' Back Kreations',
  (SELECT id FROM categories WHERE slug = 'handmade-artisan'),
  'Gilmer', 'TX', '5197 FM 2685', '75645',
  32.7288030, -94.9445572,
  'https://kickinbackkreations.com', 'KicBacKreations', '(903) 734-4210',
  'Three-generation family business crafting custom steel outdoor furniture, fire pits, and grills from American steel at their East Texas workshop.',
  1, 0, 1, 0, 1, 1, 1, 0, 1, 'manual', 'seed-thread-11'
);

-- ============================================
-- 12. Happy Life Ranch
-- ============================================
INSERT OR IGNORE INTO businesses (
  slug, name, category_id, city, state, street_address, postal_code,
  latitude, longitude, website, twitter_handle, phone,
  short_description,
  veteran_owned, woman_owned, family_owned, immigrant_owned,
  made_in_usa, ships_nationwide, brick_and_mortar, featured, verified, source, source_row_id
) VALUES (
  'happy-life-ranch', 'Happy Life Ranch',
  (SELECT id FROM categories WHERE slug = 'farms-agriculture'),
  'Beecher', 'IL', '1945 W Indiana Ave', '60401',
  41.3406612, -87.6310975,
  'https://happyliferanch.com', 'HappyLifeRanch', '(630) 877-7718',
  'Family-operated pasture-raised ranch offering beef, pork, lamb, chicken, eggs, and raw dairy — no antibiotics, hormones, GMOs, corn, or soy.',
  0, 0, 1, 0, 1, 0, 1, 0, 1, 'manual', 'seed-thread-12'
);

-- ============================================
-- BADGES: original-thread for all 12
-- ============================================
INSERT OR IGNORE INTO business_badges (business_id, badge_id)
SELECT b.id, ba.id FROM businesses b, badges ba
WHERE b.source_row_id LIKE 'seed-thread-%' AND ba.slug = 'original-thread';

-- made-in-usa for all 12
INSERT OR IGNORE INTO business_badges (business_id, badge_id)
SELECT b.id, ba.id FROM businesses b, badges ba
WHERE b.source_row_id LIKE 'seed-thread-%' AND ba.slug = 'made-in-usa';

-- veteran-owned
INSERT OR IGNORE INTO business_badges (business_id, badge_id)
SELECT b.id, ba.id FROM businesses b, badges ba
WHERE b.slug IN ('ex-umbris-designs','toor-knives','the-doghouse-coffee','kickin-back-kreations')
  AND ba.slug = 'veteran-owned';

-- ships-nationwide
INSERT OR IGNORE INTO business_badges (business_id, badge_id)
SELECT b.id, ba.id FROM businesses b, badges ba
WHERE b.slug IN ('ex-umbris-designs','toor-knives','from-logo-to-leather','chagrin-valley-soap-salve',
                 'little-seed-farm','enak-flavors','infiniti-crafting-company',
                 'the-doghouse-coffee','original-appearance-manufacturing','kickin-back-kreations')
  AND ba.slug = 'ships-nationwide';

-- family-business
INSERT OR IGNORE INTO business_badges (business_id, badge_id)
SELECT b.id, ba.id FROM businesses b, badges ba
WHERE b.slug IN ('from-logo-to-leather','chagrin-valley-soap-salve','little-seed-farm',
                 'debra-bruner-studio','enak-flavors','infiniti-crafting-company',
                 'the-doghouse-coffee','original-appearance-manufacturing',
                 'kickin-back-kreations','happy-life-ranch')
  AND ba.slug = 'family-business';
