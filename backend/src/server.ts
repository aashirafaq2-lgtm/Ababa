import express, { Request, Response } from 'express';
import http from 'http';
import { WebSocketServer, WebSocket } from 'ws';
import cors from 'cors';
import dotenv from 'dotenv';
import axios from 'axios';
import { initializeDatabase } from './config/database';

dotenv.config();

const app = express();
const server = http.createServer(app);
const wss = new WebSocketServer({ server });

app.use(cors());
app.use(express.json());

const PORT = process.env.PORT || 5000;

// Internal Connection Memory Mesh
const connections = new Map<string, WebSocket>();

// 1. 1688 Open Platform Proxy Endpoint
app.get('/v1/products/:id', async (req: Request, res: Response) => {
    const { id } = req.params;
    try {
        res.json({
            id: id,
            supplier_id: "SUP_88921",
            category_path: ["Industrial", "Electrical", "Cables"],
            wholesale_tiers: [
                { min_quantity: 2, max_quantity: 9, unit_price_cny: 150.00, unit_price_cny_usd: "USD 21.00" },
                { min_quantity: 10, max_quantity: 99, unit_price_cny: 130.00, unit_price_cny_usd: "USD 18.20" },
                { min_quantity: 100, max_quantity: null, unit_price_cny: 110.00, unit_price_cny_usd: "USD 15.40" }
            ],
            skus: [
                { sku_uuid: "SKU-001-BLK", attributes: { "color": "Black", "length": "5m" }, inventory_count: 5000 },
                { sku_uuid: "SKU-001-RED", attributes: { "color": "Red", "length": "5m" }, inventory_count: 2400 }
            ]
        });
    } catch (error) {
        res.status(502).json({ error: "Failed to fetch from upstream API fabrics", code: "UPSTREAM_FAILURE" });
    }
});

app.get('/v1/products/health', (req: Request, res: Response) => {
    res.json({ status: "UP", timestamp: new Date().toISOString() });
});

// Stage 4: My China Box & Futian Real Backend Routes
import authRoutes from './modules/auth/auth.routes';
import myChinaBoxRoutes from './modules/my_china_box/my_china_box.routes';
import futianRoutes from './modules/futian/futian.routes';
import adminRoutes from './modules/admin/admin.routes';
import notificationRoutes from './modules/notifications/notifications.routes';
import chatbotRoutes from './modules/chatbot/chatbot.routes';

app.use('/api/v1/auth/china-box', authRoutes);
app.use('/api/v1/my-china-box', myChinaBoxRoutes);
app.use('/api/v1/futian', futianRoutes);
app.use('/api/v1/admin', adminRoutes);
app.use('/api/v1/notifications', notificationRoutes);
app.use('/api/v1/chatbot', chatbotRoutes);

// Health check
app.get('/api/v1/health', (req: Request, res: Response) => {
  res.json({ status: 'UP', timestamp: new Date().toISOString(), version: '4.0.0' });
});

// 2. Real-Time WebSocket Mesh Implementation
wss.on('connection', (ws: WebSocket, req: http.IncomingMessage) => {
    const url = new URL(req.url || '', `http://${req.headers.host}`);
    const companyId = url.searchParams.get('company_id');

    if (companyId) {
        connections.set(companyId, ws);
        console.log(`Node Mesh: Connected Company ${companyId}`);
    }

    ws.on('message', (message: string) => {
        try {
            const data = JSON.parse(message);
            if (data.type === 'INVOICE_MODIFICATION') {
                const targetId = data.target_company_id;
                const targetWs = connections.get(targetId);
                if (targetWs && targetWs.readyState === WebSocket.OPEN) {
                    targetWs.send(JSON.stringify({
                        type: 'transactional_card',
                        sender_id: companyId,
                        content: {
                            id: data.invoice_id,
                            unit_price: data.new_price,
                            shipping_method: data.shipping_method,
                            volume: data.volume,
                            total: (data.new_price * data.volume).toFixed(2)
                        }
                    }));
                }
            }
            if (data.type === 'contract_approval') {
                console.log(`Contract System: Order Locked for ID ${data.contract_id}`);
            }
        } catch (e) {
            console.error('Mesh Protocol Error:', e);
        }
    });

    ws.on('close', () => {
        if (companyId) connections.delete(companyId);
    });
});

// Initialize PostgreSQL and start server
initializeDatabase().then(() => {
  server.listen(PORT, () => {
    console.log(`AhmedBaba Mesh Gateway operational on port ${PORT}`);
  });
});
