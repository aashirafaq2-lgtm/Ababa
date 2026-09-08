import { Router, Response } from 'express';
import { authenticateToken, AuthenticatedRequest } from '../../middleware/auth';
import {
  getActiveWarehouse, getPackagesByCustomer, getActiveShippingMethods,
  getShippingMethodById, getAllShippingMethods, createConsolidationOrder,
  updatePackagesBulkStatus, getShipmentByTrackingNumber, getFirstShipment,
  getTrackingMilestones, findProfileByUserId, createNotification
} from '../../database/pg_service';

const router = Router();

// 1. Warehouse Address
router.get('/warehouse-address', async (req, res: Response) => {
  try {
    const wh = await getActiveWarehouse();
    if (!wh) return res.status(404).json({ error: 'Warehouse not configured', code: 'NOT_FOUND' });
    res.json({
      titleEn: wh.name_en, titleAr: wh.name_ar,
      addressEn: wh.address_en, addressAr: wh.address_ar,
      postalCode: wh.postal_code, phone: wh.contact_phone, mapUrl: wh.map_url,
    });
  } catch (e) { res.status(500).json({ error: 'Server error' }); }
});

// 2. Customer Dashboard Aggregates
router.get('/dashboard', authenticateToken, async (req: AuthenticatedRequest, res: Response) => {
  try {
    const customerId = req.user!.id;
    const [packages, profile, wh] = await Promise.all([
      getPackagesByCustomer(customerId),
      findProfileByUserId(customerId),
      getActiveWarehouse(),
    ]);
    const consolidationCount = packages.filter((p: any) => p.status === 'READY_FOR_CONSOLIDATION').length;
    const totalWeight = packages.reduce((acc: number, p: any) => acc + parseFloat(p.weight_kg), 0);
    const totalCbm = packages.reduce((acc: number, p: any) => acc + parseFloat(p.volume_cbm), 0);
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
  } catch (e) { res.status(500).json({ error: 'Server error' }); }
});

// 3. Customer Stored Packages (Strict Customer Isolation)
router.get('/packages', authenticateToken, async (req: AuthenticatedRequest, res: Response) => {
  try {
    const customerId = req.user!.id;
    const statusFilter = req.query.status as string | undefined;
    const pkgs = await getPackagesByCustomer(customerId, statusFilter);
    res.json(pkgs.map((p: any) => ({
      id: p.id, boxNumber: p.box_number, trackingNumber: p.tracking_number,
      dimensions: p.dimensions, weightKg: parseFloat(p.weight_kg),
      volumeCbm: parseFloat(p.volume_cbm), arrivalDate: p.arrival_date,
      status: p.status, photos: p.photos, notes: p.notes,
    })));
  } catch (e) { res.status(500).json({ error: 'Server error' }); }
});

