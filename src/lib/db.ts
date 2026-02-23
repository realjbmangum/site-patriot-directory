export interface Business {
  id: number;
  slug: string;
  name: string;
  category_id: number;
  city: string;
  state: string;
  street_address: string | null;
  postal_code: string | null;
  latitude: number | null;
  longitude: number | null;
  website: string | null;
  twitter_handle: string | null;
  phone: string | null;
  email: string | null;
  short_description: string | null;
  story: string | null;
  photo_url: string | null;
  logo_url: string | null;
  veteran_owned: number;
  woman_owned: number;
  family_owned: number;
  immigrant_owned: number;
  made_in_usa: number;
  ships_nationwide: number;
  brick_and_mortar: number;
  founded_year: number | null;
  employee_count: string | null;
  verified: number;
  featured: number;
  source: string;
  source_row_id: string | null;
  created_at: string;
  updated_at: string;
  // Joined fields
  category_name?: string;
  category_slug?: string;
  category_icon?: string;
}

export interface Category {
  id: number;
  slug: string;
  name: string;
  description: string | null;
  icon: string | null;
  sort_order: number;
  created_at: string;
  count?: number;
}

export interface Badge {
  id: number;
  slug: string;
  name: string;
  description: string | null;
  icon: string | null;
  color: string | null;
  sort_order: number;
}

export interface StateInfo {
  state: string;
  count: number;
}

export interface CityInfo {
  city: string;
  state: string;
  count: number;
}

export interface MapBusiness {
  id: number;
  name: string;
  slug: string;
  latitude: number;
  longitude: number;
  category_id: number;
  category_name: string;
  category_slug: string;
  city: string;
  state: string;
  short_description: string | null;
}

interface GetBusinessesOptions {
  category?: string;
  state?: string;
  city?: string;
  limit?: number;
  featured?: boolean;
}

export async function getBusinesses(
  db: D1Database,
  options: GetBusinessesOptions = {}
): Promise<Business[]> {
  const conditions: string[] = [];
  const params: unknown[] = [];

  if (options.category) {
    conditions.push('c.slug = ?');
    params.push(options.category);
  }

  if (options.state) {
    conditions.push('b.state = ?');
    params.push(options.state);
  }

  if (options.city) {
    conditions.push('LOWER(b.city) = LOWER(?)');
    params.push(options.city);
  }

  if (options.featured) {
    conditions.push('b.featured = 1');
  }

  const where = conditions.length > 0 ? `WHERE ${conditions.join(' AND ')}` : '';
  const limit = options.limit ? `LIMIT ${options.limit}` : '';

  const sql = `
    SELECT b.*, c.name AS category_name, c.slug AS category_slug, c.icon AS category_icon
    FROM businesses b
    JOIN categories c ON b.category_id = c.id
    ${where}
    ORDER BY b.featured DESC, b.name ASC
    ${limit}
  `;

  const result = await db.prepare(sql).bind(...params).all<Business>();
  return result.results;
}

export async function getBusinessBySlug(
  db: D1Database,
  slug: string
): Promise<Business | null> {
  const sql = `
    SELECT b.*, c.name AS category_name, c.slug AS category_slug, c.icon AS category_icon
    FROM businesses b
    JOIN categories c ON b.category_id = c.id
    WHERE b.slug = ?
  `;

  const result = await db.prepare(sql).bind(slug).first<Business>();
  return result || null;
}

export async function getCategories(db: D1Database): Promise<Category[]> {
  const sql = `
    SELECT c.*, COUNT(b.id) AS count
    FROM categories c
    LEFT JOIN businesses b ON c.id = b.category_id
    GROUP BY c.id
    ORDER BY c.sort_order ASC
  `;

  const result = await db.prepare(sql).all<Category>();
  return result.results;
}

export async function getCategoryBySlug(
  db: D1Database,
  slug: string
): Promise<Category | null> {
  const sql = `
    SELECT c.*, COUNT(b.id) AS count
    FROM categories c
    LEFT JOIN businesses b ON c.id = b.category_id
    WHERE c.slug = ?
    GROUP BY c.id
  `;

  const result = await db.prepare(sql).bind(slug).first<Category>();
  return result || null;
}

export async function getStates(db: D1Database): Promise<StateInfo[]> {
  const sql = `
    SELECT state, COUNT(*) AS count
    FROM businesses
    GROUP BY state
    ORDER BY state ASC
  `;

  const result = await db.prepare(sql).all<StateInfo>();
  return result.results;
}

export async function getCities(
  db: D1Database,
  state: string
): Promise<CityInfo[]> {
  const sql = `
    SELECT city, state, COUNT(*) AS count
    FROM businesses
    WHERE state = ?
    GROUP BY city
    ORDER BY city ASC
  `;

  const result = await db.prepare(sql).bind(state).all<CityInfo>();
  return result.results;
}

export async function getBusinessBadges(
  db: D1Database,
  businessId: number
): Promise<Badge[]> {
  const sql = `
    SELECT bg.*
    FROM badges bg
    JOIN business_badges bb ON bg.id = bb.badge_id
    WHERE bb.business_id = ?
    ORDER BY bg.sort_order ASC
  `;

  const result = await db.prepare(sql).bind(businessId).all<Badge>();
  return result.results;
}

export async function getAllBusinessesForMap(
  db: D1Database
): Promise<MapBusiness[]> {
  const sql = `
    SELECT b.id, b.name, b.slug, b.latitude, b.longitude,
           b.category_id, c.name AS category_name, c.slug AS category_slug,
           b.city, b.state, b.short_description
    FROM businesses b
    JOIN categories c ON b.category_id = c.id
    WHERE b.latitude IS NOT NULL AND b.longitude IS NOT NULL
    ORDER BY b.name ASC
  `;

  const result = await db.prepare(sql).all<MapBusiness>();
  return result.results;
}
