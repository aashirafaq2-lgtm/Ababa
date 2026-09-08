import { Pool } from 'pg';
import bcrypt from 'bcryptjs';
import fs from 'fs';
import path from 'path';
import dotenv from 'dotenv';

dotenv.config();

const connectionString = process.env.DATABASE_URL || 'postgres://admin:password123@localhost:5432/ahmedbaba_db';

export const pgPool = new Pool({
  connectionString,
  max: 10,
  idleTimeoutMillis: 30000,
  connectionTimeoutMillis: 5000,
});

// ─── Database Initialization ──────────────────────────────────────────────────

export async function initializeDatabase(): Promise<void> {
  try {
    const client = await pgPool.connect();
    console.log('[Database] Connected to PostgreSQL successfully.');

    // Run migration schema
    const migrationPath = path.join(__dirname, '../database/migrations/001_china_box_and_futian.sql');
    if (fs.existsSync(migrationPath)) {
      const sql = fs.readFileSync(migrationPath, 'utf-8');
      await client.query(sql);
      console.log('[Database] Migration 001 applied (idempotent).');
    }

    // Seed default admin users if not present
    await seedDefaultData(client);

    client.release();
    console.log('[Database] Initialization complete.');
  } catch (err: any) {
    console.error('[Database] PostgreSQL initialization failed:', err.message);
    console.warn('[Database] Server will start but data will NOT persist. Check DB connection.');
  }
}

