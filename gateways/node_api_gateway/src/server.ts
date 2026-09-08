import express from 'express';
import cors from 'cors';
import { createGrpcClient } from './services/grpc_client';

const app = express();
app.use(cors());
app.use(express.json());

// 1. Initialize Service Orchestrators
const authClient = createGrpcClient('auth', process.env.AUTH_SERVICE_URL || 'localhost:50051');
const catalogClient = createGrpcClient('catalog', process.env.CATALOG_SERVICE_URL || 'localhost:50052');
const orderClient = createGrpcClient('order', process.env.ORDER_SERVICE_URL || 'localhost:50053');

// 2. Aggregated Routes
app.post('/api/v1/auth/login', (req, res) => {
    authClient.login(req.body, (err: any, response: any) => {
        if (err) return res.status(500).json(err);
        res.json(response);
    });
});

app.get('/api/v1/catalog/search', (req, res) => {
    catalogClient.searchProducts({ query: req.query.q }, (err: any, response: any) => {
        if (err) return res.status(500).json(err);
        res.json(response);
    });
});

// 3. Health & Monitor
app.get('/health', (req, res) => {
    res.json({ status: 'GATEWAY_UP', timestamp: new Date().toISOString() });
});

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
    console.log(`AhmedBaba API Gateway unified on port ${PORT}`);
});
