import { Router, Response } from 'express';
import { authenticateToken, requireRole, AuthenticatedRequest } from '../../middleware/auth';
import { recordAdminAudit } from '../../middleware/audit';
import { STATUS_MAP } from '../futian/futian.routes';
import {
  getAllCustomers, updateUserStatus, getAllPackages, createPackage, updatePackage,
  getAllFutianOrders, getFutianOrderById, updateFutianOrderStatus, updateFutianOrderPricing,
  getAllShippingMethods, updateShippingMethod, getAdminAuditLogs, getAdminOverviewMetrics,
  getActiveWarehouse, addOrderStatusHistory, createNotification
} from '../../database/pg_service';

const router = Router();
router.use(authenticateToken);
router.use(requireRole('ADMIN', 'STAFF'));

// 1. Overview Metrics
router.get('/overview-metrics', async (req: AuthenticatedRequest, res: Response) => {
  try {
    const metrics = await getAdminOverviewMetrics();
    res.json({ metrics, timestamp: new Date().toISOString() });
  } catch (e) { res.status(500).json({ error: 'Server error' }); }
});

// 2. Customer Management
router.get('/customers', async (req: AuthenticatedRequest, res: Response) => {
  try {
    const { q } = req.query;
    const rows = await getAllCustomers(q as string);
    const customers = rows.map((u: any) => ({
      id: u.id, identity: u.identity, fullName: u.full_name || 'Customer',
      phone: u.phone || '', email: u.email || '', boxCode: u.box_code || '',
      status: u.status, createdAt: u.created_at,
    }));
    res.json({ customers });
  } catch (e) { res.status(500).json({ error: 'Server error' }); }
});

// 3. Suspend / Reactivate Customer
router.patch('/customers/:id/status', async (req: AuthenticatedRequest, res: Response) => {
  try {
    const { id } = req.params;
    const { status } = req.body;
    if (!['ACTIVE', 'SUSPENDED'].includes(status))
      return res.status(400).json({ error: 'Status must be ACTIVE or SUSPENDED', code: 'INVALID_STATUS' });
    const updated = await updateUserStatus(id, status);
    if (!updated) return res.status(404).json({ error: 'Customer not found', code: 'NOT_FOUND' });
    await recordAdminAudit(req.user!, 'CUSTOMER_STATUS_CHANGE', 'USER', id, {}, { status });
    res.json({ message: 'Customer status updated', customer: updated });
  } catch (e) { res.status(500).json({ error: 'Server error' }); }
});

// 4. Package Management - List
router.get('/packages', async (req: AuthenticatedRequest, res: Response) => {
  try {
    const { status, q } = req.query;
    const pkgs = await getAllPackages(status as string, q as string);
    res.json({ packages: pkgs });
  } catch (e) { res.status(500).json({ error: 'Server error' }); }
});

// 5. Create Package Arrival at Warehouse
router.post('/packages', async (req: AuthenticatedRequest, res: Response) => {
  try {
    const { customerId, boxNumber, trackingNumber, dimensions, weightKg, volumeCbm, notes, photos } = req.body;
    if (!customerId || !boxNumber || !trackingNumber)
      return res.status(400).json({ error: 'Customer ID, box number, and tracking number are required', code: 'INVALID_DATA' });

    const wh = await getActiveWarehouse();
    if (!wh) return res.status(500).json({ error: 'No active warehouse configured', code: 'NO_WAREHOUSE' });

    const newPkg = await createPackage({
      customer_id: customerId, warehouse_id: wh.id,
      box_number: boxNumber, tracking_number: trackingNumber,
      dimensions: dimensions || '40 x 30 x 20 cm',
      weight_kg: parseFloat(weightKg) || 1.0,
      volume_cbm: parseFloat(volumeCbm) || 0.024,
      notes: notes || '',
      photos: Array.isArray(photos) ? photos : [],
    });

    await recordAdminAudit(req.user!, 'PACKAGE_CHECK_IN', 'PACKAGE', newPkg.id, null, { box_number: boxNumber, tracking_number: trackingNumber, weight_kg: newPkg.weight_kg });
    await createNotification({ customer_id: customerId, title: 'New Package Arrived', message: `Package ${boxNumber} (${newPkg.weight_kg} kg) has arrived at Guangzhou warehouse.`, type: 'PACKAGE_RECEIVED', related_id: boxNumber });

    res.status(201).json({ message: 'Package checked into warehouse', package: newPkg });
  } catch (e) { console.error(e); res.status(500).json({ error: 'Server error' }); }
});

