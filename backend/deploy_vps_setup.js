const { Client } = require('ssh2');
const path = require('path');
const fs = require('fs');
const { exec } = require('child_process');

const VPS_HOST = '72.62.50.86';
const VPS_USER = 'root';
const VPS_PASS = 'IraqBid2026Root@';

const BACKEND_DIR = 'E:\\Ahmedbaba-main\\Ahmad-baba\\backend';
const ADMIN_DIR = 'E:\\Ahmedbaba-main\\Ahmad-baba\\apps\\admin_panel_web';

// Commands to run on VPS (isolated in /var/www/ahmedbaba, separate port 5050)
const DEPLOY_COMMANDS = `
set -e
echo "=== AhmedBaba Backend Deployment ==="

# 1. Install Node.js if not present
if ! command -v node &> /dev/null; then
  curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
  apt-get install -y nodejs
fi

# 2. Install PM2 if not present
npm install -g pm2 2>/dev/null || true

# 3. Install PostgreSQL if not present (isolated)
if ! command -v psql &> /dev/null; then
  apt-get update -y
  apt-get install -y postgresql postgresql-contrib
  systemctl start postgresql
  systemctl enable postgresql
fi

# 4. Create ahmedbaba database if not exists
sudo -u postgres psql -c "CREATE USER ahmedbaba_user WITH PASSWORD 'AhmedBaba2026Secure!' CREATEDB;" 2>/dev/null || true
sudo -u postgres psql -c "CREATE DATABASE ahmedbaba_db OWNER ahmedbaba_user;" 2>/dev/null || true

# 5. Create deployment directory
mkdir -p /var/www/ahmedbaba/backend
mkdir -p /var/www/ahmedbaba/admin

echo "=== VPS READY FOR UPLOAD ==="
node -v
npm -v
pm2 --version
psql --version
echo "PostgreSQL DB: ahmedbaba_db"
echo "DONE"
`;

async function deployToVPS() {
  console.log('Connecting to VPS...');
  const conn = new Client();
  
  return new Promise((resolve, reject) => {
    conn.on('ready', () => {
      console.log('✅ SSH Connected to ' + VPS_HOST);
      
      conn.exec(DEPLOY_COMMANDS, (err, stream) => {
        if (err) { reject(err); return; }
        
        let output = '';
        stream.on('close', (code) => {
          console.log('\n📋 VPS Setup Output:\n' + output);
          console.log('\n✅ VPS environment ready! Exit code:', code);
          conn.end();
          resolve(output);
        }).on('data', (data) => {
          const text = data.toString();
          output += text;
          process.stdout.write(text);
        }).stderr.on('data', (data) => {
          const text = data.toString();
          output += text;
          process.stdout.write('ERR: ' + text);
        });
      });
    }).on('error', (err) => {
      console.error('SSH Error:', err);
      reject(err);
    }).connect({
      host: VPS_HOST,
      port: 22,
      username: VPS_USER,
      password: VPS_PASS,
      readyTimeout: 30000
    });
  });
}

deployToVPS().catch(console.error);
