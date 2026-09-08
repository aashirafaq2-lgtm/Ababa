import { v4 as uuidv4 } from 'uuid';
import { pgPool } from '../config/database';

export async function findUserByIdentity(identity: string) {
  const res = await pgPool.query('SELECT * FROM users WHERE LOWER(identity) = LOWER($1) LIMIT 1', [identity]);
  return res.rows[0] || null;
}

export async function findUserById(id: string) {
  const res = await pgPool.query('SELECT * FROM users WHERE id = $1 LIMIT 1', [id]);
  return res.rows[0] || null;
}

export async function createUser(params: { identity: string; password_hash: string; role?: string; }) {
  const id = uuidv4();
  const res = await pgPool.query(
    `INSERT INTO users (id, identity, password_hash, role, status) VALUES ($1, $2, $3, $4, 'ACTIVE') RETURNING *`,
    [id, params.identity.toLowerCase(), params.password_hash, params.role || 'CUSTOMER']
  );
  return res.rows[0];
}

export async function updateUserStatus(id: string, status: 'ACTIVE' | 'SUSPENDED') {
  const res = await pgPool.query(`UPDATE users SET status = $1, updated_at = NOW() WHERE id = $2 RETURNING *`, [status, id]);
  return res.rows[0] || null;
}

export async function updateUserPassword(id: string, password_hash: string) {
  await pgPool.query(`UPDATE users SET password_hash = $1, updated_at = NOW() WHERE id = $2`, [password_hash, id]);
}

export async function getAllCustomers(search?: string) {
  let query = `SELECT u.id, u.identity, u.role, u.status, u.created_at, p.full_name, p.phone, p.email, p.box_code, p.avatar_url FROM users u LEFT JOIN user_profiles p ON p.user_id = u.id WHERE u.role = 'CUSTOMER'`;
  const params: any[] = [];
  if (search) { params.push(`%${search.toLowerCase()}%`); query += ` AND (LOWER(p.full_name) LIKE $1 OR LOWER(u.identity) LIKE $1 OR LOWER(p.box_code) LIKE $1)`; }
  query += ' ORDER BY u.created_at DESC';
  const res = await pgPool.query(query, params);
  return res.rows;
}

export async function deleteUserAccount(user_id: string) {
  await pgPool.query('DELETE FROM users WHERE id = $1', [user_id]);
}

export async function findProfileByUserId(user_id: string) {
  const res = await pgPool.query('SELECT * FROM user_profiles WHERE user_id = $1 LIMIT 1', [user_id]);
  return res.rows[0] || null;
}

export async function createProfile(params: { user_id: string; full_name: string; phone: string; email: string; country_code: string; box_code: string; }) {
  const res = await pgPool.query(
    `INSERT INTO user_profiles (user_id, full_name, phone, email, country_code, box_code) VALUES ($1,$2,$3,$4,$5,$6) RETURNING *`,
    [params.user_id, params.full_name, params.phone, params.email, params.country_code, params.box_code]
  );
  return res.rows[0];
}

export async function updateProfile(user_id: string, params: { full_name?: string; phone?: string; email?: string; country_code?: string; avatar_url?: string; }) {
  const fields: string[] = []; const values: any[] = []; let idx = 1;
  if (params.full_name !== undefined) { fields.push(`full_name = $${idx++}`); values.push(params.full_name); }
  if (params.phone !== undefined) { fields.push(`phone = $${idx++}`); values.push(params.phone); }
  if (params.email !== undefined) { fields.push(`email = $${idx++}`); values.push(params.email); }
  if (params.country_code !== undefined) { fields.push(`country_code = $${idx++}`); values.push(params.country_code); }
  if (params.avatar_url !== undefined) { fields.push(`avatar_url = $${idx++}`); values.push(params.avatar_url); }
  if (fields.length === 0) return findProfileByUserId(user_id);
  fields.push('updated_at = NOW()'); values.push(user_id);
  const res = await pgPool.query(`UPDATE user_profiles SET ${fields.join(', ')} WHERE user_id = $${idx} RETURNING *`, values);
  return res.rows[0] || null;
}

export async function getActiveWarehouse() {
  const res = await pgPool.query('SELECT * FROM warehouses WHERE is_active = TRUE ORDER BY created_at LIMIT 1');
  return res.rows[0] || null;
}

