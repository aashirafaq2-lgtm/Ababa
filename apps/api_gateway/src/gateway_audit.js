const express = require('express');
const cors = require('cors');
const helmet = require('helmet');

const app = express();

// SECURITY AUDIT: Added Helmet for XSS/Headers protection
app.use(helmet());
app.use(cors({ origin: '*', methods: ['GET', 'POST', 'PUT', 'DELETE'] }));
app.use(express.json());

// SERVICE DISCOVERY: Routing to Go Microservices
const SERVICES = {
    CATALOG: process.env.CATALOG_SERVICE_URL || 'http://localhost:8081',
    ORDER: process.env.ORDER_SERVICE_URL || 'http://localhost:8082',
    AUTH: process.env.AUTH_SERVICE_URL || 'http://localhost:8083',
    LOGISTICS: process.env.LOGISTICS_SERVICE_URL || 'http://localhost:8084'
};

// GLOBAL AUDIT TRAIL: Middleware for logging every request
app.use((req, res, next) => {
    console.log(`[GATEWAY AUDIT] ${new Date().toISOString()} | ${req.method} ${req.url}`);
    next();
});

// AUTH GUARD
const authMiddleware = (req, res, next) => {
    const token = req.headers['authorization'];
    if (!token) return res.status(401).json({ error: 'Identity required for B2B access' });
    next();
};

app.get('/api/v1/catalog/sync', authMiddleware, async (req, res) => {
    // Proxy logic to Go catalog_service
    res.json({ status: 'Proxying to 1688 Sync Engine' });
});

app.post('/api/v1/trade/escrow/init', authMiddleware, async (req, res) => {
    // Proxy logic to Order service
    res.json({ status: 'Initializing Secure Trade Assurance' });
});

const PORT = 3000;
app.listen(PORT, () => console.log(`AhmedBaba Edge Gateway running on port ${PORT}`));
