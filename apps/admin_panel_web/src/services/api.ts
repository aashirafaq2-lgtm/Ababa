import axios, { AxiosInstance } from 'axios';

const BASE = process.env.NEXT_PUBLIC_GATEWAY_URL || 'http://localhost:5000';

const api: AxiosInstance = axios.create({
  baseURL: BASE,
  headers: { 'Content-Type': 'application/json' },
});

// Auto-inject admin JWT on every request
api.interceptors.request.use((config) => {
  const token =
    typeof window !== 'undefined'
      ? localStorage.getItem('ahmedbaba_admin_token')
      : null;
  if (token) config.headers.Authorization = `Bearer ${token}`;
  return config;
});

// ─── Auth ────────────────────────────────────────────────────────────────────
export const AdminAuthService = {
  signIn: (identity: string, password: string) =>
    api.post('/api/v1/auth/china-box/signin', { identity, password }),
  me: () => api.get('/api/v1/auth/china-box/me'),
};

// ─── Overview ────────────────────────────────────────────────────────────────
export const OverviewService = {
  getMetrics: () => api.get('/api/v1/admin/overview-metrics'),
};

// ─── Customers ───────────────────────────────────────────────────────────────
export const CustomerService = {
  list: (q?: string) =>
    api.get('/api/v1/admin/customers', { params: q ? { q } : {} }),
};

// ─── Packages (My China Box) ─────────────────────────────────────────────────
export const PackageService = {
  list: (status?: string, q?: string) =>
    api.get('/api/v1/admin/packages', {
      params: { ...(status && status !== 'all' ? { status } : {}), ...(q ? { q } : {}) },
    }),
  checkIn: (data: {
    customerId: string;
    boxNumber: string;
    trackingNumber: string;
    dimensions?: string;
    weightKg?: number;
    volumeCbm?: number;
    notes?: string;
  }) => api.post('/api/v1/admin/packages', data),
  update: (
    id: string,
    data: { status?: string; weightKg?: number; volumeCbm?: number; notes?: string }
  ) => api.patch(`/api/v1/admin/packages/${id}`, data),
};

// ─── Futian Orders ────────────────────────────────────────────────────────────
export const FutianService = {
  list: (status?: string, q?: string) =>
    api.get('/api/v1/admin/futian/orders', {
      params: {
        ...(status && status !== 'all' ? { status } : {}),
        ...(q ? { q } : {}),
      },
    }),
  setPrice: (id: string, unitPriceUsd: number, notes?: string) =>
    api.patch(`/api/v1/admin/futian/orders/${id}/pricing`, {
      unitPriceUsd,
      notes,
    }),
  setStatus: (id: string, status: string, notes?: string) =>
    api.patch(`/api/v1/admin/futian/orders/${id}/status`, { status, notes }),
};

// ─── Shipping Rates ───────────────────────────────────────────────────────────
export const ShippingRateService = {
  list: () => api.get('/api/v1/admin/shipping-rates'),
  update: (
    id: string,
    data: {
      ratePerKg?: number;
      ratePerCbm?: number;
      baseFee?: number;
      minimumFee?: number;
      estimatedDays?: string;
      isActive?: boolean;
    }
  ) => api.put(`/api/v1/admin/shipping-rates/${id}`, data),
};

// ─── Audit Logs ───────────────────────────────────────────────────────────────
export const AuditService = {
  list: (limit = 100, q?: string) =>
    api.get('/api/v1/admin/audit-logs', {
      params: { limit, ...(q ? { q } : {}) },
    }),
};

export default api;