export async function getPackagesByCustomer(customer_id: string, status?: string) {
  let query = 'SELECT * FROM packages WHERE customer_id = $1'; const params: any[] = [customer_id];
  if (status) { query += ' AND LOWER(status) = LOWER($2)'; params.push(status); }
  query += ' ORDER BY created_at DESC';
  const res = await pgPool.query(query, params); return res.rows;
}

export async function getPackageById(id: string) {
  const res = await pgPool.query('SELECT * FROM packages WHERE id = $1 LIMIT 1', [id]);
  return res.rows[0] || null;
}

export async function getAllPackages(status?: string, search?: string) {
  let query = `SELECT pkg.*, p.full_name AS customer_name, p.box_code AS customer_box_code FROM packages pkg LEFT JOIN user_profiles p ON p.user_id = pkg.customer_id WHERE 1=1`;
  const params: any[] = []; let idx = 1;
  if (status && status !== 'all') { query += ` AND LOWER(pkg.status) = LOWER($${idx++})`; params.push(status); }
  if (search) { const s = `%${search.toLowerCase()}%`; query += ` AND (LOWER(pkg.box_number) LIKE $${idx} OR LOWER(pkg.tracking_number) LIKE $${idx} OR LOWER(p.full_name) LIKE $${idx} OR LOWER(p.box_code) LIKE $${idx})`; params.push(s); idx++; }
  query += ' ORDER BY pkg.created_at DESC';
  const res = await pgPool.query(query, params); return res.rows;
}

export async function createPackage(params: { customer_id: string; warehouse_id: string; box_number: string; tracking_number: string; dimensions: string; weight_kg: number; volume_cbm: number; notes?: string; photos?: string[]; }) {
  const id = uuidv4();
  const res = await pgPool.query(
    `INSERT INTO packages (id, customer_id, warehouse_id, box_number, tracking_number, dimensions, weight_kg, volume_cbm, status, photos, notes) VALUES ($1,$2,$3,$4,$5,$6,$7,$8,'IN_WAREHOUSE',$9,$10) RETURNING *`,
    [id, params.customer_id, params.warehouse_id, params.box_number, params.tracking_number, params.dimensions, params.weight_kg, params.volume_cbm, JSON.stringify(params.photos || []), params.notes || '']
  );
  return res.rows[0];
}

export async function updatePackage(id: string, params: { status?: string; weight_kg?: number; volume_cbm?: number; notes?: string; }) {
  const fields: string[] = []; const values: any[] = []; let idx = 1;
  if (params.status !== undefined) { fields.push(`status = $${idx++}`); values.push(params.status); }
  if (params.weight_kg !== undefined) { fields.push(`weight_kg = $${idx++}`); values.push(params.weight_kg); }
  if (params.volume_cbm !== undefined) { fields.push(`volume_cbm = $${idx++}`); values.push(params.volume_cbm); }
  if (params.notes !== undefined) { fields.push(`notes = $${idx++}`); values.push(params.notes); }
  if (fields.length === 0) return getPackageById(id);
  fields.push('updated_at = NOW()'); values.push(id);
  const res = await pgPool.query(`UPDATE packages SET ${fields.join(', ')} WHERE id = $${idx} RETURNING *`, values);
  return res.rows[0] || null;
}

export async function updatePackagesBulkStatus(ids: string[], status: string) {
  if (ids.length === 0) return;
  const placeholders = ids.map((_, i) => `$${i + 2}`).join(', ');
  await pgPool.query(`UPDATE packages SET status = $1, updated_at = NOW() WHERE id IN (${placeholders})`, [status, ...ids]);
}

export async function getActiveShippingMethods() {
  const res = await pgPool.query('SELECT * FROM shipping_methods WHERE is_active = TRUE ORDER BY type');
  return res.rows;
}

export async function getShippingMethodById(id: string) {
  const res = await pgPool.query('SELECT * FROM shipping_methods WHERE id = $1 LIMIT 1', [id]);
  return res.rows[0] || null;
}

export async function getAllShippingMethods() {
  const res = await pgPool.query('SELECT * FROM shipping_methods ORDER BY type');
  return res.rows;
}

