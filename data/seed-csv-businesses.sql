-- ============================================================
-- SEED: ~45 businesses from data/table.csv (Feb 21 viral thread)
-- Groups A (1-15), B (16-31), C (108-121)
-- Run: npx wrangler d1 execute patriot_directory_db --remote --file=data/seed-csv-businesses.sql
-- ============================================================

-- ============================================================
-- GROUP A: Businesses 1-15
-- ============================================================

-- 1. Humming Meadow Honey
INSERT OR IGNORE INTO businesses (
  slug, name, category_id, city, state, street_address, postal_code,
  latitude, longitude, website, twitter_handle, phone,
  short_description,
  veteran_owned, woman_owned, family_owned, immigrant_owned,
  made_in_usa, ships_nationwide, brick_and_mortar, featured, verified, source, source_row_id
) VALUES (
  'humming-meadow-honey', 'Humming Meadow Honey',
  (SELECT id FROM categories WHERE slug = 'farms-agriculture'),
  'Unknown', 'VT', NULL, NULL,
  NULL, NULL,
  'https://hummingmeadowhoney.com', 'OldHollowTree', NULL,
  'Family beekeepers in the hills of Vermont producing raw wildflower honey and hand-poured pure beeswax candles. No chemicals, no plastic.',
  0, 0, 1, 0, 1, 1, 0, 0, 1, 'manual', 'csv-a-1'
);

-- 2. Kiel James Patrick
INSERT OR IGNORE INTO businesses (
  slug, name, category_id, city, state, street_address, postal_code,
  latitude, longitude, website, twitter_handle, phone,
  short_description,
  veteran_owned, woman_owned, family_owned, immigrant_owned,
  made_in_usa, ships_nationwide, brick_and_mortar, featured, verified, source, source_row_id
) VALUES (
  'kiel-james-patrick', 'Kiel James Patrick',
  (SELECT id FROM categories WHERE slug = 'apparel-accessories'),
  'Newport', 'RI', '3 Bowens Wharf', NULL,
  NULL, NULL,
  'https://kieljamespatrick.com', 'KJP', NULL,
  'Classic New England clothing and accessories. American-made fashion founded by husband-and-wife team, with a flagship store on Bowens Wharf in Newport.',
  0, 0, 1, 0, 1, 1, 1, 0, 1, 'manual', 'csv-a-2'
);

-- 3. The Buffalo Wool Co.
INSERT OR IGNORE INTO businesses (
  slug, name, category_id, city, state, street_address, postal_code,
  latitude, longitude, website, twitter_handle, phone,
  short_description,
  veteran_owned, woman_owned, family_owned, immigrant_owned,
  made_in_usa, ships_nationwide, brick_and_mortar, featured, verified, source, source_row_id
) VALUES (
  'the-buffalo-wool-co', 'The Buffalo Wool Co.',
  (SELECT id FROM categories WHERE slug = 'apparel-accessories'),
  'Unknown', 'TX', NULL, NULL,
  NULL, NULL,
  'https://thebuffalowoolco.com', 'BuffaloRon', NULL,
  'North Texas family raising bison for nearly 30 years. American bison fiber socks, hats, and yarn with a 100% satisfaction guarantee.',
  0, 0, 1, 0, 1, 1, 0, 0, 1, 'manual', 'csv-a-3'
);

-- 4. Fountain's Coffee
INSERT OR IGNORE INTO businesses (
  slug, name, category_id, city, state, street_address, postal_code,
  latitude, longitude, website, twitter_handle, phone,
  short_description,
  veteran_owned, woman_owned, family_owned, immigrant_owned,
  made_in_usa, ships_nationwide, brick_and_mortar, featured, verified, source, source_row_id
) VALUES (
  'fountains-coffee', 'Fountain''s Coffee',
  (SELECT id FROM categories WHERE slug = 'restaurants-food'),
  'Unknown', 'USA', NULL, NULL,
  NULL, NULL,
  'https://www.fountainscoffee.com', 'hcfountain', NULL,
  'Specialty coffee brand offering organic blends and cold brew. Crafted for hikers and adventurers.',
  0, 0, 1, 0, 1, 1, 0, 0, 1, 'manual', 'csv-a-4'
);

-- 5. The Woolshire
INSERT OR IGNORE INTO businesses (
  slug, name, category_id, city, state, street_address, postal_code,
  latitude, longitude, website, twitter_handle, phone,
  short_description,
  veteran_owned, woman_owned, family_owned, immigrant_owned,
  made_in_usa, ships_nationwide, brick_and_mortar, featured, verified, source, source_row_id
) VALUES (
  'the-woolshire', 'The Woolshire',
  (SELECT id FROM categories WHERE slug = 'home-building'),
  'Unknown', 'ID', NULL, NULL,
  NULL, NULL,
  'https://thewoolshire.com', 'thewoolshire', NULL,
  'Family-run Idaho business making non-toxic wool pillows with USDA certified organic cotton covers. Handmade with local Northwest wool, no chemicals.',
  0, 0, 1, 0, 1, 1, 0, 0, 1, 'manual', 'csv-a-5'
);

-- 6. Fox & Root
INSERT OR IGNORE INTO businesses (
  slug, name, category_id, city, state, street_address, postal_code,
  latitude, longitude, website, twitter_handle, phone,
  short_description,
  veteran_owned, woman_owned, family_owned, immigrant_owned,
  made_in_usa, ships_nationwide, brick_and_mortar, featured, verified, source, source_row_id
) VALUES (
  'fox-and-root', 'Fox & Root',
  (SELECT id FROM categories WHERE slug = 'apparel-accessories'),
  'Unknown', 'MI', NULL, NULL,
  NULL, NULL,
  'https://www.foxandroot.com', 'foxandroot', NULL,
  'Fine menswear brand specializing in ascots and classic accessories. Elegant style with a focus on timeless craftsmanship.',
  0, 0, 0, 0, 1, 1, 0, 0, 1, 'manual', 'csv-a-6'
);

