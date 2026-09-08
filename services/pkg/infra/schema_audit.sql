-- AhmedBaba Master Schema Audit (Optimized for Bulk Search)

-- 1. Products Table with Full-Text Search Indices
CREATE TABLE products (
    id UUID PRIMARY KEY,
    title TEXT NOT NULL,
    description TEXT,
    base_price DECIMAL(18, 2),
    category_id VARCHAR(50),
    supplier_id UUID,
    moq INTEGER DEFAULT 1,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Optimization: Gin Index for text search
CREATE INDEX idx_products_title_trgm ON products USING gin (title gin_trgm_ops);
CREATE INDEX idx_products_category ON products(category_id);
CREATE INDEX idx_products_supplier ON products(supplier_id);

-- 2. Bulk Tiers Table
CREATE TABLE price_tiers (
    id SERIAL PRIMARY KEY,
    product_id UUID REFERENCES products(id),
    min_quantity INTEGER,
    price DECIMAL(18, 2)
);
CREATE INDEX idx_tiers_product ON price_tiers(product_id);

-- 3. Trade Assurance Orders
CREATE TABLE orders (
    id UUID PRIMARY KEY,
    buyer_id UUID,
    supplier_id UUID,
    total_amount DECIMAL(18, 2),
    status VARCHAR(20), -- CREATED, PAID, SHIPPED, COMPLETED, DISPUTED
    is_escrow_locked BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_orders_buyer ON orders(buyer_id);

-- 4. Audit Trail Table
CREATE TABLE audit_logs (
    id SERIAL PRIMARY KEY,
    entity_type VARCHAR(50),
    entity_id UUID,
    action VARCHAR(100),
    user_id UUID,
    timestamp TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
