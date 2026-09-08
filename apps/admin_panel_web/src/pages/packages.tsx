import React, { useEffect, useState } from 'react';
import AdminLayout from '../components/layout/AdminLayout';
import { PackageService, CustomerService } from '../services/api';

const STATUS_OPTIONS = ['all', 'IN_WAREHOUSE', 'READY_FOR_CONSOLIDATION', 'UNDER_REVIEW', 'SHIPPED', 'REJECTED'];

const STATUS_BADGE: Record<string, { label: string; bg: string; color: string }> = {
  IN_WAREHOUSE:           { label: 'In Warehouse',           bg: '#EFF6FF', color: '#1D4ED8' },
  READY_FOR_CONSOLIDATION:{ label: 'Ready',                  bg: '#F0FDF4', color: '#15803D' },
  UNDER_REVIEW:           { label: 'Under Review',           bg: '#FFF7ED', color: '#C2410C' },
  SHIPPED:                { label: 'Shipped',                bg: '#F0FDFA', color: '#0D9488' },
  REJECTED:               { label: 'Rejected',               bg: '#FEF2F2', color: '#B91C1C' },
};

export default function PackagesPage() {
  const [packages, setPackages] = useState<any[]>([]);
  const [customers, setCustomers] = useState<any[]>([]);
  const [status, setStatus] = useState('all');
  const [q, setQ] = useState('');
  const [loading, setLoading] = useState(true);
  const [showCheckin, setShowCheckin] = useState(false);

  // Check-in form state
  const [form, setForm] = useState({
    customerId: '', boxNumber: '', trackingNumber: '',
    dimensions: '40 x 30 x 20 cm', weightKg: '1.0', volumeCbm: '0.024', notes: '',
  });
  const [submitting, setSubmitting] = useState(false);
  const [toast, setToast] = useState('');

  const load = () => {
    setLoading(true);
    PackageService.list(status, q || undefined)
      .then(r => setPackages(r.data.packages || []))
      .catch(() => setPackages([]))
      .finally(() => setLoading(false));
  };

  useEffect(() => { load(); }, [status, q]);

  useEffect(() => {
    CustomerService.list()
      .then(r => setCustomers(r.data.customers || []))
      .catch(() => {});
  }, []);

  const handleCheckin = async (e: React.FormEvent) => {
    e.preventDefault();
    setSubmitting(true);
    try {
      await PackageService.checkIn({
        customerId: form.customerId,
        boxNumber: form.boxNumber,
        trackingNumber: form.trackingNumber,
        dimensions: form.dimensions,
        weightKg: parseFloat(form.weightKg),
        volumeCbm: parseFloat(form.volumeCbm),
        notes: form.notes,
      });
      setToast('✅ Package checked in successfully');
      setShowCheckin(false);
      setForm({ customerId: '', boxNumber: '', trackingNumber: '', dimensions: '40 x 30 x 20 cm', weightKg: '1.0', volumeCbm: '0.024', notes: '' });
      load();
    } catch {
      setToast('❌ Check-in failed. Please verify the data.');
    } finally {
      setSubmitting(false);
      setTimeout(() => setToast(''), 4000);
    }
  };

  const handleStatusUpdate = async (id: string, newStatus: string) => {
    try {
      await PackageService.update(id, { status: newStatus });
      setToast(`✅ Package updated to ${newStatus}`);
      load();
    } catch {
      setToast('❌ Update failed');
    }
    setTimeout(() => setToast(''), 3000);
  };

  const badge = (s: string) => {
    const b = STATUS_BADGE[s] || { label: s, bg: '#F3F4F6', color: '#374151' };
    return (
      <span style={{
        background: b.bg, color: b.color,
        padding: '3px 10px', borderRadius: 20, fontSize: 11, fontWeight: 700,
      }}>{b.label}</span>
    );
  };

  return (
    <AdminLayout title="Package Management — My China Box">
      <style>{`
        .toolbar { display:flex; gap:12px; margin-bottom:20px; flex-wrap:wrap; align-items:center; }
        .search-box { flex:1; min-width:220px; padding:10px 14px; border:1px solid #E5E7EB; border-radius:10px; font-size:14px; }
        .sel { padding:10px 14px; border:1px solid #E5E7EB; border-radius:10px; font-size:13px; }
        .btn-primary { background:#FF6600; color:#fff; border:none; padding:10px 20px; border-radius:10px; font-weight:700; cursor:pointer; font-size:13px; }
        .btn-primary:hover { background:#e65c00; }
        table { width:100%; border-collapse:collapse; background:#fff; border-radius:14px; overflow:hidden; border:1px solid #E5E7EB; }
        th { text-align:left; padding:12px 16px; font-size:11px; color:#9CA3AF; font-weight:700; text-transform:uppercase; background:#FAFAFA; border-bottom:2px solid #E5E7EB; }
        td { padding:14px 16px; font-size:13px; color:#374151; border-bottom:1px solid #F3F4F6; }
        tr:last-child td { border-bottom:none; }
        tr:hover td { background:#FAFAFA; }
        select.inline { border:1px solid #E5E7EB; border-radius:8px; padding:4px 8px; font-size:12px; cursor:pointer; }
        .modal-overlay { position:fixed; inset:0; background:rgba(0,0,0,.4); display:flex; align-items:center; justify-content:center; z-index:999; }
        .modal { background:#fff; border-radius:16px; padding:28px; width:520px; max-width:95vw; }
        .modal h3 { font-size:18px; font-weight:900; margin-bottom:20px; }
        .field { margin-bottom:14px; }
        .field label { display:block; font-size:12px; font-weight:600; color:#6B7280; margin-bottom:5px; }
        .field input, .field select, .field textarea { width:100%; padding:10px 12px; border:1px solid #E5E7EB; border-radius:10px; font-size:14px; }
        .modal-actions { display:flex; gap:10px; margin-top:20px; justify-content:flex-end; }
        .btn-cancel { background:#F3F4F6; color:#374151; border:none; padding:10px 20px; border-radius:10px; font-weight:700; cursor:pointer; }
        .toast { position:fixed; bottom:24px; right:24px; background:#111827; color:#fff; padding:12px 20px; border-radius:12px; font-size:13px; font-weight:600; z-index:9999; }
        .empty { text-align:center; padding:60px; color:#9CA3AF; }
      `}</style>

      {toast && <div className="toast">{toast}</div>}

      <div className="toolbar">
        <input
          className="search-box"
          placeholder="🔍 Search by box number, tracking, or customer..."
          value={q}
          onChange={e => setQ(e.target.value)}
        />
        <select className="sel" value={status} onChange={e => setStatus(e.target.value)}>
          {STATUS_OPTIONS.map(s => (
            <option key={s} value={s}>
              {s === 'all' ? 'All Statuses' : STATUS_BADGE[s]?.label || s}
            </option>
          ))}
        </select>
        <button className="btn-primary" onClick={() => setShowCheckin(true)}>
          + Check In Package
        </button>
      </div>

      {loading ? (
        <div className="empty">Loading packages...</div>
      ) : packages.length === 0 ? (
        <div className="empty">No packages found.</div>
      ) : (
        <table>
          <thead>
            <tr>
              <th>Box Number</th>
              <th>Tracking</th>
              <th>Customer</th>
              <th>Weight (kg)</th>
              <th>Dimensions</th>
              <th>Status</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            {packages.map((p: any) => (
              <tr key={p.id}>
                <td><strong>{p.box_number}</strong></td>
                <td style={{ fontFamily: 'monospace', fontSize: 12 }}>{p.tracking_number}</td>
                <td>
                  <div style={{ fontWeight: 600 }}>{p.customerName}</div>
                  <div style={{ fontSize: 11, color: '#9CA3AF' }}>{p.customerBoxCode}</div>
                </td>
                <td>{p.weight_kg} kg</td>
                <td style={{ fontSize: 12 }}>{p.dimensions}</td>
                <td>{badge(p.status)}</td>
                <td>
                  <select
                    className="inline"
                    defaultValue=""
                    onChange={e => { if (e.target.value) handleStatusUpdate(p.id, e.target.value); }}
                  >
                    <option value="" disabled>Update →</option>
                    {['IN_WAREHOUSE', 'READY_FOR_CONSOLIDATION', 'UNDER_REVIEW', 'SHIPPED', 'REJECTED']
                      .filter(s => s !== p.status)
                      .map(s => (
                        <option key={s} value={s}>{STATUS_BADGE[s]?.label || s}</option>
                      ))}
                  </select>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      )}

      {showCheckin && (
        <div className="modal-overlay" onClick={() => setShowCheckin(false)}>
          <div className="modal" onClick={e => e.stopPropagation()}>
            <h3>📦 Check In New Package</h3>
            <form onSubmit={handleCheckin}>
              <div className="field">
                <label>Customer *</label>
                <select required value={form.customerId} onChange={e => setForm({ ...form, customerId: e.target.value })}>
                  <option value="">— Select customer —</option>
                  {customers.map((c: any) => (
                    <option key={c.id} value={c.id}>{c.fullName} ({c.boxCode})</option>
                  ))}
                </select>
              </div>
              <div className="field">
                <label>Box Number *</label>
                <input required placeholder="e.g. Box #250901-01" value={form.boxNumber} onChange={e => setForm({ ...form, boxNumber: e.target.value })} />
              </div>
              <div className="field">
                <label>Tracking Number *</label>
                <input required placeholder="e.g. YT243516789CN" value={form.trackingNumber} onChange={e => setForm({ ...form, trackingNumber: e.target.value })} />
              </div>
              <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 12 }}>
                <div className="field">
                  <label>Weight (kg)</label>
                  <input type="number" step="0.01" value={form.weightKg} onChange={e => setForm({ ...form, weightKg: e.target.value })} />
                </div>
                <div className="field">
                  <label>Volume (CBM)</label>
                  <input type="number" step="0.001" value={form.volumeCbm} onChange={e => setForm({ ...form, volumeCbm: e.target.value })} />
                </div>
              </div>
              <div className="field">
                <label>Dimensions</label>
                <input placeholder="40 x 30 x 20 cm" value={form.dimensions} onChange={e => setForm({ ...form, dimensions: e.target.value })} />
              </div>
              <div className="field">
                <label>Notes</label>
                <textarea rows={2} value={form.notes} onChange={e => setForm({ ...form, notes: e.target.value })} />
              </div>
              <div className="modal-actions">
                <button type="button" className="btn-cancel" onClick={() => setShowCheckin(false)}>Cancel</button>
                <button type="submit" className="btn-primary" disabled={submitting}>
                  {submitting ? 'Checking in...' : 'Check In Package'}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </AdminLayout>
  );
}