// 6. Update Package Status or Details
router.patch('/packages/:id', async (req: AuthenticatedRequest, res: Response) => {
  try {
    const { id } = req.params;
    const { status, weightKg, volumeCbm, notes } = req.body;
    const updated = await updatePackage(id, { status, weight_kg: weightKg ? parseFloat(weightKg) : undefined, volume_cbm: volumeCbm ? parseFloat(volumeCbm) : undefined, notes });
    if (!updated) return res.status(404).json({ error: 'Package not found', code: 'NOT_FOUND' });
    await recordAdminAudit(req.user!, 'PACKAGE_UPDATE', 'PACKAGE', id, {}, { status, weight_kg: updated.weight_kg, volume_cbm: updated.volume_cbm });
    res.json({ message: 'Package updated successfully', package: updated });
  } catch (e) { res.status(500).json({ error: 'Server error' }); }
});

// 7. Futian Orders - List (Admin)
router.get('/futian/orders', async (req: AuthenticatedRequest, res: Response) => {
  try {
    const { status, q } = req.query;
    const orders = await getAllFutianOrders(status as string, q as string);
    res.json({ orders: orders.map((o: any) => {
      const meta = STATUS_MAP[o.status] || STATUS_MAP.UNDER_REVIEW;
      return { ...o, statusAr: meta.ar, statusEn: meta.en, statusColorHex: meta.color, statusBgHex: meta.bg };
    })});
  } catch (e) { res.status(500).json({ error: 'Server error' }); }
});

// 8. Futian Pricing Desk
router.patch('/futian/orders/:id/pricing', async (req: AuthenticatedRequest, res: Response) => {
  try {
    const { id } = req.params;
    const unitPriceRaw = req.body.unitPriceUsd ?? req.body.unit_price_usd;
    const { notes } = req.body;

    const order = await getFutianOrderById(id);
    if (!order) return res.status(404).json({ error: 'Order not found', code: 'NOT_FOUND' });

    const parsedUnitPrice = parseFloat(unitPriceRaw);
    if (isNaN(parsedUnitPrice) || parsedUnitPrice <= 0)
      return res.status(400).json({ error: 'Valid positive unit price is required', code: 'INVALID_PRICE' });

    const oldStatus = order.status;
    const updated = await updateFutianOrderPricing(id, parsedUnitPrice, order.quantity);

    await addOrderStatusHistory({
      order_id: order.order_id, from_status: oldStatus, to_status: 'APPROVAL_PENDING',
      changed_by_user_id: req.user!.id,
      changed_by_name: `Staff: ${req.user!.identity}`,
      notes: notes || `Quoted unit price: $${parsedUnitPrice.toFixed(2)} USD. Total: $${(parsedUnitPrice * order.quantity).toFixed(2)} USD`,
    });

    await recordAdminAudit(req.user!, 'ORDER_PRICING_SET', 'FUTIAN_ORDER', order.order_id, { status: oldStatus }, { unit_price_usd: parsedUnitPrice, status: 'APPROVAL_PENDING' });
    await createNotification({
      customer_id: order.customer_id,
      title: 'Price Quote Ready for Approval',
      message: `Order ${order.order_id} (${order.product_name_en}) has been quoted at $${(parsedUnitPrice * order.quantity).toFixed(2)} USD. Please review and approve.`,
      type: 'ORDER_PRICED', related_id: order.order_id,
    });

    res.json({ message: 'Quotation set successfully. Order advanced to APPROVAL_PENDING', order: updated });
  } catch (e) { console.error(e); res.status(500).json({ error: 'Server error' }); }
});

