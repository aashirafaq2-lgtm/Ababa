"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.signToken = signToken;
exports.authenticateToken = authenticateToken;
exports.requireRole = requireRole;
exports.enforceCustomerIsolation = enforceCustomerIsolation;
const jsonwebtoken_1 = __importDefault(require("jsonwebtoken"));
const JWT_SECRET = process.env.JWT_SECRET || 'ahmedbaba_secure_jwt_secret_key_2025';
function signToken(user) {
    return jsonwebtoken_1.default.sign({
        id: user.id,
        role: user.role,
        identity: user.identity,
        box_code: user.box_code,
    }, JWT_SECRET, { expiresIn: '30d' });
}
function authenticateToken(req, res, next) {
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1];
    if (!token) {
        return res.status(401).json({ error: 'Authentication token required', code: 'UNAUTHORIZED' });
    }
    jsonwebtoken_1.default.verify(token, JWT_SECRET, (err, decoded) => {
        if (err) {
            return res.status(403).json({ error: 'Invalid or expired token', code: 'FORBIDDEN' });
        }
        req.user = decoded;
        next();
    });
}
// Server-side role authorization check
function requireRole(...allowedRoles) {
    return (req, res, next) => {
        if (!req.user) {
            return res.status(401).json({ error: 'Unauthenticated', code: 'UNAUTHENTICATED' });
        }
        if (!allowedRoles.includes(req.user.role)) {
            return res.status(403).json({
                error: `Access denied. Role ${req.user.role} does not possess required privileges`,
                code: 'ACCESS_DENIED',
            });
        }
        next();
    };
}
// Strict Customer Isolation: Customer A can NEVER access Customer B's records
function enforceCustomerIsolation(req, res, next) {
    if (!req.user) {
        return res.status(401).json({ error: 'Unauthenticated', code: 'UNAUTHENTICATED' });
    }
    // Admin and Staff can manage any customer
    if (req.user.role === 'ADMIN' || req.user.role === 'STAFF') {
        return next();
    }
    // If endpoint specifies a customerId in query or params, customer must match their own ID
    const targetCustomerId = req.params.customerId || req.query.customer_id;
    if (targetCustomerId && targetCustomerId !== req.user.id) {
        return res.status(403).json({
            error: 'Data Isolation Violation: You are not authorized to view or modify another customer\'s records.',
            code: 'DATA_ISOLATION_VIOLATION',
        });
    }
    next();
}
