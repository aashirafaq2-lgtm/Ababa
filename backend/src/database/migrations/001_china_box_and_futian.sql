-- AhmedBaba Migration 001: My China Box & Futian Purchases
-- Real relational database schema for PostgreSQL

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 1. Users & Profiles (Roles: ADMIN, STAFF, CUSTOMER)
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    identity VARCHAR(255) UNIQUE NOT NULL, -- email or phone
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(32) NOT NULL DEFAULT 'CUSTOMER', -- 'ADMIN', 'STAFF', 'CUSTOMER'
    status VARCHAR(32) NOT NULL DEFAULT 'ACTIVE', -- 'ACTIVE', 'SUSPENDED'
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS user_profiles (
    user_id UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    full_name VARCHAR(255) NOT NULL,
    phone VARCHAR(64),
    email VARCHAR(255),
    country_code VARCHAR(8) DEFAULT '+218',
    box_code VARCHAR(32) UNIQUE NOT NULL, -- e.g. 'AB-8821'
    avatar_url TEXT,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 2. Warehouses & Addresses
CREATE TABLE IF NOT EXISTS warehouses (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name_en VARCHAR(255) NOT NULL,
    name_ar VARCHAR(255) NOT NULL,
    city_en VARCHAR(128) NOT NULL,
    city_ar VARCHAR(128) NOT NULL,
    address_en TEXT NOT NULL,
    address_ar TEXT NOT NULL,
    postal_code VARCHAR(32),
    contact_phone VARCHAR(64),
    map_url TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 3. Stored Packages
CREATE TABLE IF NOT EXISTS packages (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    customer_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    warehouse_id UUID REFERENCES warehouses(id),
    box_number VARCHAR(64) NOT NULL,
    tracking_number VARCHAR(128) NOT NULL,
    dimensions VARCHAR(64) NOT NULL, -- e.g. '60 x 40 x 35 cm'
    weight_kg NUMERIC(10, 2) NOT NULL DEFAULT 0.00,
    volume_cbm NUMERIC(10, 4) NOT NULL DEFAULT 0.0000,
    arrival_date TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(64) NOT NULL DEFAULT 'IN_WAREHOUSE', 
    -- 'IN_WAREHOUSE', 'READY_FOR_CONSOLIDATION', 'UNDER_REVIEW', 'SHIPPED', 'REJECTED'
    photos JSONB DEFAULT '[]'::jsonb,
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 4. Shipping Methods & Dynamic Tariffs
CREATE TABLE IF NOT EXISTS shipping_methods (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    type VARCHAR(32) NOT NULL, -- 'AIR', 'SEA'
    title_en VARCHAR(255) NOT NULL,
    title_ar VARCHAR(255) NOT NULL,
    subtitle_en VARCHAR(255),
    subtitle_ar VARCHAR(255),
    estimated_days VARCHAR(64) NOT NULL,
    rate_per_kg NUMERIC(10, 2) NOT NULL DEFAULT 0.00,
    rate_per_cbm NUMERIC(10, 2) NOT NULL DEFAULT 0.00,
    base_fee NUMERIC(10, 2) NOT NULL DEFAULT 0.00,
    minimum_fee NUMERIC(10, 2) NOT NULL DEFAULT 0.00,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 5. Package Consolidation Orders
CREATE TABLE IF NOT EXISTS consolidation_orders (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    order_number VARCHAR(64) UNIQUE NOT NULL,
    customer_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    shipping_method_id UUID REFERENCES shipping_methods(id),
    destination_country VARCHAR(64) NOT NULL,
    destination_city VARCHAR(128) NOT NULL,
    delivery_address TEXT,
    delivery_type VARCHAR(32) DEFAULT 'DOORSTEP',
    total_weight_kg NUMERIC(10, 2) NOT NULL DEFAULT 0.00,
    total_cbm NUMERIC(10, 4) NOT NULL DEFAULT 0.0000,
    shipping_cost_usd NUMERIC(10, 2) NOT NULL DEFAULT 0.00,
    status VARCHAR(64) NOT NULL DEFAULT 'REQUESTED',
    -- 'REQUESTED', 'APPROVED', 'IN_PACKING', 'READY_TO_SHIP', 'SHIPPED', 'REJECTED'
    package_ids JSONB NOT NULL DEFAULT '[]'::jsonb,
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 6. Purchases from Futian Orders (7 Canonical Statuses + UI All Filter)
CREATE TABLE IF NOT EXISTS futian_orders (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    order_id VARCHAR(64) UNIQUE NOT NULL, -- e.g. '#AB-2505237'
    customer_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    product_name_en VARCHAR(255) NOT NULL,
    product_name_ar VARCHAR(255) NOT NULL,
    product_url TEXT,
    site_name_en VARCHAR(128) DEFAULT 'China',
    site_name_ar VARCHAR(128) DEFAULT 'الصين',
    site_type VARCHAR(32) DEFAULT 'china', -- 'china', 'usa', 'turkey', 'shein'
    quantity INT NOT NULL DEFAULT 1,
    destination_country VARCHAR(64) DEFAULT 'Libya',
    declared_value_usd NUMERIC(10, 2) DEFAULT 0.00,
    unit_price_usd NUMERIC(10, 2) DEFAULT 0.00,
    total_price_usd NUMERIC(10, 2) DEFAULT 0.00,
    status VARCHAR(64) NOT NULL DEFAULT 'UNDER_REVIEW',
    -- Canonical 7 Statuses:
    -- 'UNDER_REVIEW', 'PRICE_PENDING', 'APPROVAL_PENDING', 'PURCHASED', 'SHIPPED', 'ARRIVED', 'CANCELLED'
    -- Note: 'ALL' is an aggregate UI filter counter, not an entity status
    image_asset TEXT,
    visual_type VARCHAR(64) DEFAULT 'general',
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 7. Order Status History (Every status transition recorded with user & timestamp)
CREATE TABLE IF NOT EXISTS order_status_history (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    order_id VARCHAR(64) NOT NULL REFERENCES futian_orders(order_id) ON DELETE CASCADE,
    from_status VARCHAR(64),
    to_status VARCHAR(64) NOT NULL,
    changed_by_user_id UUID REFERENCES users(id),
    changed_by_name VARCHAR(255) NOT NULL,
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 8. Shipments & Live Tracking Milestones
CREATE TABLE IF NOT EXISTS shipments (
    tracking_number VARCHAR(128) PRIMARY KEY,
    order_id VARCHAR(64),
    customer_id UUID REFERENCES users(id) ON DELETE SET NULL,
    carrier VARCHAR(128) NOT NULL,
    shipping_method VARCHAR(64) NOT NULL,
    origin_city VARCHAR(128) NOT NULL,
    destination_city VARCHAR(128) NOT NULL,
    current_status_en VARCHAR(128) NOT NULL,
    current_status_ar VARCHAR(128) NOT NULL,
    weight_kg NUMERIC(10, 2) NOT NULL DEFAULT 0.00,
    total_cost_usd NUMERIC(10, 2) NOT NULL DEFAULT 0.00,
    package_count INT DEFAULT 1,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS tracking_milestones (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tracking_number VARCHAR(128) NOT NULL REFERENCES shipments(tracking_number) ON DELETE CASCADE,
    step_number INT NOT NULL,
    title_en VARCHAR(255) NOT NULL,
    title_ar VARCHAR(255) NOT NULL,
    location VARCHAR(255) NOT NULL,
    timestamp_text VARCHAR(128) NOT NULL,
    state VARCHAR(32) NOT NULL DEFAULT 'PENDING', -- 'COMPLETED', 'CURRENT', 'PENDING'
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 9. Notifications (Dynamic unread count)
CREATE TABLE IF NOT EXISTS notifications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    customer_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    type VARCHAR(64) NOT NULL DEFAULT 'ORDER_UPDATE',
    is_read BOOLEAN DEFAULT FALSE,
    related_id VARCHAR(128),
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 10. Admin Audit Logs
CREATE TABLE IF NOT EXISTS admin_audit_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    admin_user_id UUID REFERENCES users(id),
    admin_name VARCHAR(255) NOT NULL,
    action VARCHAR(128) NOT NULL,
    entity_type VARCHAR(64) NOT NULL,
    entity_id VARCHAR(128) NOT NULL,
    old_values JSONB,
    new_values JSONB,
    ip_address VARCHAR(64),
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Indices for rapid queries and strict customer data isolation
CREATE INDEX IF NOT EXISTS idx_users_identity ON users(identity);
CREATE INDEX IF NOT EXISTS idx_user_profiles_box_code ON user_profiles(box_code);
CREATE INDEX IF NOT EXISTS idx_packages_customer ON packages(customer_id);
CREATE INDEX IF NOT EXISTS idx_packages_status ON packages(status);
CREATE INDEX IF NOT EXISTS idx_consolidation_customer ON consolidation_orders(customer_id);
CREATE INDEX IF NOT EXISTS idx_futian_customer ON futian_orders(customer_id);
CREATE INDEX IF NOT EXISTS idx_futian_status ON futian_orders(status);
CREATE INDEX IF NOT EXISTS idx_futian_order_id ON futian_orders(order_id);
CREATE INDEX IF NOT EXISTS idx_order_status_history_order ON order_status_history(order_id);
CREATE INDEX IF NOT EXISTS idx_shipments_customer ON shipments(customer_id);
CREATE INDEX IF NOT EXISTS idx_tracking_milestones_tracking ON tracking_milestones(tracking_number);
CREATE INDEX IF NOT EXISTS idx_notifications_customer ON notifications(customer_id, is_read);
CREATE INDEX IF NOT EXISTS idx_admin_audit_entity ON admin_audit_logs(entity_type, entity_id);
