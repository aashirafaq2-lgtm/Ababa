#!/bin/bash
set -e

echo "Setting up PostgreSQL user and database..."
sudo -u postgres psql << 'EOF'
DO $$
BEGIN
   IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'ahmedbaba_user') THEN
      CREATE ROLE ahmedbaba_user WITH LOGIN PASSWORD 'AhmedBaba2026Secure!' CREATEDB;
   END IF;
END
$$;
EOF

sudo -u postgres psql -lqt | cut -d \| -f 1 | grep -qw ahmedbaba_db || sudo -u postgres createdb -O ahmedbaba_user ahmedbaba_db

mkdir -p /var/www/ahmedbaba/backend
mkdir -p /var/www/ahmedbaba/admin

echo "DB and folders created successfully!"
