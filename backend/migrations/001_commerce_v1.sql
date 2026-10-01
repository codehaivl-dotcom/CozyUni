-- CozyUni Commerce v1
-- PostgreSQL 16+
-- Ledger/history tables are append-only by application policy.

BEGIN;

CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE commerce_accounts (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    app_account_token uuid NOT NULL UNIQUE DEFAULT gen_random_uuid(),
    status text NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'disabled')),
    refund_debt_cc bigint NOT NULL DEFAULT 0 CHECK (refund_debt_cc >= 0),
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE commerce_identities (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    account_id uuid NOT NULL REFERENCES commerce_accounts(id),
    provider text NOT NULL CHECK (provider IN ('apple')),
    provider_subject_hash bytea NOT NULL,
    created_at timestamptz NOT NULL DEFAULT now(),
    UNIQUE (provider, provider_subject_hash)
);

CREATE INDEX idx_commerce_identities_account ON commerce_identities(account_id);

CREATE TABLE commerce_sessions (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    account_id uuid NOT NULL REFERENCES commerce_accounts(id),
    access_token_hash bytea NOT NULL UNIQUE,
    refresh_token_hash bytea NOT NULL UNIQUE,
    access_expires_at timestamptz NOT NULL,
    refresh_expires_at timestamptz NOT NULL,
    rotated_from_session_id uuid NULL REFERENCES commerce_sessions(id),
    revoked_at timestamptz NULL,
    last_used_at timestamptz NULL,
    created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_commerce_sessions_account ON commerce_sessions(account_id);
CREATE INDEX idx_commerce_sessions_refresh_expiry ON commerce_sessions(refresh_expires_at) WHERE revoked_at IS NULL;

CREATE TABLE wallet_balance_projection (
    account_id uuid PRIMARY KEY REFERENCES commerce_accounts(id),
    purchased_cc bigint NOT NULL DEFAULT 0 CHECK (purchased_cc >= 0),
    bonus_cc bigint NOT NULL DEFAULT 0 CHECK (bonus_cc >= 0),
    refund_debt_cc bigint NOT NULL DEFAULT 0 CHECK (refund_debt_cc >= 0),
    revision bigint NOT NULL DEFAULT 0 CHECK (revision >= 0),
    updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE apple_transactions (
    transaction_id text PRIMARY KEY,
    original_transaction_id text NULL,
    account_id uuid NOT NULL REFERENCES commerce_accounts(id),
    app_account_token uuid NOT NULL,
    product_id text NOT NULL,
    environment text NOT NULL CHECK (environment IN ('Sandbox', 'Production')),
    purchase_date timestamptz NOT NULL,
    signed_date timestamptz NOT NULL,
    revocation_date timestamptz NULL,
    revocation_reason text NULL,
    revocation_percentage_milliunits integer NULL CHECK (revocation_percentage_milliunits IS NULL OR (revocation_percentage_milliunits >= 0 AND revocation_percentage_milliunits <= 100000)),
    latest_notification_type text NULL,
    grant_status text NOT NULL DEFAULT 'pending' CHECK (grant_status IN ('pending', 'delivered', 'refunded', 'needs_reconciliation')),
    raw_signed_jws text NOT NULL,
    jws_sha256 bytea NOT NULL,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_apple_transactions_account ON apple_transactions(account_id, purchase_date DESC);
CREATE INDEX idx_apple_transactions_original ON apple_transactions(original_transaction_id);
CREATE INDEX idx_apple_transactions_product ON apple_transactions(product_id);
CREATE INDEX idx_apple_transactions_app_account_token ON apple_transactions(app_account_token);

CREATE TABLE apple_notifications (
    notification_uuid uuid PRIMARY KEY,
    notification_type text NOT NULL,
    subtype text NULL,
    environment text NULL CHECK (environment IS NULL OR environment IN ('Sandbox', 'Production')),
    signed_date timestamptz NOT NULL,
    received_at timestamptz NOT NULL DEFAULT now(),
    transaction_id text NULL,
    processing_status text NOT NULL DEFAULT 'received' CHECK (processing_status IN ('received', 'processed', 'needs_reconciliation', 'failed_retryable', 'failed_terminal')),
    attempts integer NOT NULL DEFAULT 0 CHECK (attempts >= 0),
    last_error text NULL,
    raw_signed_payload text NOT NULL,
    processed_at timestamptz NULL
);

CREATE INDEX idx_apple_notifications_status ON apple_notifications(processing_status, received_at);
CREATE INDEX idx_apple_notifications_transaction ON apple_notifications(transaction_id);

CREATE TABLE credit_lots (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    account_id uuid NOT NULL REFERENCES commerce_accounts(id),
    bucket text NOT NULL CHECK (bucket IN ('purchased', 'bonus')),
    source_type text NOT NULL CHECK (source_type IN ('apple_iap', 'promo', 'support', 'refund_reversal', 'admin_adjustment')),
    source_id text NOT NULL,
    original_cc bigint NOT NULL CHECK (original_cc > 0),
    remaining_cc bigint NOT NULL CHECK (remaining_cc >= 0),
    expires_at timestamptz NULL,
    created_at timestamptz NOT NULL DEFAULT now(),
    CHECK (remaining_cc <= original_cc),
    UNIQUE (account_id, source_type, source_id)
);

CREATE INDEX idx_credit_lots_spend_order ON credit_lots(account_id, bucket, created_at, id) WHERE remaining_cc > 0;
CREATE INDEX idx_credit_lots_expiry ON credit_lots(expires_at) WHERE expires_at IS NOT NULL AND remaining_cc > 0;

CREATE TABLE wallet_ledger (
    id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    account_id uuid NOT NULL REFERENCES commerce_accounts(id),
    currency_code text NOT NULL DEFAULT 'CC' CHECK (currency_code = 'CC'),
    event_type text NOT NULL CHECK (event_type IN (
        'iap_grant',
        'promo_grant',
        'support_grant',
        'catalog_spend',
        'iap_refund_reversal',
        'refund_reversed_restore',
        'refund_debt_created',
        'refund_debt_repaid',
        'admin_adjustment'
    )),
    bucket text NULL CHECK (bucket IS NULL OR bucket IN ('purchased', 'bonus', 'debt')),
    delta_cc bigint NOT NULL CHECK (delta_cc <> 0),
    source_type text NOT NULL,
    source_id text NOT NULL,
    idempotency_key uuid NULL,
    related_ledger_id bigint NULL REFERENCES wallet_ledger(id),
    metadata jsonb NOT NULL DEFAULT '{}'::jsonb,
    created_at timestamptz NOT NULL DEFAULT now()
);

CREATE UNIQUE INDEX uq_wallet_ledger_idempotency ON wallet_ledger(account_id, idempotency_key) WHERE idempotency_key IS NOT NULL;
CREATE INDEX idx_wallet_ledger_account_time ON wallet_ledger(account_id, created_at DESC, id DESC);
CREATE INDEX idx_wallet_ledger_source ON wallet_ledger(source_type, source_id);

CREATE TABLE wallet_spend_allocations (
    spend_ledger_id bigint NOT NULL REFERENCES wallet_ledger(id),
    credit_lot_id uuid NOT NULL REFERENCES credit_lots(id),
    allocated_cc bigint NOT NULL CHECK (allocated_cc > 0),
    PRIMARY KEY (spend_ledger_id, credit_lot_id)
);

CREATE INDEX idx_wallet_spend_allocations_lot ON wallet_spend_allocations(credit_lot_id);

CREATE TABLE catalog_items (
    id text PRIMARY KEY,
    item_type text NOT NULL CHECK (item_type IN (
        'profile_frame',
        'badge',
        'emote',
        'victory_pose',
        'character_outfit',
        'character_colorway',
        'board_skin',
        'table_theme',
        'dice_skin',
        'token_skin',
        'seasonal_cosmetic_bundle'
    )),
    price_cc bigint NOT NULL CHECK (price_cc > 0),
    active boolean NOT NULL DEFAULT false,
    stackable boolean NOT NULL DEFAULT false,
    sort_order integer NOT NULL DEFAULT 0,
    content_version integer NOT NULL DEFAULT 1 CHECK (content_version > 0),
    metadata jsonb NOT NULL DEFAULT '{}'::jsonb,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_catalog_items_active_sort ON catalog_items(active, sort_order, id);

CREATE TABLE catalog_purchases (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    account_id uuid NOT NULL REFERENCES commerce_accounts(id),
    catalog_id text NOT NULL REFERENCES catalog_items(id),
    charged_cc bigint NOT NULL CHECK (charged_cc > 0),
    idempotency_key uuid NOT NULL,
    spend_ledger_id bigint NOT NULL UNIQUE REFERENCES wallet_ledger(id),
    created_at timestamptz NOT NULL DEFAULT now(),
    UNIQUE (account_id, idempotency_key)
);

CREATE INDEX idx_catalog_purchases_account_time ON catalog_purchases(account_id, created_at DESC);

CREATE TABLE entitlements (
    account_id uuid NOT NULL REFERENCES commerce_accounts(id),
    catalog_id text NOT NULL REFERENCES catalog_items(id),
    acquired_from_purchase_id uuid NULL REFERENCES catalog_purchases(id),
    acquired_at timestamptz NOT NULL DEFAULT now(),
    revoked_at timestamptz NULL,
    revoke_reason text NULL,
    metadata jsonb NOT NULL DEFAULT '{}'::jsonb,
    PRIMARY KEY (account_id, catalog_id)
);

CREATE INDEX idx_entitlements_account_active ON entitlements(account_id) WHERE revoked_at IS NULL;

CREATE TABLE commerce_outbox (
    id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    event_type text NOT NULL,
    payload jsonb NOT NULL,
    available_at timestamptz NOT NULL DEFAULT now(),
    attempts integer NOT NULL DEFAULT 0 CHECK (attempts >= 0),
    locked_at timestamptz NULL,
    locked_by text NULL,
    last_error text NULL,
    completed_at timestamptz NULL,
    terminal_failure boolean NOT NULL DEFAULT false,
    created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_commerce_outbox_ready ON commerce_outbox(available_at, id)
WHERE completed_at IS NULL AND terminal_failure = false;

CREATE TABLE admin_audit_events (
    id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    actor_id text NOT NULL,
    actor_role text NOT NULL CHECK (actor_role IN ('support_readonly', 'commerce_operator', 'commerce_admin', 'system')),
    action_type text NOT NULL,
    account_id uuid NULL REFERENCES commerce_accounts(id),
    request_id uuid NULL,
    source_ref text NULL,
    reason text NULL,
    metadata jsonb NOT NULL DEFAULT '{}'::jsonb,
    created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_admin_audit_account_time ON admin_audit_events(account_id, created_at DESC);
CREATE INDEX idx_admin_audit_actor_time ON admin_audit_events(actor_id, created_at DESC);

-- Create wallet projection automatically for new accounts.
CREATE OR REPLACE FUNCTION create_wallet_projection_for_account()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO wallet_balance_projection(account_id, refund_debt_cc)
    VALUES (NEW.id, NEW.refund_debt_cc);
    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_commerce_account_wallet_projection
AFTER INSERT ON commerce_accounts
FOR EACH ROW
EXECUTE FUNCTION create_wallet_projection_for_account();

-- Prevent accidental UPDATE/DELETE of append-only ledger history at the DB level.
CREATE OR REPLACE FUNCTION reject_wallet_ledger_mutation()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
    RAISE EXCEPTION 'wallet_ledger is append-only; use compensating entries';
END;
$$;

CREATE TRIGGER trg_wallet_ledger_no_update
BEFORE UPDATE ON wallet_ledger
FOR EACH ROW EXECUTE FUNCTION reject_wallet_ledger_mutation();

CREATE TRIGGER trg_wallet_ledger_no_delete
BEFORE DELETE ON wallet_ledger
FOR EACH ROW EXECUTE FUNCTION reject_wallet_ledger_mutation();

-- Admin audit history is append-only as well.
CREATE OR REPLACE FUNCTION reject_admin_audit_mutation()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
    RAISE EXCEPTION 'admin_audit_events is append-only';
END;
$$;

CREATE TRIGGER trg_admin_audit_no_update
BEFORE UPDATE ON admin_audit_events
FOR EACH ROW EXECUTE FUNCTION reject_admin_audit_mutation();

CREATE TRIGGER trg_admin_audit_no_delete
BEFORE DELETE ON admin_audit_events
FOR EACH ROW EXECUTE FUNCTION reject_admin_audit_mutation();

COMMIT;
