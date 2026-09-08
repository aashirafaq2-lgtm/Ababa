import React, { useEffect, useState } from 'react';
import AdminLayout from '../components/layout/AdminLayout';
import { ShippingRateService } from '../services/api';

export default function ShippingRatesPage() {
  const [rates, setRates] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [editing, setEditing] = useState<any | null>(null);
  const [form, setForm] = useState<any>({});
  const [submitting, setSubmitting] = useState(false);
  const [toast, setToast] = useState('');

  const showToast = (msg: string) => { setToast(msg); setTimeout(() => setToast(''), 4000); };

  const load = () => {
    setLoading(true);
    ShippingRateService.list()
      .then(r => setRates(r.data.rates || []))
      .catch(() => setRates([]))
      .finally(() => setLoading(false));
  };

  useEffect(() => { load(); }, []);

  const startEdit = (rate: any) => {
    setEditing(rate);
    setForm({
      ratePerKg: rate.rate_per_kg,
      ratePerCbm: rate.rate_per_cbm,
      baseFee: rate.base_fee,
      minimumFee: rate.minimum_fee,
      estimatedDays: rate.estimated_days,
      isActive: rate.is_active,
    });
  };

  const handleSave = async (e: React.FormEvent) => {
    e.preventDefault();
    setSubmitting(true);
    try {
      await ShippingRateService.update(editing.id, {
        ratePerKg: parseFloat(form.ratePerKg),
        ratePerCbm: parseFloat(form.ratePerCbm),
        baseFee: parseFloat(form.baseFee),
        minimumFee: parseFloat(form.minimumFee),
        estimatedDays: form.estimatedDays,
        isActive: form.isActive,
      });
      showToast('✅ Shipping rate updated');
      setEditing(null);
      load();
    } catch {
      showToast('❌ Update failed');
    } finally {
      setSubmitting(false);
    }
  };

  return (
    <AdminLayout title="Shipping Rate Tariffs">
      <style>{`
        .cards { display:grid; grid-template-columns:repeat(auto-fill,minmax(340px,1fr)); gap:20px; }
        .rate-card { background:#fff; border:1px solid #E5E7EB; border-radius:14px; padding:24px; }
        .rate-type { font-size:11px; font-weight:800; letter-spacing:1px; text-transform:uppercase; margin-bottom:8px; }
        .rate-name { font-size:18px; font-weight:900; margin-bottom:4px; }
        .rate-days { font-size:13px; color:#6B7280; margin-bottom:16px; }
        .rate-row { display:flex; justify-content:space-between; padding:10px 0; border-bottom:1px solid #F3F4F6; font-size:13px; }
        .rate-row:last-child { border-bottom:none; }
        .rate-label { color:#9CA3AF; font-weight:500; }
        .rate-val { font-weight:700; color:#111827; }
        .btn-edit { margin-top:16px; background:#FFF5F0; color:#FF6600; border:1px solid #FFD5C0; border-radius:10px; padding:9px 18px; font-size:13px; font-weight:700; cursor:pointer; }
        .badge-on { background:#F0FDF4; color:#16A34A; padding:3px 10px; border-radius:20px; font-size:11px; font-weight:700; }
        .badge-off { background:#F3F4F6; color:#9CA3AF; padding:3px 10px; border-radius:20px; font-size:11px; font-weight:700; }
        .modal-overlay { position:fixed; inset:0; background:rgba(0,0,0,.4); display:flex; align-items:center; justify-content:center; z-index:999; }
        .modal { background:#fff; border-radius:16px; padding:28px; width:480px; max-width:95vw; }
        .modal h3 { font-size:18px; font-weight:900; margin-bottom:20px; }
        .grid-2 { display:grid; grid-template-columns:1fr 1fr; gap:14px; }
        .field { margin-bottom:14px; }
        .field label { display:block; font-size:12px; font-weight:600; color:#6B7280; margin-bottom:5px; }
        .field input { width:100%; padding:10px 12px; border:1px solid #E5E7EB; border-radius:10px; font-size:14px; }
        .modal-actions { display:flex; gap:10px; margin-top:20px; justify-content:flex-end; }
        .btn-cancel { background:#F3F4F6; color:#374151; border:none; padding:10px 20px; border-radius:10px; font-weight:700; cursor:pointer; }
        .btn-primary { background:#FF6600; color:#fff; border:none; padding:10px 20px; border-radius:10px; font-weight:700; cursor:pointer; }
        .toggle-row { display:flex; align-items:center; gap:10px; margin-top:8px; font-size:13px; font-weight:600; }
        .toggle { width:40px; height:22px; border-radius:11px; border:none; cursor:pointer; transition:.2s; }
        .toggle.on { background:#16A34A; }
        .toggle.off { background:#D1D5DB; }
        .toast { position:fixed; bottom:24px; right:24px; background:#111827; color:#fff; padding:12px 20px; border-radius:12px; font-size:13px; font-weight:600; z-index:9999; }
        .empty { text-align:center; padding:60px; color:#9CA3AF; }
      `}</style>

      {toast && <div className="toast">{toast}</div>}

      {loading ? (
        <div className="empty">Loading shipping rates...</div>
      ) : (
        <div className="cards">
          {rates.map((r: any) => (
            <div key={r.id} className="rate-card">
              <div className="rate-type" style={{ color: r.type === 'AIR' ? '#0D9488' : '#2563EB' }}>
                {r.type === 'AIR' ? '✈️ Air Freight' : '🚢 Sea Freight'}
              </div>
              <div className="rate-name">{r.title_en}</div>
              <div className="rate-days">⏱ {r.estimated_days}</div>

              <div>
                <div className="rate-row">
                  <span className="rate-label">Rate per kg</span>
                  <span className="rate-val">${r.rate_per_kg?.toFixed(2)}/kg</span>
                </div>
                <div className="rate-row">
                  <span className="rate-label">Rate per CBM</span>
                  <span className="rate-val">${r.rate_per_cbm?.toFixed(2)}/cbm</span>
                </div>
                <div className="rate-row">
                  <span className="rate-label">Base Fee</span>
                  <span className="rate-val">${r.base_fee?.toFixed(2)}</span>
                </div>
                <div className="rate-row">
                  <span className="rate-label">Minimum Fee</span>
                  <span className="rate-val">${r.minimum_fee?.toFixed(2)}</span>
                </div>
                <div className="rate-row">
                  <span className="rate-label">Status</span>
                  <span>{r.is_active
                    ? <span className="badge-on">ACTIVE</span>
                    : <span className="badge-off">DISABLED</span>}
                  </span>
                </div>
              </div>

              <button className="btn-edit" onClick={() => startEdit(r)}>
                ✏️ Edit Tariff
              </button>
            </div>
          ))}
        </div>
      )}

      {editing && (
        <div className="modal-overlay" onClick={() => setEditing(null)}>
          <div className="modal" onClick={e => e.stopPropagation()}>
            <h3>✏️ Edit: {editing.title_en}</h3>
            <form onSubmit={handleSave}>
              <div className="grid-2">
                <div className="field">
                  <label>Rate per kg (USD)</label>
                  <input type="number" step="0.01" value={form.ratePerKg} onChange={e => setForm({ ...form, ratePerKg: e.target.value })} />
                </div>
                <div className="field">
                  <label>Rate per CBM (USD)</label>
                  <input type="number" step="0.01" value={form.ratePerCbm} onChange={e => setForm({ ...form, ratePerCbm: e.target.value })} />
                </div>
                <div className="field">
                  <label>Base Fee (USD)</label>
                  <input type="number" step="0.01" value={form.baseFee} onChange={e => setForm({ ...form, baseFee: e.target.value })} />
                </div>
                <div className="field">
                  <label>Minimum Fee (USD)</label>
                  <input type="number" step="0.01" value={form.minimumFee} onChange={e => setForm({ ...form, minimumFee: e.target.value })} />
                </div>
              </div>
              <div className="field">
                <label>Estimated Days</label>
                <input value={form.estimatedDays} onChange={e => setForm({ ...form, estimatedDays: e.target.value })} />
              </div>
              <div className="toggle-row">
                <span>Active</span>
                <button
                  type="button"
                  className={`toggle ${form.isActive ? 'on' : 'off'}`}
                  onClick={() => setForm({ ...form, isActive: !form.isActive })}
                />
                <span style={{ color: form.isActive ? '#16A34A' : '#9CA3AF' }}>
                  {form.isActive ? 'Enabled' : 'Disabled'}
                </span>
              </div>
              <div className="modal-actions">
                <button type="button" className="btn-cancel" onClick={() => setEditing(null)}>Cancel</button>
                <button type="submit" className="btn-primary" disabled={submitting}>
                  {submitting ? 'Saving...' : 'Save Tariff'}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </AdminLayout>
  );
}