// 9. Advance Futian Order Status (Admin)
router.patch('/futian/orders/:id/status', async (req: AuthenticatedRequest, res: Response) => {
  try {
    const { id } = req.params;
    const { status, notes } = req.body;
    const validStatuses = ['UNDER_REVIEW', 'PRICE_PENDING', 'APPROVAL_PENDING', 'PURCHASED', 'SHIPPED', 'ARRIVED', 'CANCELLED'];
    if (!status || !validStatuses.includes(status))
      return res.status(400).json({ error: `Status must be one of: ${validStatuses.join(', ')}`, code: 'INVALID_STATUS' });

    const order = await getFutianOrderById(id);
    if (!order) return res.status(404).json({ error: 'Order not found', code: 'NOT_FOUND' });

    const oldStatus = order.status;
    const updated = await updateFutianOrderStatus(id, status);

    await addOrderStatusHistory({
      order_id: order.order_id, from_status: oldStatus, to_status: status,
      changed_by_user_id: req.user!.id,
      changed_by_name: `Admin/Staff: ${req.user!.identity}`,
      notes: notes || `Status updated from ${oldStatus} to ${status}`,
    });

    await recordAdminAudit(req.user!, 'ORDER_STATUS_CHANGE', 'FUTIAN_ORDER', order.order_id, { status: oldStatus }, { status, notes });
    await createNotification({
      customer_id: order.customer_id,
      title: 'Order Status Changed',
      message: `Order ${order.order_id} is now ${STATUS_MAP[status]?.en || status}.`,
      type: 'ORDER_STATUS_CHANGED', related_id: order.order_id,
    });

    res.json({ message: `Order advanced to ${status}`, order: updated });
  } catch (e) { res.status(500).json({ error: 'Server error' }); }
});

// 10. Shipping Rates Management
router.get('/shipping-rates', async (req: AuthenticatedRequest, res: Response) => {
  try {
    const rates = await getAllShippingMethods();
    res.json({ rates, shippingMethods: rates });
  } catch (e) { res.status(500).json({ error: 'Server error' }); }
});

const handleUpdateShippingRate = async (req: AuthenticatedRequest, res: Response) => {
  try {
    const { id } = req.params;
    const ratePerKg = req.body.ratePerKg ?? req.body.rate_per_kg;
    const ratePerCbm = req.body.ratePerCbm ?? req.body.rate_per_cbm;
    const baseFee = req.body.baseFee ?? req.body.base_fee;
    const minimumFee = req.body.minimumFee ?? req.body.minimum_fee;
    const estimatedDays = req.body.estimatedDays ?? req.body.estimated_days;
    const isActive = req.body.isActive ?? req.body.is_active;

    const updated = await updateShippingMethod(id, {
      rate_per_kg: ratePerKg !== undefined ? parseFloat(ratePerKg) : undefined,
      rate_per_cbm: ratePerCbm !== undefined ? parseFloat(ratePerCbm) : undefined,
      base_fee: baseFee !== undefined ? parseFloat(baseFee) : undefined,
      minimum_fee: minimumFee !== undefined ? parseFloat(minimumFee) : undefined,
      estimated_days: estimatedDays,
      is_active: isActive !== undefined ? Boolean(isActive) : undefined,
    });
    if (!updated) return res.status(404).json({ error: 'Shipping method not found', code: 'NOT_FOUND' });
    await recordAdminAudit(req.user!, 'SHIPPING_RATE_UPDATE', 'SHIPPING_METHOD', id, {}, updated);
    res.json({ message: 'Shipping rate tariff updated successfully', rate: updated, shippingMethod: updated });
  } catch (e) { res.status(500).json({ error: 'Server error' }); }
};

router.put('/shipping-rates/:id', handleUpdateShippingRate);
router.patch('/shipping-rates/:id', handleUpdateShippingRate);

// 11. Audit Logs
router.get('/audit-logs', async (req: AuthenticatedRequest, res: Response) => {
  try {
    const { limit, q } = req.query;
    const logs = await getAdminAuditLogs(parseInt(limit as string) || 100, q as string);
    res.json({ logs, auditLogs: logs });
  } catch (e) { res.status(500).json({ error: 'Server error' }); }
});

export default router;
