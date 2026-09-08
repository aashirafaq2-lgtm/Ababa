const http = require('http');

const data = JSON.stringify({
  identity: 'admin@ahmedbaba.com',
  password: 'AdminPassword123!'
});

const req = http.request('http://72.62.50.86:5000/api/v1/auth/china-box/signin', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'Content-Length': Buffer.byteLength(data)
  }
}, res => {
  console.log('STATUS:', res.statusCode);
  res.on('data', chunk => console.log('BODY:', chunk.toString()));
});

req.on('error', err => console.error('ERR:', err.message));
req.write(data);
req.end();
