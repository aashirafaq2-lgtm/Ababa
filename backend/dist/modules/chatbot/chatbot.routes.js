"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const auth_1 = require("../../middleware/auth");
const pg_service_1 = require("../../database/pg_service");
const router = (0, express_1.Router)();
router.use(auth_1.authenticateToken);
router.post('/message', async (req, res) => {
    try {
        const { message } = req.body;
        if (!message || typeof message !== 'string') {
            return res.status(400).json({ error: 'Message is required', code: 'INVALID_INPUT' });
        }
        const customerId = req.user.id;
        const lower = message.toLowerCase();
        // 1. Packages inquiry - ISOLATED to authenticated customer only
        if (lower.includes('package') || lower.includes('طرد') || lower.includes('شحنة') || lower.includes('track')) {
            const pkgs = await (0, pg_service_1.getPackagesByCustomer)(customerId);
            if (!pkgs || pkgs.length === 0) {
                return res.json({
                    reply: 'You currently have no packages in your China Box warehouse. Once your parcels arrive at our Guangzhou Hub, they will appear here.',
                });
            }
            const summary = pkgs.map((p) => `• Box #${p.box_number} (Tracking: ${p.tracking_number}, Status: ${p.status}, Weight: ${p.weight_kg} kg)`).join('\n');
            return res.json({
                reply: `Here are your current packages:\n${summary}\n\nYou can consolidate ready packages directly in My China Box.`,
            });
        }
        // 2. Futian orders inquiry - ISOLATED to authenticated customer only
        if (lower.includes('futian') || lower.includes('order') || lower.includes('طلب') || lower.includes('فوتيان')) {
            const orders = await (0, pg_service_1.getFutianOrdersByCustomer)(customerId);
            if (!orders || orders.length === 0) {
                return res.json({
                    reply: 'You have no active Futian purchase orders yet. You can submit a new purchase request via "Add New Order" on the home screen.',
                });
            }
            const summary = orders.slice(0, 5).map((o) => `• ${o.order_id}: ${o.product_name_en} - Status: ${o.status} ($${o.total_price_usd})`).join('\n');
            return res.json({
                reply: `Here are your recent Futian orders:\n${summary}`,
            });
        }
        // 3. Shipping rates inquiry
        if (lower.includes('rate') || lower.includes('price') || lower.includes('سعر') || lower.includes('تكلفة') || lower.includes('shipping')) {
            const rates = await (0, pg_service_1.getAllShippingMethods)();
            const summary = rates.map((r) => `• ${r.title_en} (${r.estimated_days}): $${r.rate_per_kg}/kg (Base fee: $${r.base_fee})`).join('\n');
            return res.json({
                reply: `Current A.BABA Shipping Rates:\n${summary}\n\nDeliveries are handled via direct air & sea cargo to Libyan hubs.`,
            });
        }
        // 4. Warehouse information
        if (lower.includes('warehouse') || lower.includes('address') || lower.includes('عنوان') || lower.includes('مستودع')) {
            const wh = await (0, pg_service_1.getActiveWarehouse)();
            if (wh) {
                return res.json({
                    reply: `A.BABA China Receiving Hub:\n${wh.name_en}\n${wh.address_en}\nPostal Code: ${wh.postal_code}\nContact: ${wh.contact_phone}\n\nPlease make sure your Box Code (${req.user.box_code}) is attached to your package shipping label.`,
                });
            }
        }
        // Default supportive AI answer with human escalation
        return res.json({
            reply: 'Thank you for reaching out to A.BABA Support! I can assist you with your Packages, Futian Orders, Shipping Tariffs, or Warehouse address. If you need dedicated agent assistance, our support team is available 24/7.',
        });
    }
    catch (error) {
        console.error('Chatbot error:', error);
        res.status(500).json({ error: 'Failed to process message', code: 'SERVER_ERROR' });
    }
});
exports.default = router;
