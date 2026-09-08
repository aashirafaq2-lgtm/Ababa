import { Router, Response } from 'express';
import { authenticateToken, AuthenticatedRequest } from '../../middleware/auth';
import {
  getNotificationsByCustomer, getUnreadCount,
  markNotificationRead, markAllNotificationsRead
} from '../../database/pg_service';

const router = Router();

// 1. Get Customer Notifications
router.get('/', authenticateToken, async (req: AuthenticatedRequest, res: Response) => {
  try {
    const customerId = req.user!.id;
    const notifications = await getNotificationsByCustomer(customerId);
    const unreadCount = notifications.filter((n: any) => !n.is_read).length;
    res.json({ unreadCount, notifications });
  } catch (e) { res.status(500).json({ error: 'Server error' }); }
});

// 2. Unread Count Only (Fast Badge Polling)
router.get('/unread-count', authenticateToken, async (req: AuthenticatedRequest, res: Response) => {
  try {
    const customerId = req.user!.id;
    const unreadCount = await getUnreadCount(customerId);
    res.json({ unreadCount });
  } catch (e) { res.status(500).json({ error: 'Server error' }); }
});

// 3. Mark Single Notification as Read
router.patch('/:id/read', authenticateToken, async (req: AuthenticatedRequest, res: Response) => {
  try {
    const customerId = req.user!.id;
    const notif = await markNotificationRead(req.params.id, customerId);
    if (!notif) return res.status(404).json({ error: 'Notification not found', code: 'NOT_FOUND' });
    res.json({ success: true, notification: notif });
  } catch (e) { res.status(500).json({ error: 'Server error' }); }
});

// 4. Mark All Notifications as Read
router.patch('/read-all', authenticateToken, async (req: AuthenticatedRequest, res: Response) => {
  try {
    const customerId = req.user!.id;
    const markedCount = await markAllNotificationsRead(customerId);
    res.json({ success: true, markedCount });
  } catch (e) { res.status(500).json({ error: 'Server error' }); }
});

export default router;
