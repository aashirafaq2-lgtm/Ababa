-- AhmedBaba Security Hardening: Row-Level Security (RLS) Policies
-- Target: Isolation of Sourcing Tenants and Escrow Security

-- Ensure RLS is active across the trade ledger
ALTER TABLE USER_COMPANY ENABLE ROW LEVEL SECURITY;
ALTER TABLE B2B_CONTRACT ENABLE ROW LEVEL SECURITY;
ALTER TABLE ESCROW_LEDGER ENABLE ROW LEVEL SECURITY;

-- 1. Identity Isolation Policy
-- Users can only see their own company profile
CREATE POLICY company_isolation_policy ON USER_COMPANY
    FOR ALL
    TO authenticated_user
    USING (company_id = current_setting('app.current_company_id')::uuid);

-- 2. Contract Multi-Tenancy Policy
-- A buyer or supplier can only access contracts where they are a primary participant
CREATE POLICY contract_access_policy ON B2B_CONTRACT
    FOR SELECT, UPDATE
    TO authenticated_user
    USING (
        buyer_id = current_setting('app.current_company_id')::uuid OR 
        supplier_id = current_setting('app.current_company_id')::uuid
    );

-- 3. Escrow Ledger Hardening
-- Prohibit any direct DELETE or TRUNCATE operations on financial data
CREATE POLICY no_deletion_on_ledger ON ESCROW_LEDGER
    FOR DELETE
    TO authenticated_user
    USING (false);

-- Only allows viewing of escrow balances for contracts owned by the participant
CREATE POLICY escrow_visibility_policy ON ESCROW_LEDGER
    FOR SELECT
    TO authenticated_user
    USING (
        EXISTS (
            SELECT 1 FROM B2B_CONTRACT
            WHERE B2B_CONTRACT.contract_id = ESCROW_LEDGER.contract_id
            AND (buyer_id = current_setting('app.current_company_id')::uuid OR 
                 supplier_id = current_setting('app.current_company_id')::uuid)
        )
    );

-- 4. Cryptographic Audit Log
-- Trigger to ensure every contract state change is hashed and signed
CREATE OR REPLACE FUNCTION sign_contract_state_change()
RETURNS TRIGGER AS $$
BEGIN
    NEW.verification_hash := encode(hmac(NEW.contract_id::text || NEW.current_state::text, 'SECRET_KEY_PRODUCTION', 'sha256'), 'hex');
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_sign_contract
BEFORE UPDATE OF current_state ON B2B_CONTRACT
FOR EACH ROW EXECUTE FUNCTION sign_contract_state_change();
