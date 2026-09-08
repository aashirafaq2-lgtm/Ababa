"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.STATUS_MAP = void 0;
const express_1 = require("express");
const auth_1 = require("../../middleware/auth");
const pg_service_1 = require("../../database/pg_service");
const router = (0, express_1.Router)();
exports.STATUS_MAP = {
    UNDER_REVIEW: { ar: 'بانتظار المراجعة', en: 'Awaiting Review', color: '#FF5500', bg: '#FFF1EB' },
    PRICE_PENDING: { ar: 'بانتظار التسعير', en: 'Awaiting Pricing', color: '#D97706', bg: '#FEFCE8' },
    APPROVAL_PENDING: { ar: 'بانتظار الموافقة', en: 'Awaiting Approval', color: '#9333EA', bg: '#FAF5FF' },
    PURCHASED: { ar: 'تم الشراء', en: 'Purchased', color: '#2563EB', bg: '#EFF6FF' },
    SHIPPED: { ar: 'تم الشحن', en: 'Shipped', color: '#0D9488', bg: '#F0FDFA' },
    ARRIVED: { ar: 'وصل إلى المخزن', en: 'Arrived at Warehouse', color: '#16A34A', bg: '#F0FDF4' },
    CANCELLED: { ar: 'ملغي', en: 'Cancelled', color: '#EF4444', bg: '#FEF2F2' },
};
function mapOrder(o) {
    const meta = exports.STATUS_MAP[o.status] || exports.STATUS_MAP.UNDER_REVIEW;
    return {
        id: o.id, orderId: o.order_id,
        productNameAr: o.product_name_ar, productNameEn: o.product_name_en,
        siteNameAr: o.site_name_ar, siteNameEn: o.site_name_en, siteType: o.site_type,
        quantity: o.quantity, status: o.status,
        statusAr: meta.ar, statusEn: meta.en, statusColorHex: meta.color, statusBgHex: meta.bg,
        imageAsset: o.image_asset, visualType: o.visual_type,
        declaredValueUsd: parseFloat(o.declared_value_usd),
        unitPriceUsd: parseFloat(o.unit_price_usd),
        totalPriceUsd: parseFloat(o.total_price_usd),
        createdAt: o.created_at, updatedAt: o.updated_at,
    };
}
// 1. Get Customer Orders
router.get('/orders', auth_1.authenticateToken, async (req, res) => {
    try {
        const customerId = req.user.id;
        const { status, q } = req.query;
        const [metrics, orders] = await Promise.all([
            (0, pg_service_1.getFutianMetrics)(customerId),
            (0, pg_service_1.getFutianOrdersByCustomer)(customerId, status, q),
        ]);
        res.json({ metrics, orders: orders.map(mapOrder) });
    }
    catch (e) {
        console.error(e);
        res.status(500).json({ error: 'Server error' });
    }
});
// 2. Get Single Order with History
router.get('/orders/:orderId', auth_1.authenticateToken, async (req, res) => {
    try {
        const customerId = req.user.id;
        const { orderId } = req.params;
        const isAdminOrStaff = req.user.role === 'ADMIN' || req.user.role === 'STAFF';
        const order = await (0, pg_service_1.getFutianOrderById)(orderId, isAdminOrStaff ? undefined : customerId);
        if (!order)
            return res.status(404).json({ error: 'Order not found or unauthorized', code: 'ORDER_NOT_FOUND' });
        const meta = exports.STATUS_MAP[order.status] || exports.STATUS_MAP.UNDER_REVIEW;
        const history = await (0, pg_service_1.getOrderStatusHistory)(order.order_id);
        res.json({
            id: order.id, orderId: order.order_id,
            productNameAr: order.product_name_ar, productNameEn: order.product_name_en,
            productUrl: order.product_url,
            siteNameAr: order.site_name_ar, siteNameEn: order.site_name_en, siteType: order.site_type,
            quantity: order.quantity, destinationCountry: order.destination_country,
            declaredValueUsd: parseFloat(order.declared_value_usd),
            unitPriceUsd: parseFloat(order.unit_price_usd),
            totalPriceUsd: parseFloat(order.total_price_usd),
            status: order.status, statusAr: meta.ar, statusEn: meta.en,
            statusColorHex: meta.color, statusBgHex: meta.bg,
            notes: order.notes, createdAt: order.created_at, updatedAt: order.updated_at,
            timeline: history.map((h) => ({
                fromStatus: h.from_status, toStatus: h.to_status,
                toStatusLabelEn: exports.STATUS_MAP[h.to_status]?.en || h.to_status,
                toStatusLabelAr: exports.STATUS_MAP[h.to_status]?.ar || h.to_status,
                changedByName: h.changed_by_name, notes: h.notes, timestamp: h.created_at,
            })),
        });
    }
    catch (e) {
        res.status(500).json({ error: 'Server error' });
    }
});
// 3. Create New Futian Order
router.post('/orders', auth_1.authenticateToken, async (req, res) => {
    try {
        const customerId = req.user.id;
        const { productName, productUrl, quantity, destinationCountry, declaredValueUsd, notes, siteType } = req.body;
        if (!productName || typeof productName !== 'string' || productName.trim().length === 0)
            return res.status(400).json({ error: 'Product name is required', code: 'INVALID_PRODUCT_NAME' });
        const siteMap = {
            usa: { en: 'America', ar: 'أمريكا' },
            turkey: { en: 'Turkey', ar: 'تركيا' },
            shein: { en: 'SHEIN', ar: 'SHEIN' },
            china: { en: 'China', ar: 'الصين' },
        };
        const site = siteMap[siteType] || siteMap.china;
        const newOrder = await (0, pg_service_1.createFutianOrder)({
            customer_id: customerId,
            product_name_en: productName.trim(),
            product_name_ar: productName.trim(),
            product_url: productUrl || '',
            site_name_en: site.en,
            site_name_ar: site.ar,
            site_type: siteType || 'china',
            quantity: Math.max(1, parseInt(quantity) || 1),
            destination_country: destinationCountry || 'Libya',
            declared_value_usd: parseFloat(declaredValueUsd) || 0.0,
            notes: notes || '',
        });
        await (0, pg_service_1.addOrderStatusHistory)({
            order_id: newOrder.order_id,
            to_status: 'UNDER_REVIEW',
            changed_by_user_id: customerId,
            changed_by_name: req.user?.identity || 'Customer',
            notes: 'Order placed by customer via Futian portal',
        });
        await (0, pg_service_1.createNotification)({
            customer_id: customerId,
            title: 'New Order Received',
            message: `Order ${newOrder.order_id} has been received and submitted for review.`,
            type: 'ORDER_CREATED',
            related_id: newOrder.order_id,
        });
        res.status(201).json({ message: 'Order created successfully', order: newOrder });
    }
    catch (e) {
        console.error(e);
        res.status(500).json({ error: 'Server error' });
    }
});
// 4. Customer Approves Pricing
router.patch('/orders/:orderId/approve', auth_1.authenticateToken, async (req, res) => {
    try {
        const customerId = req.user.id;
        const { orderId } = req.params;
        const order = await (0, pg_service_1.getFutianOrderById)(orderId, customerId);
        if (!order)
            return res.status(404).json({ error: 'Order not found', code: 'ORDER_NOT_FOUND' });
        if (order.status !== 'APPROVAL_PENDING')
            return res.status(400).json({ error: `Cannot approve order with status ${order.status}`, code: 'INVALID_STATUS' });
        const updated = await (0, pg_service_1.updateFutianOrderStatus)(order.id, 'PURCHASED');
        await (0, pg_service_1.addOrderStatusHistory)({
            order_id: order.order_id, from_status: 'APPROVAL_PENDING', to_status: 'PURCHASED',
            changed_by_user_id: customerId, changed_by_name: req.user?.identity || 'Customer',
            notes: 'Customer approved pricing quotation and authorized purchase',
        });
        res.json({ message: 'Quotation approved successfully. Order is now queued for purchasing.', order: updated });
    }
    catch (e) {
        res.status(500).json({ error: 'Server error' });
    }
});
exports.default = router;