-- 7. Ambrosian Candle Co.
INSERT OR IGNORE INTO businesses (
  slug, name, category_id, city, state, street_address, postal_code,
  latitude, longitude, website, twitter_handle, phone,
  short_description,
  veteran_owned, woman_owned, family_owned, immigrant_owned,
  made_in_usa, ships_nationwide, brick_and_mortar, featured, verified, source, source_row_id
) VALUES (
  'ambrosian-candle-co', 'Ambrosian Candle Co.',
  (SELECT id FROM categories WHERE slug = 'handmade-artisan'),
  'Unknown', 'NY', NULL, NULL,
  NULL, NULL,
  'https://ambrosiancandles.com', 'ambrosian_co', NULL,
  'Catholic family homestead producing 100% pure beeswax candles in the Adirondack foothills of northern New York. Artisan beekeepers with 800 colonies.',
  0, 0, 1, 0, 1, 1, 0, 0, 1, 'manual', 'csv-a-7'
);

-- 8. Cotedge
INSERT OR IGNORE INTO businesses (
  slug, name, category_id, city, state, street_address, postal_code,
  latitude, longitude, website, twitter_handle, phone,
  short_description,
  veteran_owned, woman_owned, family_owned, immigrant_owned,
  made_in_usa, ships_nationwide, brick_and_mortar, featured, verified, source, source_row_id
) VALUES (
  'cotedge-socks', 'Cotedge',
  (SELECT id FROM categories WHERE slug = 'apparel-accessories'),
  'Unknown', 'USA', NULL, NULL,
  NULL, NULL,
  'https://cotedge.com', 'cotedgeshop', NULL,
  'Hand-cranked 100% cotton socks made in the USA by Kevin. Bespoke fit to your exact shoe size. No polyester, nylon, or spandex.',
  0, 0, 0, 0, 1, 1, 0, 0, 1, 'manual', 'csv-a-8'
);

-- 9. Tamburn Bindery
INSERT OR IGNORE INTO businesses (
  slug, name, category_id, city, state, street_address, postal_code,
  latitude, longitude, website, twitter_handle, phone,
  short_description,
  veteran_owned, woman_owned, family_owned, immigrant_owned,
  made_in_usa, ships_nationwide, brick_and_mortar, featured, verified, source, source_row_id
) VALUES (
  'tamburn-bindery', 'Tamburn Bindery',
  (SELECT id FROM categories WHERE slug = 'handmade-artisan'),
  'Unknown', 'VA', NULL, NULL,
  NULL, NULL,
  'https://www.etsy.com/shop/TamburnBindery', 'AHomelyHouse', NULL,
  'Shenandoah Valley bookbinder and illuminator preserving Catholic culture using medieval methods. Founded by Joel Trumbo, former Army Ranger and SOF veteran.',
  1, 0, 1, 0, 1, 1, 0, 0, 1, 'manual', 'csv-a-9'
);

-- 10. Galloway Woodworks
INSERT OR IGNORE INTO businesses (
  slug, name, category_id, city, state, street_address, postal_code,
  latitude, longitude, website, twitter_handle, phone,
  short_description,
  veteran_owned, woman_owned, family_owned, immigrant_owned,
  made_in_usa, ships_nationwide, brick_and_mortar, featured, verified, source, source_row_id
) VALUES (
  'galloway-woodworks', 'Galloway Woodworks',
  (SELECT id FROM categories WHERE slug = 'handmade-artisan'),
  'Unknown', 'USA', NULL, NULL,
  NULL, NULL,
  NULL, 'Gallo_Woodworks', NULL,
  'Anglican woodworker crafting CNC-carved crucifixes, end-grain cutting boards, and custom wood pieces. Collaborates with other artisan makers.',
  0, 0, 0, 0, 1, 1, 0, 0, 1, 'manual', 'csv-a-10'
);

-- 11. Middleborne Arms (Elijah the Middleborne Woodworks)
INSERT OR IGNORE INTO businesses (
  slug, name, category_id, city, state, street_address, postal_code,
  latitude, longitude, website, twitter_handle, phone,
  short_description,
  veteran_owned, woman_owned, family_owned, immigrant_owned,
  made_in_usa, ships_nationwide, brick_and_mortar, featured, verified, source, source_row_id
) VALUES (
  'middleborne-arms', 'Middleborne Arms',
  (SELECT id FROM categories WHERE slug = 'handmade-artisan'),
  'Carpenter', 'MO', NULL, NULL,
  NULL, NULL,
  'https://www.middlebornearms.com', 'TheMiddleborne', NULL,
  'Family business handcrafting wooden swords, bookmarks, and weapons from various wood species. Historical replicas and fantasy-inspired designs.',
  0, 0, 1, 0, 1, 1, 0, 0, 1, 'manual', 'csv-a-11'
);

-- 12. Lawrence of Appalachia
INSERT OR IGNORE INTO businesses (
  slug, name, category_id, city, state, street_address, postal_code,
  latitude, longitude, website, twitter_handle, phone,
  short_description,
  veteran_owned, woman_owned, family_owned, immigrant_owned,
  made_in_usa, ships_nationwide, brick_and_mortar, featured, verified, source, source_row_id
) VALUES (
  'lawrence-of-appalachia', 'Lawrence of Appalachia',
  (SELECT id FROM categories WHERE slug = 'handmade-artisan'),
  'Unknown', 'USA', NULL, NULL,
  NULL, NULL,
  'https://www.mythanthrope.com', 'mythanthrope', NULL,
  'Bespoke leather wallets and bags handcrafted in Appalachia. Small-batch artisan leatherwork.',
  0, 0, 0, 0, 1, 1, 0, 0, 1, 'manual', 'csv-a-12'
);

