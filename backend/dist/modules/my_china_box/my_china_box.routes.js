"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const auth_1 = require("../../middleware/auth");
const pg_service_1 = require("../../database/pg_service");
const router = (0, express_1.Router)();
// 1. Warehouse Address
router.get('/warehouse-address', async (req, res) => {
    try {
        const wh = await (0, pg_service_1.getActiveWarehouse)();
        if (!wh)
            return res.status(404).json({ error: 'Warehouse not configured', code: 'NOT_FOUND' });
        res.json({
            titleEn: wh.name_en, titleAr: wh.name_ar,
            addressEn: wh.address_en, addressAr: wh.address_ar,
            postalCode: wh.postal_code, phone: wh.contact_phone, mapUrl: wh.map_url,
        });
    }
    catch (e) {
        res.status(500).json({ error: 'Server error' });
    }
});
// 2. Customer Dashboard Aggregates
router.get('/dashboard', auth_1.authenticateToken, async (req, res) => {
    try {
        const customerId = req.user.id;
        const [packages, profile, wh] = await Promise.all([
            (0, pg_service_1.getPackagesByCustomer)(customerId),
            (0, pg_service_1.findProfileByUserId)(customerId),
            (0, pg_service_1.getActiveWarehouse)(),
        ]);
        const consolidationCount = packages.filter((p) => p.status === 'READY_FOR_CONSOLIDATION').length;
        const totalWeight = packages.reduce((acc, p) => acc + parseFloat(p.weight_kg), 0);
        const totalCbm = packages.reduce((acc, p) => acc + parseFloat(p.volume_cbm), 0);
        res.json({
            boxCode: profile?.box_code || req.user?.box_code || 'AB-0000',
            packageCount: packages.length,
            readyForConsolidationCount: consolidationCount,
            totalWeightKg: parseFloat(totalWeight.toFixed(2)),
            totalVolumeCbm: parseFloat(totalCbm.toFixed(4)),
            warehouse: wh ? {
                titleEn: wh.name_en, titleAr: wh.name_ar,
                addressEn: wh.address_en, addressAr: wh.address_ar,
                postalCode: wh.postal_code, phone: wh.contact_phone,
            } : null,
        });
    }
    catch (e) {
        res.status(500).json({ error: 'Server error' });
    }
});
// 3. Customer Stored Packages (Strict Customer Isolation)
router.get('/packages', auth_1.authenticateToken, async (req, res) => {
    try {
        const customerId = req.user.id;
        const statusFilter = req.query.status;
        const pkgs = await (0, pg_service_1.getPackagesByCustomer)(customerId, statusFilter);
        res.json(pkgs.map((p) => ({
            id: p.id, boxNumber: p.box_number, trackingNumber: p.tracking_number,
            dimensions: p.dimensions, weightKg: parseFloat(p.weight_kg),
            volumeCbm: parseFloat(p.volume_cbm), arrivalDate: p.arrival_date,
            status: p.status, photos: p.photos, notes: p.notes,
        })));
    }
    catch (e) {
        res.status(500).json({ error: 'Server error' });
    }
});
// 4. Shipping Methods & Rates
router.get('/shipping-options', async (req, res) => {
    try {
        const weightKg = parseFloat(req.query.weight) || 0;
        const methods = await (0, pg_service_1.getActiveShippingMethods)();
        res.json(methods.map((m) => {
            const rateKg = parseFloat(m.rate_per_kg);
            const rateCbm = parseFloat(m.rate_per_cbm);
            const baseFee = parseFloat(m.base_fee);
            const minFee = parseFloat(m.minimum_fee);
            const total = m.type === 'AIR' ? baseFee + rateKg * weightKg : baseFee + rateCbm * (weightKg / 167);
            return {
                id: m.id, type: m.type.toLowerCase(),
                titleEn: m.title_en, titleAr: m.title_ar,
                subtitleEn: m.subtitle_en, subtitleAr: m.subtitle_ar,
                estimatedDays: m.estimated_days, ratePerKg: rateKg,
                ratePerCbm: rateCbm, baseFee, minimumFee: minFee,
                calculatedTotalUsd: parseFloat(Math.max(total, minFee).toFixed(2)),
            };
        }));
    }
    catch (e) {
        res.status(500).json({ error: 'Server error' });
    }
});
// 5. Submit Package Consolidation Request
router.post('/consolidate', auth_1.authenticateToken, async (req, res) => {
    try {
        const customerId = req.user.id;
        const { packageIds, shippingMethodId, destinationCountry, destinationCity, deliveryAddress, deliveryType, notes } = req.body;
        if (!packageIds || !Array.isArray(packageIds) || packageIds.length === 0)
            return res.status(400).json({ error: 'At least one package must be selected', code: 'NO_PACKAGES_SELECTED' });
        // Verify all packages belong to this customer
        const customerPackages = await (0, pg_service_1.getPackagesByCustomer)(customerId);
        const selectedPackages = customerPackages.filter((p) => packageIds.includes(p.id));
        if (selectedPackages.length !== packageIds.length)
            return res.status(403).json({ error: 'Data Isolation Violation: Package does not belong to your account', code: 'FORBIDDEN_PACKAGE_SELECTION' });
        const allMethods = await (0, pg_service_1.getAllShippingMethods)();
        const shippingMethod = allMethods.find((m) => m.id === shippingMethodId) || allMethods[0];
        if (!shippingMethod)
            return res.status(400).json({ error: 'No active shipping method available', code: 'NO_SHIPPING_METHOD' });
        const totalWeight = selectedPackages.reduce((acc, p) => acc + parseFloat(p.weight_kg), 0);
        const totalCbm = selectedPackages.reduce((acc, p) => acc + parseFloat(p.volume_cbm), 0);
        const rateKg = parseFloat(shippingMethod.rate_per_kg);
        const rateCbm = parseFloat(shippingMethod.rate_per_cbm);
        const baseFee = parseFloat(shippingMethod.base_fee);
        const minFee = parseFloat(shippingMethod.minimum_fee);
        const cost = shippingMethod.type === 'AIR' ? baseFee + rateKg * totalWeight : baseFee + rateCbm * totalCbm;
        const newCons = await (0, pg_service_1.createConsolidationOrder)({
            customer_id: customerId, shipping_method_id: shippingMethod.id,
            destination_country: destinationCountry || 'Libya', destination_city: destinationCity || 'Tripoli',
            delivery_address: deliveryAddress || 'Port Pickup', delivery_type: deliveryType || 'DOORSTEP',
            total_weight_kg: parseFloat(totalWeight.toFixed(2)), total_cbm: parseFloat(totalCbm.toFixed(4)),
            shipping_cost_usd: parseFloat(Math.max(cost, minFee).toFixed(2)),
            package_ids: packageIds, notes: notes || '',
        });
        // Update package statuses to UNDER_REVIEW
        await (0, pg_service_1.updatePackagesBulkStatus)(packageIds, 'UNDER_REVIEW');
        // Notify customer
        await (0, pg_service_1.createNotification)({
            customer_id: customerId,
            title: 'Consolidation Request Submitted',
            message: `Consolidation ${newCons.order_number} for ${selectedPackages.length} packages has been received for review.`,
            type: 'CONSOLIDATION_REQUESTED',
            related_id: newCons.order_number,
        });
        res.status(201).json({ message: 'Consolidation request submitted successfully', consolidation: newCons });
    }
    catch (e) {
        console.error('Consolidation error:', e);
        res.status(500).json({ error: 'Server error' });
    }
});
// 6. Live Shipment Milestone Tracking
router.get('/tracking/:trackingNumber', async (req, res) => {
    try {
        const { trackingNumber } = req.params;
        let shipment = await (0, pg_service_1.getShipmentByTrackingNumber)(trackingNumber);
        if (!shipment)
            shipment = await (0, pg_service_1.getFirstShipment)();
        if (!shipment)
            return res.status(404).json({ error: 'No shipments found', code: 'NOT_FOUND' });
        const milestones = await (0, pg_service_1.getTrackingMilestones)(shipment.tracking_number);
        res.json({
            trackingNumber: shipment.tracking_number, orderId: shipment.order_id,
            statusEn: shipment.current_status_en, statusAr: shipment.current_status_ar,
            shippingMethod: shipment.shipping_method, weightKg: parseFloat(shipment.weight_kg),
            totalCostUsd: parseFloat(shipment.total_cost_usd), packageCount: shipment.package_count,
            milestones: milestones.map((m) => ({
                titleEn: m.title_en, titleAr: m.title_ar, location: m.location,
                timestamp: m.timestamp_text, isCompleted: m.state === 'COMPLETED', isCurrent: m.state === 'CURRENT',
            })),
        });
    }
    catch (e) {
        res.status(500).json({ error: 'Server error' });
    }
});
exports.default = router;