export async function updateShippingMethod(id: string, params: { rate_per_kg?: number; rate_per_cbm?: number; base_fee?: number; minimum_fee?: number; estimated_days?: string; is_active?: boolean; }) {
  const fields: string[] = []; const values: any[] = []; let idx = 1;
  if (params.rate_per_kg !== undefined) { fields.push(`rate_per_kg = $${idx++}`); values.push(params.rate_per_kg); }
  if (params.rate_per_cbm !== undefined) { fields.push(`rate_per_cbm = $${idx++}`); values.push(params.rate_per_cbm); }
  if (params.base_fee !== undefined) { fields.push(`base_fee = $${idx++}`); values.push(params.base_fee); }
  if (params.minimum_fee !== undefined) { fields.push(`minimum_fee = $${idx++}`); values.push(params.minimum_fee); }
  if (params.estimated_days !== undefined) { fields.push(`estimated_days = $${idx++}`); values.push(params.estimated_days); }
  if (params.is_active !== undefined) { fields.push(`is_active = $${idx++}`); values.push(params.is_active); }
  if (fields.length === 0) return getShippingMethodById(id);
  fields.push('updated_at = NOW()'); values.push(id);
  const res = await pgPool.query(`UPDATE shipping_methods SET ${fields.join(', ')} WHERE id = $${idx} RETURNING *`, values);
  return res.rows[0] || null;
}

export async function createConsolidationOrder(params: { customer_id: string; shipping_method_id: string; destination_country: string; destination_city: string; delivery_address: string; delivery_type: string; total_weight_kg: number; total_cbm: number; shipping_cost_usd: number; package_ids: string[]; notes?: string; }) {
  const id = uuidv4(); const orderNumber = 'CONS-' + Math.floor(100000 + Math.random() * 900000);
  const res = await pgPool.query(
    `INSERT INTO consolidation_orders (id, order_number, customer_id, shipping_method_id, destination_country, destination_city, delivery_address, delivery_type, total_weight_kg, total_cbm, shipping_cost_usd, status, package_ids, notes) VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,'REQUESTED',$12,$13) RETURNING *`,
    [id, orderNumber, params.customer_id, params.shipping_method_id, params.destination_country, params.destination_city, params.delivery_address, params.delivery_type, params.total_weight_kg, params.total_cbm, params.shipping_cost_usd, JSON.stringify(params.package_ids), params.notes || '']
  );
  return res.rows[0];
}

export async function getFutianOrdersByCustomer(customer_id: string, status?: string, search?: string) {
  let query = 'SELECT * FROM futian_orders WHERE customer_id = $1'; const params: any[] = [customer_id]; let idx = 2;
  if (status && status !== 'all') { query += ` AND status = $${idx++}`; params.push(status.toUpperCase().replace(/-/g, '_')); }
  if (search) { const s = `%${search.toLowerCase()}%`; query += ` AND (LOWER(order_id) LIKE $${idx} OR LOWER(product_name_en) LIKE $${idx} OR LOWER(product_name_ar) LIKE $${idx})`; params.push(s); idx++; }
  query += ' ORDER BY created_at DESC';
  const res = await pgPool.query(query, params); return res.rows;
}

export async function getFutianOrderById(id: string, customer_id?: string) {
  let query = 'SELECT * FROM futian_orders WHERE (id = $1 OR order_id = $1)'; const params: any[] = [id];
  if (customer_id) { query += ' AND customer_id = $2'; params.push(customer_id); }
  query += ' LIMIT 1';
  const res = await pgPool.query(query, params); return res.rows[0] || null;
}

export async function getFutianMetrics(customer_id: string) {
  const res = await pgPool.query(`SELECT status, COUNT(*)::int AS count FROM futian_orders WHERE customer_id = $1 GROUP BY status`, [customer_id]);
  const counts: Record<string, number> = {}; let total = 0;
  for (const row of res.rows) { counts[row.status] = row.count; total += row.count; }
  return { all: total, underReview: counts['UNDER_REVIEW'] || 0, pricePending: counts['PRICE_PENDING'] || 0, approvalPending: counts['APPROVAL_PENDING'] || 0, purchased: counts['PURCHASED'] || 0, shipped: counts['SHIPPED'] || 0, arrived: counts['ARRIVED'] || 0, cancelled: counts['CANCELLED'] || 0 };
}