-- 13. Black Wolf Homestead
INSERT OR IGNORE INTO businesses (
  slug, name, category_id, city, state, street_address, postal_code,
  latitude, longitude, website, twitter_handle, phone,
  short_description,
  veteran_owned, woman_owned, family_owned, immigrant_owned,
  made_in_usa, ships_nationwide, brick_and_mortar, featured, verified, source, source_row_id
) VALUES (
  'black-wolf-homestead', 'Black Wolf Homestead',
  (SELECT id FROM categories WHERE slug = 'handmade-artisan'),
  'Richmond', 'VA', NULL, NULL,
  NULL, NULL,
  'https://www.etsy.com/shop/BethAnneMakes', 'Beth33374166', NULL,
  'Richmond, Virginia crocheter making handmade blankets, scarves, hats, and earrings. Run by Beth alongside a family concrete and masonry business.',
  0, 1, 1, 0, 1, 1, 0, 0, 1, 'manual', 'csv-a-13'
);

-- 14. BARITUS Catholic Illustration
INSERT OR IGNORE INTO businesses (
  slug, name, category_id, city, state, street_address, postal_code,
  latitude, longitude, website, twitter_handle, phone,
  short_description,
  veteran_owned, woman_owned, family_owned, immigrant_owned,
  made_in_usa, ships_nationwide, brick_and_mortar, featured, verified, source, source_row_id
) VALUES (
  'baritus-catholic-illustration', 'BARITUS Catholic Illustration',
  (SELECT id FROM categories WHERE slug = 'faith-family'),
  'Unknown', 'GA', NULL, NULL,
  NULL, NULL,
  'https://www.barituscatholic.com', 'BaritusCatholic', NULL,
  'Georgia-based Catholic illustrator creating graphic tees, vinyl decals, art prints, prayer cards, and patches. Founded 2017 after a faith conversion.',
  0, 0, 1, 0, 1, 1, 0, 0, 1, 'manual', 'csv-a-14'
);

-- 15. Bake Across Europe
INSERT OR IGNORE INTO businesses (
  slug, name, category_id, city, state, street_address, postal_code,
  latitude, longitude, website, twitter_handle, phone,
  short_description,
  veteran_owned, woman_owned, family_owned, immigrant_owned,
  made_in_usa, ships_nationwide, brick_and_mortar, featured, verified, source, source_row_id
) VALUES (
  'bake-across-europe', 'Bake Across Europe',
  (SELECT id FROM categories WHERE slug = 'books-media'),
  'Unknown', 'USA', NULL, NULL,
  NULL, NULL,
  'https://www.bakeacrosseurope.com', 'BakeEurope', NULL,
  'Baking e-books and recipes exploring European culinary traditions. Run by Kristin, sharing history, culture, and recipes from across Europe.',
  0, 1, 0, 0, 0, 1, 0, 0, 1, 'manual', 'csv-a-15'
);

-- ============================================================
-- GROUP B: Businesses 16-31
-- ============================================================

-- 16. Orthodox Masonry
INSERT OR IGNORE INTO businesses (
  slug, name, category_id, city, state, street_address, postal_code,
  latitude, longitude, website, twitter_handle, phone,
  short_description,
  veteran_owned, woman_owned, family_owned, immigrant_owned,
  made_in_usa, ships_nationwide, brick_and_mortar, featured, verified, source, source_row_id
) VALUES (
  'orthodox-mason', 'Orthodox Masonry',
  (SELECT id FROM categories WHERE slug = 'home-building'),
  'Saxtons River', 'VT', NULL, '05154',
  NULL, NULL,
  'https://www.orthodoxmasonry.com', 'orthodoxmason', NULL,
  'Custom design and build firm specializing in traditional masonry, old world fireplaces, and timber framing. Founded by Patrick Lemmon in 2016.',
  0, 0, 0, 0, 1, 0, 1, 0, 1, 'manual', 'csv-b-1'
);

-- 17. Seraphim Print Studio
INSERT OR IGNORE INTO businesses (
  slug, name, category_id, city, state, street_address, postal_code,
  latitude, longitude, website, twitter_handle, phone,
  short_description,
  veteran_owned, woman_owned, family_owned, immigrant_owned,
  made_in_usa, ships_nationwide, brick_and_mortar, featured, verified, source, source_row_id
) VALUES (
  'seraphim-print-studio', 'Seraphim Print Studio',
  (SELECT id FROM categories WHERE slug = 'faith-family'),
  'Trinity', 'AL', NULL, NULL,
  NULL, NULL,
  'https://www.seraphimprintstudio.com', 'SeraphimPrints', NULL,
  'Handcrafted Catholic and Orthodox devotional items including linocut art prints, restored medieval art prints, prayer cards, and apparel.',
  0, 1, 0, 0, 1, 1, 0, 0, 1, 'manual', 'csv-b-2'
);

-- 18. Gubba Homestead
INSERT OR IGNORE INTO businesses (
  slug, name, category_id, city, state, street_address, postal_code,
  latitude, longitude, website, twitter_handle, phone,
  short_description,
  veteran_owned, woman_owned, family_owned, immigrant_owned,
  made_in_usa, ships_nationwide, brick_and_mortar, featured, verified, source, source_row_id
) VALUES (
  'gubba-homestead', 'Gubba Homestead',
  (SELECT id FROM categories WHERE slug = 'health-wellness'),
  'Unknown', 'WA', NULL, NULL,
  NULL, NULL,
  'https://shop.gubbahomestead.com', 'GubbaHomestead', NULL,
  'All-natural tallow skincare, homesteading courses, and emergency preparedness products. Chemical-free alternatives from a working farm.',
  0, 1, 0, 0, 1, 1, 0, 0, 1, 'manual', 'csv-b-3'
);

-- 19. Wading Smith Woodworks
INSERT OR IGNORE INTO businesses (
  slug, name, category_id, city, state, street_address, postal_code,
  latitude, longitude, website, twitter_handle, phone,
  short_description,
  veteran_owned, woman_owned, family_owned, immigrant_owned,
  made_in_usa, ships_nationwide, brick_and_mortar, featured, verified, source, source_row_id
) VALUES (
  'wading-smith-woodworks', 'Wading Smith Woodworks',
  (SELECT id FROM categories WHERE slug = 'handmade-artisan'),
  'Unknown', 'PA', NULL, NULL,
  NULL, NULL,
  NULL, 'WadingSmith', NULL,
  'Custom hardwood lumber and woodworking based in Pennsylvania.',
  0, 0, 0, 0, 1, 0, 1, 0, 1, 'manual', 'csv-b-4'
);

