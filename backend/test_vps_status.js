const { Client } = require('ssh2');

const VPS_HOST = '72.62.50.86';
const VPS_USER = 'root';
const VPS_PASS = 'IraqBid2026Root@';

const conn = new Client();
conn.on('ready', () => {
  console.log('✅ SSH Connected successfully to', VPS_HOST);
  conn.exec('pm2 status; echo "=== NGINX ==="; systemctl status nginx --no-pager | head -n 10; echo "=== DOCKER ==="; docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" 2>/dev/null || true; echo "=== PORTS ==="; netstat -tuln | grep -E "5000|5050|3000|8088|80"', (err, stream) => {
    if (err) throw err;
    stream.on('close', (code) => {
      conn.end();
      process.exit(0);
    }).on('data', (data) => {
      process.stdout.write(data.toString());
    }).stderr.on('data', (data) => {
      process.stderr.write(data.toString());
    });
  });
}).on('error', (err) => {
  console.error('SSH Error:', err);
  process.exit(1);
}).connect({
  host: VPS_HOST,
  port: 22,
  username: VPS_USER,
  password: VPS_PASS,
  readyTimeout: 15000
});