export async function getAllFutianOrders(status?: string, search?: string) {
  let query = `SELECT fo.*, p.full_name AS customer_name, p.box_code AS customer_box_code FROM futian_orders fo LEFT JOIN user_profiles p ON p.user_id = fo.customer_id WHERE 1=1`;
  const params: any[] = []; let idx = 1;
  if (status && status !== 'all') { query += ` AND fo.status = $${idx++}`; params.push(status.toUpperCase().replace(/-/g, '_')); }
  if (search) { const s = `%${search.toLowerCase()}%`; query += ` AND (LOWER(fo.order_id) LIKE $${idx} OR LOWER(fo.product_name_en) LIKE $${idx} OR LOWER(p.full_name) LIKE $${idx} OR LOWER(p.box_code) LIKE $${idx})`; params.push(s); idx++; }
  query += ' ORDER BY fo.created_at DESC';
  const res = await pgPool.query(query, params); return res.rows;
}

export async function createFutianOrder(params: { customer_id: string; product_name_en: string; product_name_ar: string; product_url?: string; site_name_en: string; site_name_ar: string; site_type: string; quantity: number; destination_country: string; declared_value_usd: number; notes?: string; }) {
  const id = uuidv4(); const orderNum = '#AB-' + Math.floor(2505000 + Math.random() * 999);
  const res = await pgPool.query(
    `INSERT INTO futian_orders (id, order_id, customer_id, product_name_en, product_name_ar, product_url, site_name_en, site_name_ar, site_type, quantity, destination_country, declared_value_usd, unit_price_usd, total_price_usd, status, visual_type, notes) VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,0,0,'UNDER_REVIEW','general',$13) RETURNING *`,
    [id, orderNum, params.customer_id, params.product_name_en, params.product_name_ar, params.product_url || '', params.site_name_en, params.site_name_ar, params.site_type, params.quantity, params.destination_country, params.declared_value_usd, params.notes || '']
  );
  return res.rows[0];
}

export async function updateFutianOrderStatus(id: string, status: string) {
  const res = await pgPool.query(`UPDATE futian_orders SET status = $1, updated_at = NOW() WHERE (id = $2 OR order_id = $2) RETURNING *`, [status, id]);
  return res.rows[0] || null;
}

export async function updateFutianOrderPricing(id: string, unit_price_usd: number, quantity: number) {
  const total_price_usd = unit_price_usd * quantity;
  const res = await pgPool.query(`UPDATE futian_orders SET unit_price_usd = $1, total_price_usd = $2, status = 'APPROVAL_PENDING', updated_at = NOW() WHERE (id = $3 OR order_id = $3) RETURNING *`, [unit_price_usd, total_price_usd, id]);
  return res.rows[0] || null;
}

export async function getOrderStatusHistory(order_id: string) {
  const res = await pgPool.query(`SELECT * FROM order_status_history WHERE order_id = $1 ORDER BY created_at ASC`, [order_id]);
  return res.rows;
}

export async function addOrderStatusHistory(params: { order_id: string; from_status?: string; to_status: string; changed_by_user_id?: string; changed_by_name: string; notes?: string; }) {
  const id = uuidv4();
  const res = await pgPool.query(`INSERT INTO order_status_history (id, order_id, from_status, to_status, changed_by_user_id, changed_by_name, notes) VALUES ($1,$2,$3,$4,$5,$6,$7) RETURNING *`, [id, params.order_id, params.from_status || null, params.to_status, params.changed_by_user_id || null, params.changed_by_name, params.notes || null]);
  return res.rows[0];
}

export async function getShipmentByTrackingNumber(tracking_number: string) {
  const res = await pgPool.query('SELECT * FROM shipments WHERE LOWER(tracking_number) = LOWER($1) LIMIT 1', [tracking_number]);
  return res.rows[0] || null;
}

export async function getFirstShipment() {
  const res = await pgPool.query('SELECT * FROM shipments ORDER BY created_at ASC LIMIT 1');
  return res.rows[0] || null;
}

export async function getTrackingMilestones(tracking_number: string) {
  const res = await pgPool.query('SELECT * FROM tracking_milestones WHERE tracking_number = $1 ORDER BY step_number ASC', [tracking_number]);
  return res.rows;
}

export async function getNotificationsByCustomer(customer_id: string) {
  const res = await pgPool.query(`SELECT * FROM notifications WHERE customer_id = $1 ORDER BY created_at DESC`, [customer_id]);
  return res.rows;
}

export async function getUnreadCount(customer_id: string) {
  const res = await pgPool.query(`SELECT COUNT(*)::int AS count FROM notifications WHERE customer_id = $1 AND is_read = FALSE`, [customer_id]);
  return res.rows[0]?.count || 0;
}