-- 20. Cottage Pastures
INSERT OR IGNORE INTO businesses (
  slug, name, category_id, city, state, street_address, postal_code,
  latitude, longitude, website, twitter_handle, phone,
  short_description,
  veteran_owned, woman_owned, family_owned, immigrant_owned,
  made_in_usa, ships_nationwide, brick_and_mortar, featured, verified, source, source_row_id
) VALUES (
  'cottage-pastures', 'Cottage Pastures',
  (SELECT id FROM categories WHERE slug = 'farms-agriculture'),
  'Vevay', 'IN', NULL, NULL,
  NULL, NULL,
  'https://cottagepastures.com', 'Mathew_of_LWFAH', NULL,
  'Regenerative family farm producing pasture-raised beef, chicken, eggs, and heirloom garlic. Non-GMO, soy-free, no synthetic chemicals.',
  0, 0, 1, 0, 1, 1, 1, 0, 1, 'manual', 'csv-b-5'
);

-- 21. Wasson Watch Co.
INSERT OR IGNORE INTO businesses (
  slug, name, category_id, city, state, street_address, postal_code,
  latitude, longitude, website, twitter_handle, phone,
  short_description,
  veteran_owned, woman_owned, family_owned, immigrant_owned,
  made_in_usa, ships_nationwide, brick_and_mortar, featured, verified, source, source_row_id
) VALUES (
  'wasson-watch-co', 'Wasson Watch Co.',
  (SELECT id FROM categories WHERE slug = 'apparel-accessories'),
  'Richardson', 'TX', NULL, NULL,
  NULL, NULL,
  'https://wassonwatch.com', 'WassonWatch', NULL,
  'Automatic field and dive watches founded by US Marine Corps veteran Paul Brown. Swiss-made movements, designed in Texas.',
  1, 0, 0, 0, 0, 1, 0, 0, 1, 'manual', 'csv-b-6'
);

-- 22. North Rangers Co.
INSERT OR IGNORE INTO businesses (
  slug, name, category_id, city, state, street_address, postal_code,
  latitude, longitude, website, twitter_handle, phone,
  short_description,
  veteran_owned, woman_owned, family_owned, immigrant_owned,
  made_in_usa, ships_nationwide, brick_and_mortar, featured, verified, source, source_row_id
) VALUES (
  'north-ranger', 'North Rangers Co.',
  (SELECT id FROM categories WHERE slug = 'handmade-artisan'),
  'Unknown', 'USA', NULL, NULL,
  NULL, NULL,
  'https://northrangers.com', 'n0rthranger', NULL,
  'Handmade Western-style candles from 100% pure beeswax and organic soy wax. Beeswax sourced from Illinois and Iowa apiaries.',
  0, 0, 1, 0, 1, 1, 0, 0, 1, 'manual', 'csv-b-7'
);

-- 23. Peaces of Indigo Jewelry
INSERT OR IGNORE INTO businesses (
  slug, name, category_id, city, state, street_address, postal_code,
  latitude, longitude, website, twitter_handle, phone,
  short_description,
  veteran_owned, woman_owned, family_owned, immigrant_owned,
  made_in_usa, ships_nationwide, brick_and_mortar, featured, verified, source, source_row_id
) VALUES (
  'peaces-of-indigo', 'Peaces of Indigo Jewelry',
  (SELECT id FROM categories WHERE slug = 'handmade-artisan'),
  'Unknown', 'TN', NULL, NULL,
  NULL, NULL,
  'https://www.peacesofindigo.com', 'PeacesOfIndigo', NULL,
  'Artisan jewelry handcrafted in Tennessee using recycled sterling silver, gold, and natural gemstones. Hand-engraved quotes and details.',
  0, 1, 0, 0, 1, 1, 0, 0, 1, 'manual', 'csv-b-8'
);

-- 24. Nicholas Hayford Jewelry
INSERT OR IGNORE INTO businesses (
  slug, name, category_id, city, state, street_address, postal_code,
  latitude, longitude, website, twitter_handle, phone,
  short_description,
  veteran_owned, woman_owned, family_owned, immigrant_owned,
  made_in_usa, ships_nationwide, brick_and_mortar, featured, verified, source, source_row_id
) VALUES (
  'nicholas-hayford-jewelry', 'Nicholas Hayford Jewelry',
  (SELECT id FROM categories WHERE slug = 'handmade-artisan'),
  'Memphis', 'TN', NULL, NULL,
  NULL, NULL,
  NULL, 'sirnicholasch', NULL,
  'Custom hand-fabricated jewelry by GIA-trained bench jeweler Nicholas Hayford. Specializes in bespoke pieces and engagement rings.',
  0, 0, 0, 0, 1, 1, 0, 0, 1, 'manual', 'csv-b-9'
);

-- 25. Eli Sherbondy Machining
INSERT OR IGNORE INTO businesses (
  slug, name, category_id, city, state, street_address, postal_code,
  latitude, longitude, website, twitter_handle, phone,
  short_description,
  veteran_owned, woman_owned, family_owned, immigrant_owned,
  made_in_usa, ships_nationwide, brick_and_mortar, featured, verified, source, source_row_id
) VALUES (
  'eli-sherbondy-machining', 'Eli Sherbondy Machining',
  (SELECT id FROM categories WHERE slug = 'services-trades'),
  'Unknown', 'PA', NULL, NULL,
  NULL, NULL,
  NULL, 'Eli_Sherbondy', NULL,
  'Custom machining shop in Pennsylvania specializing in custom dies, punches, and precision metal work.',
  0, 0, 0, 0, 1, 1, 1, 0, 1, 'manual', 'csv-b-10'
);