// 4. Shipping Methods & Rates
router.get('/shipping-options', async (req, res: Response) => {
  try {
    const weightKg = parseFloat(req.query.weight as string) || 0;
    const methods = await getActiveShippingMethods();
    res.json(methods.map((m: any) => {
      const rateKg = parseFloat(m.rate_per_kg); const rateCbm = parseFloat(m.rate_per_cbm);
      const baseFee = parseFloat(m.base_fee); const minFee = parseFloat(m.minimum_fee);
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
  } catch (e) { res.status(500).json({ error: 'Server error' }); }
});

// 5. Submit Package Consolidation Request
router.post('/consolidate', authenticateToken, async (req: AuthenticatedRequest, res: Response) => {
  try {
    const customerId = req.user!.id;
    const { packageIds, shippingMethodId, destinationCountry, destinationCity, deliveryAddress, deliveryType, notes } = req.body;

    if (!packageIds || !Array.isArray(packageIds) || packageIds.length === 0)
      return res.status(400).json({ error: 'At least one package must be selected', code: 'NO_PACKAGES_SELECTED' });

    // Verify all packages belong to this customer
    const customerPackages = await getPackagesByCustomer(customerId);
    const selectedPackages = customerPackages.filter((p: any) => packageIds.includes(p.id));
    if (selectedPackages.length !== packageIds.length)
      return res.status(403).json({ error: 'Data Isolation Violation: Package does not belong to your account', code: 'FORBIDDEN_PACKAGE_SELECTION' });

    const allMethods = await getAllShippingMethods();
    const shippingMethod = allMethods.find((m: any) => m.id === shippingMethodId) || allMethods[0];
    if (!shippingMethod)
      return res.status(400).json({ error: 'No active shipping method available', code: 'NO_SHIPPING_METHOD' });

    const totalWeight = selectedPackages.reduce((acc: number, p: any) => acc + parseFloat(p.weight_kg), 0);
    const totalCbm = selectedPackages.reduce((acc: number, p: any) => acc + parseFloat(p.volume_cbm), 0);
    const rateKg = parseFloat(shippingMethod.rate_per_kg); const rateCbm = parseFloat(shippingMethod.rate_per_cbm);
    const baseFee = parseFloat(shippingMethod.base_fee); const minFee = parseFloat(shippingMethod.minimum_fee);
    const cost = shippingMethod.type === 'AIR' ? baseFee + rateKg * totalWeight : baseFee + rateCbm * totalCbm;

    const newCons = await createConsolidationOrder({
      customer_id: customerId, shipping_method_id: shippingMethod.id,
      destination_country: destinationCountry || 'Libya', destination_city: destinationCity || 'Tripoli',
      delivery_address: deliveryAddress || 'Port Pickup', delivery_type: deliveryType || 'DOORSTEP',
      total_weight_kg: parseFloat(totalWeight.toFixed(2)), total_cbm: parseFloat(totalCbm.toFixed(4)),
      shipping_cost_usd: parseFloat(Math.max(cost, minFee).toFixed(2)),
      package_ids: packageIds, notes: notes || '',
    });

    // Update package statuses to UNDER_REVIEW
    await updatePackagesBulkStatus(packageIds, 'UNDER_REVIEW');

    // Notify customer
    await createNotification({
      customer_id: customerId,
      title: 'Consolidation Request Submitted',
      message: `Consolidation ${newCons.order_number} for ${selectedPackages.length} packages has been received for review.`,
      type: 'CONSOLIDATION_REQUESTED',
      related_id: newCons.order_number,
    });

    res.status(201).json({ message: 'Consolidation request submitted successfully', consolidation: newCons });
  } catch (e) {
    console.error('Consolidation error:', e);
    res.status(500).json({ error: 'Server error' });
  }
});

// 6. Live Shipment Milestone Tracking
router.get('/tracking/:trackingNumber', async (req, res: Response) => {
  try {
    const { trackingNumber } = req.params;
    let shipment = await getShipmentByTrackingNumber(trackingNumber);
    if (!shipment) shipment = await getFirstShipment();
    if (!shipment) return res.status(404).json({ error: 'No shipments found', code: 'NOT_FOUND' });

    const milestones = await getTrackingMilestones(shipment.tracking_number);
    res.json({
      trackingNumber: shipment.tracking_number, orderId: shipment.order_id,
      statusEn: shipment.current_status_en, statusAr: shipment.current_status_ar,
      shippingMethod: shipment.shipping_method, weightKg: parseFloat(shipment.weight_kg),
      totalCostUsd: parseFloat(shipment.total_cost_usd), packageCount: shipment.package_count,
      milestones: milestones.map((m: any) => ({
        titleEn: m.title_en, titleAr: m.title_ar, location: m.location,
        timestamp: m.timestamp_text, isCompleted: m.state === 'COMPLETED', isCurrent: m.state === 'CURRENT',
      })),
    });
  } catch (e) { res.status(500).json({ error: 'Server error' }); }
});

export default router;