export async function markNotificationRead(id: string, customer_id: string) {
  const res = await pgPool.query(`UPDATE notifications SET is_read = TRUE WHERE id = $1 AND customer_id = $2 RETURNING *`, [id, customer_id]);
  return res.rows[0] || null;
}

export async function markAllNotificationsRead(customer_id: string) {
  const res = await pgPool.query(`UPDATE notifications SET is_read = TRUE WHERE customer_id = $1 AND is_read = FALSE`, [customer_id]);
  return res.rowCount || 0;
}

export async function createNotification(params: { customer_id: string; title: string; message: string; type: string; related_id?: string; }) {
  const id = uuidv4();
  await pgPool.query(`INSERT INTO notifications (id, customer_id, title, message, type, is_read, related_id) VALUES ($1,$2,$3,$4,$5,FALSE,$6)`, [id, params.customer_id, params.title, params.message, params.type, params.related_id || null]);
}

export async function insertAdminAuditLog(params: { admin_user_id: string; admin_name: string; action: string; entity_type: string; entity_id: string; old_values: any; new_values: any; ip_address?: string; }) {
  const id = uuidv4();
  const res = await pgPool.query(`INSERT INTO admin_audit_logs (id, admin_user_id, admin_name, action, entity_type, entity_id, old_values, new_values, ip_address) VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9) RETURNING *`, [id, params.admin_user_id, params.admin_name, params.action, params.entity_type, params.entity_id, JSON.stringify(params.old_values), JSON.stringify(params.new_values), params.ip_address || null]);
  return res.rows[0];
}

export async function getAdminAuditLogs(limit = 100, search?: string) {
  let query = `SELECT * FROM admin_audit_logs WHERE 1=1`; const params: any[] = [];
  if (search) { const s = `%${search.toLowerCase()}%`; params.push(s); query += ` AND (LOWER(action) LIKE $1 OR LOWER(admin_name) LIKE $1 OR LOWER(entity_type) LIKE $1 OR LOWER(entity_id) LIKE $1)`; }
  query += ` ORDER BY created_at DESC LIMIT $${params.length + 1}`; params.push(limit);
  const res = await pgPool.query(query, params); return res.rows;
}

export async function getAdminOverviewMetrics() {
  const [cr, pr, cor, fr, sr, ar, pfr] = await Promise.all([
    pgPool.query(`SELECT COUNT(*)::int AS total, COUNT(*) FILTER (WHERE status='ACTIVE')::int AS active FROM users WHERE role='CUSTOMER'`),
    pgPool.query(`SELECT COUNT(*)::int AS total, COUNT(*) FILTER (WHERE status IN ('IN_WAREHOUSE','READY_FOR_CONSOLIDATION'))::int AS in_warehouse, COUNT(*) FILTER (WHERE status='READY_FOR_CONSOLIDATION')::int AS ready_for_consolidation FROM packages`),
    pgPool.query(`SELECT COUNT(*) FILTER (WHERE status='REQUESTED')::int AS pending FROM consolidation_orders`),
    pgPool.query(`SELECT status, COUNT(*)::int AS count FROM futian_orders GROUP BY status`),
    pgPool.query(`SELECT COUNT(*)::int AS total FROM shipments`),
    pgPool.query(`SELECT COUNT(*)::int AS total FROM admin_audit_logs`),
    pgPool.query(`SELECT COUNT(*)::int AS total FROM user_profiles`),
  ]);
  const fc: Record<string, number> = {}; let ft = 0;
  for (const row of fr.rows) { fc[row.status] = row.count; ft += row.count; }
  return {
    totalCustomers: cr.rows[0].total, activeCustomers: cr.rows[0].active, chinaBoxAccounts: pfr.rows[0].total,
    packagesInWarehouse: pr.rows[0].in_warehouse, readyForConsolidation: pr.rows[0].ready_for_consolidation,
    consolidationRequests: cor.rows[0].pending, activeShipments: sr.rows[0].total,
    futian: { total: ft, underReview: fc['UNDER_REVIEW'] || 0, pricePending: fc['PRICE_PENDING'] || 0, approvalPending: fc['APPROVAL_PENDING'] || 0, purchased: fc['PURCHASED'] || 0, shipped: fc['SHIPPED'] || 0, arrived: fc['ARRIVED'] || 0, cancelled: fc['CANCELLED'] || 0 },
    auditLogsCount: ar.rows[0].total,
  };
}
