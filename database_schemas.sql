-- AhmedBaba Persistence Schema: PostgreSQL
-- Version: 1.0.0

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Global Persona Definitions
CREATE TYPE persona_type AS ENUM ('GLOBAL_BUYER', 'SUPPLIER_MANUFACTURER');
CREATE TYPE kyb_status AS ENUM ('PENDING', 'VERIFIED', 'REJECTED');
CREATE TYPE contract_state AS ENUM ('CONTRACT_DRAFT', 'AWAITING_DEPOSIT', 'IN_PRODUCTION', 'AWAITING_SHIPMENT', 'SHIPPED', 'SETTLED');

-- 1. Corporate Identity Workspace
CREATE TABLE USER_COMPANY (
    company_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    corporate_name VARCHAR(255) NOT NULL,
    persona_type persona_type NOT NULL,
    kyb_status kyb_status DEFAULT 'PENDING',
    wallet_balance_usd DECIMAL(19, 4) DEFAULT 0.0000,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    verification_hash TEXT
);

-- 2. Multi-Sig B2B Contract Ledger
CREATE TABLE B2B_CONTRACT (
    contract_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    buyer_id UUID REFERENCES USER_COMPANY(company_id),
    supplier_id UUID REFERENCES USER_COMPANY(company_id),
    sku_matrix_snapshot JSONB NOT NULL,
    total_order_value DECIMAL(19, 4) NOT NULL,
    current_state contract_state DEFAULT 'CONTRACT_DRAFT',
    escrow_reference_id VARCHAR(128),
    is_multi_sig_verified BOOLEAN DEFAULT FALSE,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 3. Trade Assurance Escrow Engine
CREATE TABLE ESCROW_LEDGER (
    escrow_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    contract_id UUID REFERENCES B2B_CONTRACT(contract_id),
    deposited_amount DECIMAL(19, 4) NOT NULL,
    target_bank_routing VARCHAR(64),
    target_account_number VARCHAR(64),
    is_locked BOOLEAN DEFAULT TRUE,
    unlock_token_hash TEXT,
    settlement_timestamp TIMESTAMP WITH TIME ZONE
);

-- Indices for high-frequency sourcing queries
CREATE INDEX idx_company_persona ON USER_COMPANY(persona_type);
CREATE INDEX idx_contract_buyer ON B2B_CONTRACT(buyer_id);
CREATE INDEX idx_contract_state ON B2B_CONTRACT(current_state);
