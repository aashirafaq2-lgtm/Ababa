import { Request, Response, NextFunction } from 'express';
import jwt from 'jsonwebtoken';

const JWT_SECRET = process.env.JWT_SECRET || 'ahmedbaba_secure_jwt_secret_key_2025';

export interface AuthUser {
  id: string;
  role: 'ADMIN' | 'STAFF' | 'CUSTOMER';
  identity: string;
  box_code?: string;
}

export interface AuthenticatedRequest extends Request {
  user?: AuthUser;
}

export function signToken(user: AuthUser): string {
  return jwt.sign(
    {
      id: user.id,
      role: user.role,
      identity: user.identity,
      box_code: user.box_code,
    },
    JWT_SECRET,
    { expiresIn: '30d' }
  );
}

export function authenticateToken(req: AuthenticatedRequest, res: Response, next: NextFunction) {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];

  if (!token) {
    return res.status(401).json({ error: 'Authentication token required', code: 'UNAUTHORIZED' });
  }

  jwt.verify(token, JWT_SECRET, (err: any, decoded: any) => {
    if (err) {
      return res.status(403).json({ error: 'Invalid or expired token', code: 'FORBIDDEN' });
    }
    req.user = decoded as AuthUser;
    next();
  });
}

// Server-side role authorization check
export function requireRole(...allowedRoles: Array<'ADMIN' | 'STAFF' | 'CUSTOMER'>) {
  return (req: AuthenticatedRequest, res: Response, next: NextFunction) => {
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
export function enforceCustomerIsolation(req: AuthenticatedRequest, res: Response, next: NextFunction) {
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