-- 26. Primal Aromas
INSERT OR IGNORE INTO businesses (
  slug, name, category_id, city, state, street_address, postal_code,
  latitude, longitude, website, twitter_handle, phone,
  short_description,
  veteran_owned, woman_owned, family_owned, immigrant_owned,
  made_in_usa, ships_nationwide, brick_and_mortar, featured, verified, source, source_row_id
) VALUES (
  'primal-aromas', 'Primal Aromas',
  (SELECT id FROM categories WHERE slug = 'handmade-artisan'),
  'Unknown', 'IA', NULL, NULL,
  NULL, NULL,
  'https://primalaromas.com', 'HunterFrench23', NULL,
  'Organic beeswax candles with essential oils sourced from small apiaries in southern Iowa. 100% natural, clean ingredients.',
  0, 0, 0, 0, 1, 1, 0, 0, 1, 'manual', 'csv-b-11'
);

-- 27. Evers Forge Works
INSERT OR IGNORE INTO businesses (
  slug, name, category_id, city, state, street_address, postal_code,
  latitude, longitude, website, twitter_handle, phone,
  short_description,
  veteran_owned, woman_owned, family_owned, immigrant_owned,
  made_in_usa, ships_nationwide, brick_and_mortar, featured, verified, source, source_row_id
) VALUES (
  'evers-forge-works', 'Evers Forge Works',
  (SELECT id FROM categories WHERE slug = 'handmade-artisan'),
  'Eagle Pass', 'TX', NULL, NULL,
  NULL, NULL,
  'https://www.eversforgeworks.com', 'EversForgeworks', NULL,
  'South Texas bladesmith John David Evers forging custom knives, axes, and metal art. From Native American art to modern cutlery.',
  0, 0, 0, 0, 1, 1, 1, 0, 1, 'manual', 'csv-b-12'
);