async function seedDefaultData(client: any) {
  // Seed admin user
  const adminExists = await client.query(`SELECT id FROM users WHERE identity = 'admin@ahmedbaba.com' LIMIT 1`);
  if (adminExists.rows.length === 0) {
    const adminId = '00000000-0000-0000-0000-000000000001';
    const staffId = '00000000-0000-0000-0000-000000000002';
    const custAId = '11111111-1111-1111-1111-111111111111';
    const custBId = '22222222-2222-2222-2222-222222222222';
    const warehouseId = '33333333-3333-3333-3333-333333333333';

    const adminHash = bcrypt.hashSync('AdminPassword123!', 10);
    const staffHash = bcrypt.hashSync('StaffPassword123!', 10);
    const custHash  = bcrypt.hashSync('CustomerPassword123!', 10);

    // Users
    await client.query(`INSERT INTO users (id, identity, password_hash, role, status) VALUES
      ('${adminId}', 'admin@ahmedbaba.com',    '${adminHash}', 'ADMIN',    'ACTIVE'),
      ('${staffId}', 'staff@ahmedbaba.com',    '${staffHash}', 'STAFF',    'ACTIVE'),
      ('${custAId}', 'customer@ahmedbaba.com', '${custHash}',  'CUSTOMER', 'ACTIVE'),
      ('${custBId}', 'customer2@ahmedbaba.com','${custHash}',  'CUSTOMER', 'ACTIVE')
      ON CONFLICT (identity) DO NOTHING`);

    // Profiles
    await client.query(`INSERT INTO user_profiles (user_id, full_name, phone, email, country_code, box_code) VALUES
      ('${custAId}', 'Ahmed Al-Libi',  '+218912345678', 'customer@ahmedbaba.com',  '+218', 'AB-8821'),
      ('${custBId}', 'Omar Benghazi',  '+218929876543', 'customer2@ahmedbaba.com', '+218', 'AB-9942')
      ON CONFLICT (user_id) DO NOTHING`);

    // Warehouse
    await client.query(`INSERT INTO warehouses (id, name_en, name_ar, city_en, city_ar, address_en, address_ar, postal_code, contact_phone, map_url, is_active) VALUES
      ('${warehouseId}',
       'Guangzhou Main Hub', 'مستودع قوانغتشو الرئيسي',
       'Guangzhou', 'قوانغتشو',
       'Room 402, Building B, Logistics Industrial Park, Baiyun District, Guangzhou, Guangdong, China',
       'الغرفة 402، المبنى ب، مجمع الخدمات اللوجستية، حي باييون، قوانغتشو، مقاطعة قوانغدونغ، الصين',
       '510000', '+86 20 8899 1234', 'https://maps.google.com/?q=23.1291,113.2644', TRUE)
      ON CONFLICT (id) DO NOTHING`);

    // Shipping Methods
    const airRateId = '44444444-4444-4444-4444-444444444441';
    const seaRateId = '44444444-4444-4444-4444-444444444442';
    await client.query(`INSERT INTO shipping_methods (id, type, title_en, title_ar, subtitle_en, subtitle_ar, estimated_days, rate_per_kg, rate_per_cbm, base_fee, minimum_fee, is_active) VALUES
      ('${airRateId}', 'AIR', 'Express Air Freight', 'شحن جوي سريع',
       'Direct flight to Tripoli Airport', 'رحلة مباشرة إلى مطار طرابلس الدولي',
       '5 - 7 Days', 12.00, 0.00, 15.00, 30.00, TRUE),
      ('${seaRateId}', 'SEA', 'Economy Sea Freight', 'شحن بحري اقتصادي',
       'Container delivery to Tripoli & Benghazi Ports', 'حاويات مجمعة لموانئ طرابلس وبنغازي',
       '25 - 35 Days', 1.50, 280.00, 45.00, 100.00, TRUE)
      ON CONFLICT (id) DO NOTHING`);

    // Sample packages for Customer A
    await client.query(`INSERT INTO packages (id, customer_id, warehouse_id, box_number, tracking_number, dimensions, weight_kg, volume_cbm, status, photos, notes) VALUES
      ('55555555-5555-5555-5555-555555555551', '${custAId}', '${warehouseId}', 'BOX-2024-001', 'CN8920194829', '40 x 30 x 25 cm', 3.5, 0.030, 'READY_FOR_CONSOLIDATION', '[]', 'Wireless electronics and accessories'),
      ('55555555-5555-5555-5555-555555555552', '${custAId}', '${warehouseId}', 'BOX-2024-002', 'CN8920194830', '50 x 35 x 30 cm', 5.2, 0.052, 'IN_WAREHOUSE', '[]', 'Apparel & Leather goods'),
      ('55555555-5555-5555-5555-555555555553', '${custAId}', '${warehouseId}', 'BOX-2024-003', 'CN8920194831', '30 x 20 x 15 cm', 1.8, 0.009, 'READY_FOR_CONSOLIDATION', '[]', 'Smart watches and parts')
      ON CONFLICT (id) DO NOTHING`);

    // Sample Futian orders for Customer A
    await client.query(`INSERT INTO futian_orders (id, order_id, customer_id, product_name_en, product_name_ar, product_url, site_name_en, site_name_ar, site_type, quantity, destination_country, declared_value_usd, unit_price_usd, total_price_usd, status, visual_type, notes) VALUES
      ('66666666-6666-6666-6666-666666666661', '#AB-2505237', '${custAId}', 'Wireless Bluetooth Headphones', 'سماعة بلوتوث لاسلكية', 'https://detail.1688.com/offer/6792348123.html', 'China', 'الصين', 'china', 2, 'Libya', 42.00, 21.00, 42.00, 'UNDER_REVIEW',    'earbuds',    'Customer requested white color with noise cancelling.'),
      ('66666666-6666-6666-6666-666666666662', '#AB-2505219', '${custAId}', 'Smart Watch',                   'ساعة ذكية',           'https://amazon.com/dp/B08N5WRWNW',              'America','أمريكا', 'usa',   1, 'Libya',120.00,120.00,120.00, 'PRICE_PENDING',   'smartwatch', 'Awaiting supplier price confirmation.'),
      ('66666666-6666-6666-6666-666666666663', '#AB-2505188', '${custAId}', 'Women Handbag',                 'شنطة يد نسائية',      'https://trendyol.com/bag/1293841',              'Turkey', 'تركيا', 'turkey',1, 'Libya', 85.00, 85.00, 85.00, 'APPROVAL_PENDING','handbag',    'Price quoted. Customer must approve.'),
      ('66666666-6666-6666-6666-666666666664', '#AB-2505150', '${custAId}', 'Sports Shoes',                  'حذاء رياضي',          'https://item.taobao.com/item.htm?id=9823412',   'China', 'الصين', 'china', 1, 'Libya', 55.00, 55.00, 55.00, 'PURCHASED',       'sneakers',   'Purchased from official merchant.'),
      ('66666666-6666-6666-6666-666666666665', '#AB-2505122', '${custAId}', '20000mAh Power Bank',           'باور بانك 20000mAh',  'https://shein.com/powerbank-20000',             'SHEIN',  'SHEIN',  'shein', 1, 'Libya', 28.00, 28.00, 28.00, 'SHIPPED',         'powerbank',  'Dispatched via sea freight.'),
      ('66666666-6666-6666-6666-666666666666', '#AB-2505099', '${custAId}', 'Sunglasses',                    'نظارة شمسية',         'https://amazon.com/sunglasses-polarized',       'America','أمريكا', 'usa',   1, 'Libya', 35.00, 35.00, 35.00, 'ARRIVED',         'sunglasses', 'Arrived at Tripoli warehouse.')
      ON CONFLICT (order_id) DO NOTHING`);

    // Sample shipment + milestones
    await client.query(`INSERT INTO shipments (tracking_number, order_id, customer_id, carrier, shipping_method, origin_city, destination_city, current_status_en, current_status_ar, weight_kg, total_cost_usd, package_count) VALUES
      ('AB-TRK-882190', '#AB-2505150', '${custAId}', 'Ahmed Baba Logistics (Air Line)', 'Express Air Freight', 'Guangzhou, China', 'Tripoli, Libya', 'In Transit to Destination Port', 'في الطريق إلى ميناء الوصول', 10.5, 141.00, 3)
      ON CONFLICT (tracking_number) DO NOTHING`);

    await client.query(`INSERT INTO tracking_milestones (id, tracking_number, step_number, title_en, title_ar, location, timestamp_text, state) VALUES
      (gen_random_uuid(), 'AB-TRK-882190', 1, 'Order Placed & Registered',      'تم إنشاء الطلب وتسجيله',              'Ahmed Baba Platform',          '20 May 2025 - 09:00 AM',     'COMPLETED'),
      (gen_random_uuid(), 'AB-TRK-882190', 2, 'Received at Guangzhou Warehouse', 'تم استلام الشحنة في مستودع قوانغتشو', 'Guangzhou Main Hub',           '21 May 2025 - 02:30 PM',     'COMPLETED'),
      (gen_random_uuid(), 'AB-TRK-882190', 3, 'Security Screening & Consolidation','الفحص الأمني والتغليف والتجميع',    'Guangzhou Main Hub',           '22 May 2025 - 11:00 AM',     'COMPLETED'),
      (gen_random_uuid(), 'AB-TRK-882190', 4, 'Customs Clearance Export Passed', 'اجتياز التخليص الجمركي للتصدير',     'Guangzhou Port / Airport',     '23 May 2025 - 04:00 PM',     'COMPLETED'),
      (gen_random_uuid(), 'AB-TRK-882190', 5, 'Departed Origin via Air Cargo',   'مغادرة بلد المنشأ عبر الشحن الجوي',  'International Air Transit',    '24 May 2025 - 08:30 AM',     'CURRENT'),
      (gen_random_uuid(), 'AB-TRK-882190', 6, 'Arrival at Destination Airport',  'الوصول إلى مطار طرابلس الدولي',       'Tripoli International Airport','Estimated: 26 May 2025',     'PENDING'),
      (gen_random_uuid(), 'AB-TRK-882190', 7, 'Local Customs Clearance',         'التخليص الجمركي المحلي',              'Tripoli Customs Authority',    'Pending Arrival',            'PENDING'),
      (gen_random_uuid(), 'AB-TRK-882190', 8, 'Delivered to Doorstep / Customer','تم التسليم بنجاح للعميل',             'Tripoli, Libya',               'Pending Clearance',          'PENDING')
      ON CONFLICT DO NOTHING`);

    // Sample notifications
    await client.query(`INSERT INTO notifications (id, customer_id, title, message, type, is_read, related_id) VALUES
      (gen_random_uuid(), '${custAId}', 'Order Status Updated',         'Your order #AB-2505188 has been priced and is awaiting your approval.', 'ORDER_UPDATE',     FALSE, '#AB-2505188'),
      (gen_random_uuid(), '${custAId}', 'Package Received at Warehouse','Package BOX-2024-001 (3.5 kg) was safely checked into Guangzhou Warehouse.','PACKAGE_RECEIVED',TRUE,  'BOX-2024-001')`);

    console.log('[Database] Default seed data inserted.');
  } else {
    console.log('[Database] Seed data already exists — skipping.');
  }
}
