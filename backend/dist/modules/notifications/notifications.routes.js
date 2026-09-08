"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const auth_1 = require("../../middleware/auth");
const pg_service_1 = require("../../database/pg_service");
const router = (0, express_1.Router)();
// 1. Get Customer Notifications
router.get('/', auth_1.authenticateToken, async (req, res) => {
    try {
        const customerId = req.user.id;
        const notifications = await (0, pg_service_1.getNotificationsByCustomer)(customerId);
        const unreadCount = notifications.filter((n) => !n.is_read).length;
        res.json({ unreadCount, notifications });
    }
    catch (e) {
        res.status(500).json({ error: 'Server error' });
    }
});
// 2. Unread Count Only (Fast Badge Polling)
router.get('/unread-count', auth_1.authenticateToken, async (req, res) => {
    try {
        const customerId = req.user.id;
        const unreadCount = await (0, pg_service_1.getUnreadCount)(customerId);
        res.json({ unreadCount });
    }
    catch (e) {
        res.status(500).json({ error: 'Server error' });
    }
});
// 3. Mark Single Notification as Read
router.patch('/:id/read', auth_1.authenticateToken, async (req, res) => {
    try {
        const customerId = req.user.id;
        const notif = await (0, pg_service_1.markNotificationRead)(req.params.id, customerId);
        if (!notif)
            return res.status(404).json({ error: 'Notification not found', code: 'NOT_FOUND' });
        res.json({ success: true, notification: notif });
    }
    catch (e) {
        res.status(500).json({ error: 'Server error' });
    }
});
// 4. Mark All Notifications as Read
router.patch('/read-all', auth_1.authenticateToken, async (req, res) => {
    try {
        const customerId = req.user.id;
        const markedCount = await (0, pg_service_1.markAllNotificationsRead)(customerId);
        res.json({ success: true, markedCount });
    }
    catch (e) {
        res.status(500).json({ error: 'Server error' });
    }
});
exports.default = router;