-- 28. 'Merican AF
INSERT OR IGNORE INTO businesses (
  slug, name, category_id, city, state, street_address, postal_code,
  latitude, longitude, website, twitter_handle, phone,
  short_description,
  veteran_owned, woman_owned, family_owned, immigrant_owned,
  made_in_usa, ships_nationwide, brick_and_mortar, featured, verified, source, source_row_id
) VALUES (
  'merican-af', '''Merican AF',
  (SELECT id FROM categories WHERE slug = 'handmade-artisan'),
  'Unknown', 'USA', NULL, NULL,
  NULL, NULL,
  NULL, 'mericanaf7', NULL,
  'Handmade wood furniture crafted in America. Custom pieces built with pride.',
  0, 0, 0, 0, 1, 1, 0, 0, 1, 'manual', 'csv-b-13'
);

-- 29. Silver Gold Honey Company
INSERT OR IGNORE INTO businesses (
  slug, name, category_id, city, state, street_address, postal_code,
  latitude, longitude, website, twitter_handle, phone,
  short_description,
  veteran_owned, woman_owned, family_owned, immigrant_owned,
  made_in_usa, ships_nationwide, brick_and_mortar, featured, verified, source, source_row_id
) VALUES (
  'silver-gold-honey-company', 'Silver Gold Honey Company',
  (SELECT id FROM categories WHERE slug = 'farms-agriculture'),
  'Unknown', 'WI', NULL, NULL,
  NULL, NULL,
  NULL, 'SilverGoldHoney', NULL,
  'Raw Midwest-made honey and precious metal art from Wisconsin. Honey priced in silver.',
  0, 0, 1, 0, 1, 1, 0, 0, 1, 'manual', 'csv-b-14'
);

-- 30. Halfacre Farms at Armadillo Acres
INSERT OR IGNORE INTO businesses (
  slug, name, category_id, city, state, street_address, postal_code,
  latitude, longitude, website, twitter_handle, phone,
  short_description,
  veteran_owned, woman_owned, family_owned, immigrant_owned,
  made_in_usa, ships_nationwide, brick_and_mortar, featured, verified, source, source_row_id
) VALUES (
  'armadillo-acres-farm', 'Halfacre Farms at Armadillo Acres',
  (SELECT id FROM categories WHERE slug = 'farms-agriculture'),
  'Indianola', 'IA', '10832 Ray Street', '50125',
  NULL, NULL,
  'https://halfacre-farms.com', 'Armadillo_Acres', NULL,
  'Small family farm on 10 acres in Indianola, Iowa raising animals and growing vegetables using organic methods. In operation since 1900.',
  0, 0, 1, 0, 1, 0, 1, 0, 1, 'manual', 'csv-b-15'
);

-- 31. TLC Ranch
INSERT OR IGNORE INTO businesses (
  slug, name, category_id, city, state, street_address, postal_code,
  latitude, longitude, website, twitter_handle, phone,
  short_description,
  veteran_owned, woman_owned, family_owned, immigrant_owned,
  made_in_usa, ships_nationwide, brick_and_mortar, featured, verified, source, source_row_id
) VALUES (
  'tlc-ranch', 'TLC Ranch',
  (SELECT id FROM categories WHERE slug = 'farms-agriculture'),
  'Burneyville', 'OK', NULL, NULL,
  NULL, NULL,
  'https://tlcranch.com', 'Cindy_TLC_Ranch', NULL,
  'Regenerative bison ranch and organic pecan orchard run by Cindy Sheffield. 85 acres producing nutrient-dense bison meat, pecans, and honey.',
  0, 1, 1, 0, 1, 1, 1, 0, 1, 'manual', 'csv-b-16'
);

-- ============================================================
-- GROUP C: Businesses 108-121
-- ============================================================

-- 108. Ave Maria Every Day
INSERT OR IGNORE INTO businesses (
  slug, name, category_id, city, state, street_address, postal_code,
  latitude, longitude, website, twitter_handle, phone,
  short_description,
  veteran_owned, woman_owned, family_owned, immigrant_owned,
  made_in_usa, ships_nationwide, brick_and_mortar, featured, verified, source, source_row_id
) VALUES (
  'ave-maria-every-day', 'Ave Maria Every Day',
  (SELECT id FROM categories WHERE slug = 'faith-family'),
  'Unknown', 'USA', NULL, NULL,
  NULL, NULL,
  'https://www.etsy.com/shop/AveMariaEveryDay', 'BreeSolstad', NULL,
  'Handmade custom rosaries, chaplets, and pendants crafted by Catholic convert Bree Solstad.',
  0, 1, 0, 0, 1, 1, 0, 0, 1, 'manual', 'csv-c-1'
);

-- 109. Puresteel Co.
INSERT OR IGNORE INTO businesses (
  slug, name, category_id, city, state, street_address, postal_code,
  latitude, longitude, website, twitter_handle, phone,
  short_description,
  veteran_owned, woman_owned, family_owned, immigrant_owned,
  made_in_usa, ships_nationwide, brick_and_mortar, featured, verified, source, source_row_id
) VALUES (
  'puresteel-co', 'Puresteel Co.',
  (SELECT id FROM categories WHERE slug = 'home-building'),
  'Austin', 'TX', NULL, NULL,
  NULL, NULL,
  'https://puresteelco.com', 'forestmanjohn', NULL,
  '100% plastic-free stainless steel coffee maker designed by a former SpaceX engineer. Made in Austin, TX.',
  0, 0, 0, 0, 1, 1, 0, 0, 1, 'manual', 'csv-c-2'
);

-- 110. American Lictor
INSERT OR IGNORE INTO businesses (
  slug, name, category_id, city, state, street_address, postal_code,
  latitude, longitude, website, twitter_handle, phone,
  short_description,
  veteran_owned, woman_owned, family_owned, immigrant_owned,
  made_in_usa, ships_nationwide, brick_and_mortar, featured, verified, source, source_row_id
) VALUES (
  'american-lictor', 'American Lictor',
  (SELECT id FROM categories WHERE slug = 'apparel-accessories'),
  'Unknown', 'USA', NULL, NULL,
  NULL, NULL,
  'https://americanlictor.com', 'AmericanLictor', NULL,
  'American-made screen-printed apparel using domestic cotton, yarn, inks, and tools. 100% made in USA.',
  0, 0, 0, 0, 1, 1, 0, 0, 1, 'manual', 'csv-c-3'
);

-- 111. Taylor Shellfish Farms
INSERT OR IGNORE INTO businesses (
  slug, name, category_id, city, state, street_address, postal_code,
  latitude, longitude, website, twitter_handle, phone,
  short_description,
  veteran_owned, woman_owned, family_owned, immigrant_owned,
  made_in_usa, ships_nationwide, brick_and_mortar, featured, verified, source, source_row_id
) VALUES (
  'taylor-shellfish-farms', 'Taylor Shellfish Farms',
  (SELECT id FROM categories WHERE slug = 'farms-agriculture'),
  'Shelton', 'WA', '130 SE Lynch Rd', '98584',
  NULL, NULL,
  'https://www.taylorshellfishfarms.com', 'taylorshellfish', '(360) 426-6178',
  'America''s largest farmed shellfish producer, family-owned since the 1890s. Oysters, clams, mussels, and geoduck from Puget Sound.',
  0, 0, 1, 0, 1, 1, 1, 0, 1, 'manual', 'csv-c-4'
);

-- 112. Chooch Skookum
INSERT OR IGNORE INTO businesses (
  slug, name, category_id, city, state, street_address, postal_code,
  latitude, longitude, website, twitter_handle, phone,
  short_description,
  veteran_owned, woman_owned, family_owned, immigrant_owned,
  made_in_usa, ships_nationwide, brick_and_mortar, featured, verified, source, source_row_id
) VALUES (
  'chooch-skookum', 'Chooch Skookum',
  (SELECT id FROM categories WHERE slug = 'handmade-artisan'),
  'Unknown', 'USA', NULL, NULL,
  NULL, NULL,
  NULL, 'ChoochSkookum', NULL,
  'Handcrafted woodturned bowls and artisan woodwork.',
  0, 0, 0, 0, 1, 1, 0, 0, 1, 'manual', 'csv-c-5'
);

-- 113. Appalachian Wood Homestead
INSERT OR IGNORE INTO businesses (
  slug, name, category_id, city, state, street_address, postal_code,
  latitude, longitude, website, twitter_handle, phone,
  short_description,
  veteran_owned, woman_owned, family_owned, immigrant_owned,
  made_in_usa, ships_nationwide, brick_and_mortar, featured, verified, source, source_row_id
) VALUES (
  'appalachian-wood-homestead', 'Appalachian Wood Homestead',
  (SELECT id FROM categories WHERE slug = 'home-building'),
  'Unknown', 'SC', NULL, NULL,
  NULL, NULL,
  NULL, 'AppWoodHome', NULL,
  'South Carolina-based timber framing and homestead woodworking.',
  0, 0, 0, 0, 1, 0, 0, 0, 1, 'manual', 'csv-c-6'
);

-- 114. Parro's Gun Shop & Indoor Range
INSERT OR IGNORE INTO businesses (
  slug, name, category_id, city, state, street_address, postal_code,
  latitude, longitude, website, twitter_handle, phone,
  short_description,
  veteran_owned, woman_owned, family_owned, immigrant_owned,
  made_in_usa, ships_nationwide, brick_and_mortar, featured, verified, source, source_row_id
) VALUES (
  'parros-gun-shop', 'Parro''s Gun Shop & Indoor Range',
  (SELECT id FROM categories WHERE slug = 'firearms-outdoors'),
  'Waterbury', 'VT', '601 US Route 2', '05676',
  NULL, NULL,
  'https://www.parros.com', 'ParrosGunShop', '(802) 244-8401',
  'Vermont''s only indoor firearm range with 10 lanes, 20,000 sq ft retail, firearms training, and sales.',
  0, 0, 0, 0, 0, 0, 1, 0, 1, 'manual', 'csv-c-7'
);

-- 115. BowTied Woodwork
INSERT OR IGNORE INTO businesses (
  slug, name, category_id, city, state, street_address, postal_code,
  latitude, longitude, website, twitter_handle, phone,
  short_description,
  veteran_owned, woman_owned, family_owned, immigrant_owned,
  made_in_usa, ships_nationwide, brick_and_mortar, featured, verified, source, source_row_id
) VALUES (
  'bowtied-woodwork', 'BowTied Woodwork',
  (SELECT id FROM categories WHERE slug = 'handmade-artisan'),
  'Unknown', 'USA', NULL, NULL,
  NULL, NULL,
  'https://bowtiewoodworks.com', 'BowTiedWoodwork', NULL,
  'Handcrafted wooden kitchenware, custom furniture, and CNC woodworking services.',
  0, 0, 0, 0, 1, 1, 0, 0, 1, 'manual', 'csv-c-8'
);

-- 116. Felgenland Saga
INSERT OR IGNORE INTO businesses (
  slug, name, category_id, city, state, street_address, postal_code,
  latitude, longitude, website, twitter_handle, phone,
  short_description,
  veteran_owned, woman_owned, family_owned, immigrant_owned,
  made_in_usa, ships_nationwide, brick_and_mortar, featured, verified, source, source_row_id
) VALUES (
  'felgenland-saga', 'Felgenland Saga',
  (SELECT id FROM categories WHERE slug = 'books-media'),
  'Unknown', 'USA', NULL, NULL,
  NULL, NULL,
  'https://www.amazon.com/dp/B0D32WVTJF', 'ericcholtgrefe', NULL,
  'Military sci-fi trilogy by Eric C. Holtgrefe, a former NASA systems engineer. Three books in the series.',
  0, 0, 0, 0, 1, 1, 0, 0, 1, 'manual', 'csv-c-9'
);

-- 117. Benford Brewing
INSERT OR IGNORE INTO businesses (
  slug, name, category_id, city, state, street_address, postal_code,
  latitude, longitude, website, twitter_handle, phone,
  short_description,
  veteran_owned, woman_owned, family_owned, immigrant_owned,
  made_in_usa, ships_nationwide, brick_and_mortar, featured, verified, source, source_row_id
) VALUES (
  'benford-brewing', 'Benford Brewing',
  (SELECT id FROM categories WHERE slug = 'brewing-spirits'),
  'Lancaster', 'SC', '2271 Boxcar Rd', '29720',
  NULL, NULL,
  'https://benfordbrewing.com', 'benfordbrew', '(803) 416-8422',
  'South Carolina''s only agricultural brewery, located on a working farm with beef, eggs, and sawmill services.',
  0, 0, 1, 0, 1, 0, 1, 0, 1, 'manual', 'csv-c-10'
);

-- 118. Flying Monk Leather
INSERT OR IGNORE INTO businesses (
  slug, name, category_id, city, state, street_address, postal_code,
  latitude, longitude, website, twitter_handle, phone,
  short_description,
  veteran_owned, woman_owned, family_owned, immigrant_owned,
  made_in_usa, ships_nationwide, brick_and_mortar, featured, verified, source, source_row_id
) VALUES (
  'flying-monk-leather', 'Flying Monk Leather',
  (SELECT id FROM categories WHERE slug = 'handmade-artisan'),
  'Unknown', 'USA', NULL, NULL,
  NULL, NULL,
  'https://www.flyingmonkleather.com', 'flyingmonk_lg', NULL,
  'Bespoke handmade leather goods — journals, wallets, belts, and watch straps using premium vegetable-tanned leather.',
  0, 0, 0, 0, 1, 1, 0, 0, 1, 'manual', 'csv-c-11'
);

-- 119. Louisiana Crawfish Company
INSERT OR IGNORE INTO businesses (
  slug, name, category_id, city, state, street_address, postal_code,
  latitude, longitude, website, twitter_handle, phone,
  short_description,
  veteran_owned, woman_owned, family_owned, immigrant_owned,
  made_in_usa, ships_nationwide, brick_and_mortar, featured, verified, source, source_row_id
) VALUES (
  'louisiana-crawfish-company', 'Louisiana Crawfish Company',
  (SELECT id FROM categories WHERE slug = 'restaurants-food'),
  'Natchitoches', 'LA', '140 Russel Cemetery Rd', '71457',
  NULL, NULL,
  'https://www.lacrawfish.com', 'lacrawfishco', '(318) 379-0539',
  'Family-owned #1 shipper of live crawfish since 1985. Ships 2M+ lbs/year with guaranteed live delivery.',
  0, 0, 1, 0, 1, 1, 1, 0, 1, 'manual', 'csv-c-12'
);

-- 120. She Must Be Loved
INSERT OR IGNORE INTO businesses (
  slug, name, category_id, city, state, street_address, postal_code,
  latitude, longitude, website, twitter_handle, phone,
  short_description,
  veteran_owned, woman_owned, family_owned, immigrant_owned,
  made_in_usa, ships_nationwide, brick_and_mortar, featured, verified, source, source_row_id
) VALUES (
  'she-must-be-loved', 'She Must Be Loved',
  (SELECT id FROM categories WHERE slug = 'faith-family'),
  'Pickerington', 'OH', NULL, NULL,
  NULL, NULL,
  'https://shemustbeloved.com', 'doulamandee', NULL,
  'Faith-first childbirth courses and doula services by Mandee Rohn. Serving Central Ohio mothers.',
  0, 1, 0, 0, 0, 1, 0, 0, 1, 'manual', 'csv-c-13'
);

-- 121. Vintage Mama's Cottage
INSERT OR IGNORE INTO businesses (
  slug, name, category_id, city, state, street_address, postal_code,
  latitude, longitude, website, twitter_handle, phone,
  short_description,
  veteran_owned, woman_owned, family_owned, immigrant_owned,
  made_in_usa, ships_nationwide, brick_and_mortar, featured, verified, source, source_row_id
) VALUES (
  'vintage-mamas-cottage', 'Vintage Mama''s Cottage',
  (SELECT id FROM categories WHERE slug = 'apparel-accessories'),
  'Unknown', 'USA', NULL, NULL,
  NULL, NULL,
  'https://www.vintagemamascottage.net', 'newton_nin33204', NULL,
  'Vintage and almost-vintage apparel and home goods curated by Nina.',
  0, 1, 0, 0, 0, 1, 0, 0, 1, 'manual', 'csv-c-14'
);

-- ============================================================
-- BADGES: Group A
-- ============================================================

INSERT OR IGNORE INTO business_badges (business_id, badge_id)
SELECT b.id, ba.id FROM businesses b, badges ba
WHERE b.source_row_id LIKE 'csv-a-%' AND ba.slug = 'original-thread';

INSERT OR IGNORE INTO business_badges (business_id, badge_id)
SELECT b.id, ba.id FROM businesses b, badges ba
WHERE b.slug IN ('tamburn-bindery') AND ba.slug = 'veteran-owned';

INSERT OR IGNORE INTO business_badges (business_id, badge_id)
SELECT b.id, ba.id FROM businesses b, badges ba
WHERE b.slug IN ('humming-meadow-honey','kiel-james-patrick','the-buffalo-wool-co',
  'fountains-coffee','the-woolshire','ambrosian-candle-co','tamburn-bindery',
  'middleborne-arms','black-wolf-homestead','baritus-catholic-illustration')
  AND ba.slug = 'family-business';

INSERT OR IGNORE INTO business_badges (business_id, badge_id)
SELECT b.id, ba.id FROM businesses b, badges ba
WHERE b.slug IN ('humming-meadow-honey','kiel-james-patrick','the-buffalo-wool-co',
  'fountains-coffee','the-woolshire','fox-and-root','ambrosian-candle-co',
  'cotedge-socks','tamburn-bindery','galloway-woodworks','middleborne-arms',
  'lawrence-of-appalachia','black-wolf-homestead','baritus-catholic-illustration',
  'bake-across-europe')
  AND ba.slug = 'ships-nationwide';

INSERT OR IGNORE INTO business_badges (business_id, badge_id)
SELECT b.id, ba.id FROM businesses b, badges ba
WHERE b.slug IN ('humming-meadow-honey','kiel-james-patrick','the-buffalo-wool-co',
  'the-woolshire','fox-and-root','ambrosian-candle-co','cotedge-socks',
  'tamburn-bindery','galloway-woodworks','middleborne-arms','lawrence-of-appalachia',
  'black-wolf-homestead','baritus-catholic-illustration')
  AND ba.slug = 'made-in-usa';

-- ============================================================
-- BADGES: Group B
-- ============================================================

INSERT OR IGNORE INTO business_badges (business_id, badge_id)
SELECT b.id, ba.id FROM businesses b, badges ba
WHERE b.source_row_id LIKE 'csv-b-%' AND ba.slug = 'original-thread';

INSERT OR IGNORE INTO business_badges (business_id, badge_id)
SELECT b.id, ba.id FROM businesses b, badges ba
WHERE b.slug IN ('wasson-watch-co') AND ba.slug = 'veteran-owned';

INSERT OR IGNORE INTO business_badges (business_id, badge_id)
SELECT b.id, ba.id FROM businesses b, badges ba
WHERE b.slug IN ('cottage-pastures','north-ranger','silver-gold-honey-company',
  'armadillo-acres-farm','tlc-ranch')
  AND ba.slug = 'family-business';

INSERT OR IGNORE INTO business_badges (business_id, badge_id)
SELECT b.id, ba.id FROM businesses b, badges ba
WHERE b.slug IN ('seraphim-print-studio','gubba-homestead','cottage-pastures',
  'wasson-watch-co','north-ranger','peaces-of-indigo','nicholas-hayford-jewelry',
  'eli-sherbondy-machining','primal-aromas','evers-forge-works','merican-af',
  'silver-gold-honey-company','tlc-ranch')
  AND ba.slug = 'ships-nationwide';

INSERT OR IGNORE INTO business_badges (business_id, badge_id)
SELECT b.id, ba.id FROM businesses b, badges ba
WHERE b.slug IN ('orthodox-mason','seraphim-print-studio','gubba-homestead',
  'wading-smith-woodworks','cottage-pastures','north-ranger','peaces-of-indigo',
  'nicholas-hayford-jewelry','eli-sherbondy-machining','primal-aromas',
  'evers-forge-works','merican-af','silver-gold-honey-company',
  'armadillo-acres-farm','tlc-ranch')
  AND ba.slug = 'made-in-usa';

-- ============================================================
-- BADGES: Group C
-- ============================================================

INSERT OR IGNORE INTO business_badges (business_id, badge_id)
SELECT b.id, ba.id FROM businesses b, badges ba
WHERE b.source_row_id LIKE 'csv-c-%' AND ba.slug = 'original-thread';

INSERT OR IGNORE INTO business_badges (business_id, badge_id)
SELECT b.id, ba.id FROM businesses b, badges ba
WHERE b.slug IN ('taylor-shellfish-farms','benford-brewing','louisiana-crawfish-company')
  AND ba.slug = 'family-business';

INSERT OR IGNORE INTO business_badges (business_id, badge_id)
SELECT b.id, ba.id FROM businesses b, badges ba
WHERE b.slug IN ('ave-maria-every-day','puresteel-co','american-lictor','chooch-skookum',
  'bowtied-woodwork','felgenland-saga','flying-monk-leather',
  'louisiana-crawfish-company','she-must-be-loved','vintage-mamas-cottage')
  AND ba.slug = 'ships-nationwide';

INSERT OR IGNORE INTO business_badges (business_id, badge_id)
SELECT b.id, ba.id FROM businesses b, badges ba
WHERE b.slug IN ('ave-maria-every-day','puresteel-co','american-lictor',
  'taylor-shellfish-farms','chooch-skookum','appalachian-wood-homestead',
  'bowtied-woodwork','felgenland-saga','benford-brewing','flying-monk-leather',
  'louisiana-crawfish-company')
  AND ba.slug = 'made-in-usa';
