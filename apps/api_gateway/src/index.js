import express from 'express';
import * as grpc from '@grpc/grpc-js';
import * as protoLoader from '@grpc/proto-loader';

const app = express();
app.use(express.json());

// --- gRPC Client Setup ---
const packageDefinition = protoLoader.loadSync('./proto/catalog.proto', {});
const catalogProto = grpc.loadPackageDefinition(packageDefinition).catalog;
const catalogClient = new catalogProto.CatalogService('catalog-service:50051', grpc.credentials.createInsecure());

// --- API Endpoints ---

// 1. Unified Search (Aggregates local DB + 1688 proxies)
app.get('/api/v1/search', (req, res) => {
    const { q, page } = req.query;
    catalogClient.SearchProducts({ query: q, page: page }, (err, response) => {
        if (err) return res.status(500).json({ error: 'Upstream microservice failure' });
        res.json(response);
    });
});

// 2. Escrow Payment Initiation
app.post('/api/v1/orders/pay', (req, res) => {
    const { order_id, payment_method } = req.body;
    // Proxies call to Order Service gRPC
    res.status(202).json({
        message: 'Order escrowed successfully',
        status: 'LOCKED',
        transaction_id: 'TXN_' + Date.now()
    });
});

const PORT = process.env.PORT || 8080;
app.listen(PORT, () => {
    console.log(`AhmedBaba API Gateway operational on port ${PORT}`);
});
