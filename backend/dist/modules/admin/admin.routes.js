"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const auth_1 = require("../../middleware/auth");
const audit_1 = require("../../middleware/audit");
const futian_routes_1 = require("../futian/futian.routes");
const pg_service_1 = require("../../database/pg_service");
const router = (0, express_1.Router)();
router.use(auth_1.authenticateToken);
router.use((0, auth_1.requireRole)('ADMIN', 'STAFF'));
// 1. Overview Metrics
router.get('/overview-metrics', async (req, res) => {
    try {
        const metrics = await (0, pg_service_1.getAdminOverviewMetrics)();
        res.json({ metrics, timestamp: new Date().toISOString() });
    }
    catch (e) {
        res.status(500).json({ error: 'Server error' });
    }
});
// 2. Customer Management
router.get('/customers', async (req, res) => {
    try {
        const { q } = req.query;
        const rows = await (0, pg_service_1.getAllCustomers)(q);
        const customers = rows.map((u) => ({
            id: u.id, identity: u.identity, fullName: u.full_name || 'Customer',
            phone: u.phone || '', email: u.email || '', boxCode: u.box_code || '',
            status: u.status, createdAt: u.created_at,
        }));
        res.json({ customers });
    }
    catch (e) {
        res.status(500).json({ error: 'Server error' });
    }
});
// 3. Suspend / Reactivate Customer
router.patch('/customers/:id/status', async (req, res) => {
    try {
        const { id } = req.params;
        const { status } = req.body;
        if (!['ACTIVE', 'SUSPENDED'].includes(status))
            return res.status(400).json({ error: 'Status must be ACTIVE or SUSPENDED', code: 'INVALID_STATUS' });
        const updated = await (0, pg_service_1.updateUserStatus)(id, status);
        if (!updated)
            return res.status(404).json({ error: 'Customer not found', code: 'NOT_FOUND' });
        await (0, audit_1.recordAdminAudit)(req.user, 'CUSTOMER_STATUS_CHANGE', 'USER', id, {}, { status });
        res.json({ message: 'Customer status updated', customer: updated });
    }
    catch (e) {
        res.status(500).json({ error: 'Server error' });
    }
});
// 4. Package Management - List
router.get('/packages', async (req, res) => {
    try {
        const { status, q } = req.query;
        const pkgs = await (0, pg_service_1.getAllPackages)(status, q);
        res.json({ packages: pkgs });
    }
    catch (e) {
        res.status(500).json({ error: 'Server error' });
    }
});
// 5. Create Package Arrival at Warehouse
router.post('/packages', async (req, res) => {
    try {
        const { customerId, boxNumber, trackingNumber, dimensions, weightKg, volumeCbm, notes, photos } = req.body;
        if (!customerId || !boxNumber || !trackingNumber)
            return res.status(400).json({ error: 'Customer ID, box number, and tracking number are required', code: 'INVALID_DATA' });
        const wh = await (0, pg_service_1.getActiveWarehouse)();
        if (!wh)
            return res.status(500).json({ error: 'No active warehouse configured', code: 'NO_WAREHOUSE' });
        const newPkg = await (0, pg_service_1.createPackage)({
            customer_id: customerId, warehouse_id: wh.id,
            box_number: boxNumber, tracking_number: trackingNumber,
            dimensions: dimensions || '40 x 30 x 20 cm',
            weight_kg: parseFloat(weightKg) || 1.0,
            volume_cbm: parseFloat(volumeCbm) || 0.024,
            notes: notes || '',
            photos: Array.isArray(photos) ? photos : [],
        });
        await (0, audit_1.recordAdminAudit)(req.user, 'PACKAGE_CHECK_IN', 'PACKAGE', newPkg.id, null, { box_number: boxNumber, tracking_number: trackingNumber, weight_kg: newPkg.weight_kg });
        await (0, pg_service_1.createNotification)({ customer_id: customerId, title: 'New Package Arrived', message: `Package ${boxNumber} (${newPkg.weight_kg} kg) has arrived at Guangzhou warehouse.`, type: 'PACKAGE_RECEIVED', related_id: boxNumber });
        res.status(201).json({ message: 'Package checked into warehouse', package: newPkg });
    }
    catch (e) {
        console.error(e);
        res.status(500).json({ error: 'Server error' });
    }
});
// 6. Update Package Status or Details
router.patch('/packages/:id', async (req, res) => {
    try {
        const { id } = req.params;
        const { status, weightKg, volumeCbm, notes } = req.body;
        const updated = await (0, pg_service_1.updatePackage)(id, { status, weight_kg: weightKg ? parseFloat(weightKg) : undefined, volume_cbm: volumeCbm ? parseFloat(volumeCbm) : undefined, notes });
        if (!updated)
            return res.status(404).json({ error: 'Package not found', code: 'NOT_FOUND' });
        await (0, audit_1.recordAdminAudit)(req.user, 'PACKAGE_UPDATE', 'PACKAGE', id, {}, { status, weight_kg: updated.weight_kg, volume_cbm: updated.volume_cbm });
        res.json({ message: 'Package updated successfully', package: updated });
    }
    catch (e) {
        res.status(500).json({ error: 'Server error' });
    }
});
// 7. Futian Orders - List (Admin)
router.get('/futian/orders', async (req, res) => {
    try {
        const { status, q } = req.query;
        const orders = await (0, pg_service_1.getAllFutianOrders)(status, q);
        res.json({ orders: orders.map((o) => {
                const meta = futian_routes_1.STATUS_MAP[o.status] || futian_routes_1.STATUS_MAP.UNDER_REVIEW;
                return { ...o, statusAr: meta.ar, statusEn: meta.en, statusColorHex: meta.color, statusBgHex: meta.bg };
            }) });
    }
    catch (e) {
        res.status(500).json({ error: 'Server error' });
    }
});
// 8. Futian Pricing Desk
router.patch('/futian/orders/:id/pricing', async (req, res) => {
    try {
        const { id } = req.params;
        const unitPriceRaw = req.body.unitPriceUsd ?? req.body.unit_price_usd;
        const { notes } = req.body;
        const order = await (0, pg_service_1.getFutianOrderById)(id);
        if (!order)
            return res.status(404).json({ error: 'Order not found', code: 'NOT_FOUND' });
        const parsedUnitPrice = parseFloat(unitPriceRaw);
        if (isNaN(parsedUnitPrice) || parsedUnitPrice <= 0)
            return res.status(400).json({ error: 'Valid positive unit price is required', code: 'INVALID_PRICE' });
        const oldStatus = order.status;
        const updated = await (0, pg_service_1.updateFutianOrderPricing)(id, parsedUnitPrice, order.quantity);
        await (0, pg_service_1.addOrderStatusHistory)({
            order_id: order.order_id, from_status: oldStatus, to_status: 'APPROVAL_PENDING',
            changed_by_user_id: req.user.id,
            changed_by_name: `Staff: ${req.user.identity}`,
            notes: notes || `Quoted unit price: $${parsedUnitPrice.toFixed(2)} USD. Total: $${(parsedUnitPrice * order.quantity).toFixed(2)} USD`,
        });
        await (0, audit_1.recordAdminAudit)(req.user, 'ORDER_PRICING_SET', 'FUTIAN_ORDER', order.order_id, { status: oldStatus }, { unit_price_usd: parsedUnitPrice, status: 'APPROVAL_PENDING' });
        await (0, pg_service_1.createNotification)({
            customer_id: order.customer_id,
            title: 'Price Quote Ready for Approval',
            message: `Order ${order.order_id} (${order.product_name_en}) has been quoted at $${(parsedUnitPrice * order.quantity).toFixed(2)} USD. Please review and approve.`,
            type: 'ORDER_PRICED', related_id: order.order_id,
        });
        res.json({ message: 'Quotation set successfully. Order advanced to APPROVAL_PENDING', order: updated });
    }
    catch (e) {
        console.error(e);
        res.status(500).json({ error: 'Server error' });
    }
});
// 9. Advance Futian Order Status (Admin)
router.patch('/futian/orders/:id/status', async (req, res) => {
    try {
        const { id } = req.params;
        const { status, notes } = req.body;
        const validStatuses = ['UNDER_REVIEW', 'PRICE_PENDING', 'APPROVAL_PENDING', 'PURCHASED', 'SHIPPED', 'ARRIVED', 'CANCELLED'];
        if (!status || !validStatuses.includes(status))
            return res.status(400).json({ error: `Status must be one of: ${validStatuses.join(', ')}`, code: 'INVALID_STATUS' });
        const order = await (0, pg_service_1.getFutianOrderById)(id);
        if (!order)
            return res.status(404).json({ error: 'Order not found', code: 'NOT_FOUND' });
        const oldStatus = order.status;
        const updated = await (0, pg_service_1.updateFutianOrderStatus)(id, status);
        await (0, pg_service_1.addOrderStatusHistory)({
            order_id: order.order_id, from_status: oldStatus, to_status: status,
            changed_by_user_id: req.user.id,
            changed_by_name: `Admin/Staff: ${req.user.identity}`,
            notes: notes || `Status updated from ${oldStatus} to ${status}`,
        });
        await (0, audit_1.recordAdminAudit)(req.user, 'ORDER_STATUS_CHANGE', 'FUTIAN_ORDER', order.order_id, { status: oldStatus }, { status, notes });
        await (0, pg_service_1.createNotification)({
            customer_id: order.customer_id,
            title: 'Order Status Changed',
            message: `Order ${order.order_id} is now ${futian_routes_1.STATUS_MAP[status]?.en || status}.`,
            type: 'ORDER_STATUS_CHANGED', related_id: order.order_id,
        });
        res.json({ message: `Order advanced to ${status}`, order: updated });
    }
    catch (e) {
        res.status(500).json({ error: 'Server error' });
    }
});
// 10. Shipping Rates Management
router.get('/shipping-rates', async (req, res) => {
    try {
        const rates = await (0, pg_service_1.getAllShippingMethods)();
        res.json({ rates, shippingMethods: rates });
    }
    catch (e) {
        res.status(500).json({ error: 'Server error' });
    }
});
const handleUpdateShippingRate = async (req, res) => {
    try {
        const { id } = req.params;
        const ratePerKg = req.body.ratePerKg ?? req.body.rate_per_kg;
        const ratePerCbm = req.body.ratePerCbm ?? req.body.rate_per_cbm;
        const baseFee = req.body.baseFee ?? req.body.base_fee;
        const minimumFee = req.body.minimumFee ?? req.body.minimum_fee;
        const estimatedDays = req.body.estimatedDays ?? req.body.estimated_days;
        const isActive = req.body.isActive ?? req.body.is_active;
        const updated = await (0, pg_service_1.updateShippingMethod)(id, {
            rate_per_kg: ratePerKg !== undefined ? parseFloat(ratePerKg) : undefined,
            rate_per_cbm: ratePerCbm !== undefined ? parseFloat(ratePerCbm) : undefined,
            base_fee: baseFee !== undefined ? parseFloat(baseFee) : undefined,
            minimum_fee: minimumFee !== undefined ? parseFloat(minimumFee) : undefined,
            estimated_days: estimatedDays,
            is_active: isActive !== undefined ? Boolean(isActive) : undefined,
        });
        if (!updated)
            return res.status(404).json({ error: 'Shipping method not found', code: 'NOT_FOUND' });
        await (0, audit_1.recordAdminAudit)(req.user, 'SHIPPING_RATE_UPDATE', 'SHIPPING_METHOD', id, {}, updated);
        res.json({ message: 'Shipping rate tariff updated successfully', rate: updated, shippingMethod: updated });
    }
    catch (e) {
        res.status(500).json({ error: 'Server error' });
    }
};
router.put('/shipping-rates/:id', handleUpdateShippingRate);
router.patch('/shipping-rates/:id', handleUpdateShippingRate);
// 11. Audit Logs
router.get('/audit-logs', async (req, res) => {
    try {
        const { limit, q } = req.query;
        const logs = await (0, pg_service_1.getAdminAuditLogs)(parseInt(limit) || 100, q);
        res.json({ logs, auditLogs: logs });
    }
    catch (e) {
        res.status(500).json({ error: 'Server error' });
    }
});
exports.default = router;
