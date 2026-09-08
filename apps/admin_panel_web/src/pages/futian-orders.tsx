import React, { useEffect, useState } from 'react';
import AdminLayout from '../components/layout/AdminLayout';
import { FutianService } from '../services/api';

const STATUS_OPTIONS = [
  { key: 'all', label: 'All Orders' },
  { key: 'UNDER_REVIEW', label: '🔍 Under Review', color: '#FF5500', bg: '#FFF1EB' },
  { key: 'PRICE_PENDING', label: '💰 Price Pending', color: '#D97706', bg: '#FEFCE8' },
  { key: 'APPROVAL_PENDING', label: '⏳ Awaiting Approval', color: '#9333EA', bg: '#FAF5FF' },
  { key: 'PURCHASED', label: '✅ Purchased', color: '#2563EB', bg: '#EFF6FF' },
  { key: 'SHIPPED', label: '🚢 Shipped', color: '#0D9488', bg: '#F0FDFA' },
  { key: 'ARRIVED', label: '📬 Arrived', color: '#16A34A', bg: '#F0FDF4' },
  { key: 'CANCELLED', label: '❌ Cancelled', color: '#EF4444', bg: '#FEF2F2' },
];

export default function FutianOrdersPage() {
  const [orders, setOrders] = useState<any[]>([]);
  const [status, setStatus] = useState('all');
  const [q, setQ] = useState('');
  const [loading, setLoading] = useState(true);
  const [toast, setToast] = useState('');

  // Pricing modal
  const [pricingModal, setPricingModal] = useState<{ id: string; orderId: string; product: string; qty: number } | null>(null);
  const [priceInput, setPriceInput] = useState('');
  const [priceNote, setPriceNote] = useState('');
  const [submittingPrice, setSubmittingPrice] = useState(false);

  const showToast = (msg: string) => { setToast(msg); setTimeout(() => setToast(''), 4000); };

  const load = () => {
    setLoading(true);
    FutianService.list(status, q || undefined)
      .then(r => setOrders(r.data.orders || []))
      .catch(() => setOrders([]))
      .finally(() => setLoading(false));
  };

  useEffect(() => { load(); }, [status, q]);

  const handleSetStatus = async (id: string, newStatus: string) => {
    try {
      await FutianService.setStatus(id, newStatus);
      showToast(`✅ Order advanced to ${newStatus}`);
      load();
    } catch {
      showToast('❌ Failed to update status');
    }
  };

  const handleSetPrice = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!pricingModal) return;
    setSubmittingPrice(true);
    try {
      await FutianService.setPrice(pricingModal.id, parseFloat(priceInput), priceNote);
      showToast(`✅ Price set for ${pricingModal.orderId} — waiting for customer approval`);
      setPricingModal(null);
      setPriceInput('');
      setPriceNote('');
      load();
    } catch {
      showToast('❌ Pricing failed');
    } finally {
      setSubmittingPrice(false);
    }
  };

  const statusChip = (o: any) => (
    <span style={{
      background: o.statusBgHex, color: o.statusColorHex,
      padding: '3px 10px', borderRadius: 20, fontSize: 11, fontWeight: 800, whiteSpace: 'nowrap',
    }}>
      {o.statusEn}
    </span>
  );

  return (
    <AdminLayout title="Futian Purchases — Order Management">
      <style>{`
        .toolbar { display:flex; gap:12px; margin-bottom:20px; flex-wrap:wrap; align-items:center; }
        .search-box { flex:1; min-width:220px; padding:10px 14px; border:1px solid #E5E7EB; border-radius:10px; font-size:14px; }
        .sel { padding:10px 14px; border:1px solid #E5E7EB; border-radius:10px; font-size:13px; }
        table { width:100%; border-collapse:collapse; background:#fff; border-radius:14px; overflow:hidden; border:1px solid #E5E7EB; }
        th { text-align:left; padding:12px 16px; font-size:11px; color:#9CA3AF; font-weight:700; text-transform:uppercase; background:#FAFAFA; border-bottom:2px solid #E5E7EB; }
        td { padding:14px 16px; font-size:13px; color:#374151; border-bottom:1px solid #F3F4F6; vertical-align:middle; }
        tr:last-child td { border-bottom:none; }
        tr:hover td { background:#FAFAFA; }
        .btn-sm { padding:5px 12px; border:none; border-radius:8px; font-size:11px; font-weight:700; cursor:pointer; }
        .btn-price { background:#FFF7ED; color:#C2410C; }
        .btn-price:hover { background:#FFEDD5; }
        .btn-status { background:#F3F4F6; color:#374151; }
        select.inline { border:1px solid #E5E7EB; border-radius:8px; padding:4px 8px; font-size:12px; cursor:pointer; }
        .modal-overlay { position:fixed; inset:0; background:rgba(0,0,0,.4); display:flex; align-items:center; justify-content:center; z-index:999; }
        .modal { background:#fff; border-radius:16px; padding:28px; width:460px; max-width:95vw; }
        .modal h3 { font-size:18px; font-weight:900; margin-bottom:6px; }
        .modal p { color:#6B7280; font-size:13px; margin-bottom:20px; }
        .field { margin-bottom:14px; }
        .field label { display:block; font-size:12px; font-weight:600; color:#6B7280; margin-bottom:5px; }
        .field input, .field textarea { width:100%; padding:10px 12px; border:1px solid #E5E7EB; border-radius:10px; font-size:14px; }
        .modal-actions { display:flex; gap:10px; margin-top:20px; justify-content:flex-end; }
        .btn-cancel { background:#F3F4F6; color:#374151; border:none; padding:10px 20px; border-radius:10px; font-weight:700; cursor:pointer; }
        .btn-primary { background:#FF6600; color:#fff; border:none; padding:10px 20px; border-radius:10px; font-weight:700; cursor:pointer; }
        .toast { position:fixed; bottom:24px; right:24px; background:#111827; color:#fff; padding:12px 20px; border-radius:12px; font-size:13px; font-weight:600; z-index:9999; }
        .empty { text-align:center; padding:60px; color:#9CA3AF; }
        .price-info { font-size:12px; color:#6B7280; }
      `}</style>

      {toast && <div className="toast">{toast}</div>}

      <div className="toolbar">
        <input
          className="search-box"
          placeholder="🔍 Search by order ID, product, or customer..."
          value={q}
          onChange={e => setQ(e.target.value)}
        />
        <select className="sel" value={status} onChange={e => setStatus(e.target.value)}>
          {STATUS_OPTIONS.map(s => (
            <option key={s.key} value={s.key}>{s.label}</option>
          ))}
        </select>
      </div>

      {loading ? (
        <div className="empty">Loading orders...</div>
      ) : orders.length === 0 ? (
        <div className="empty">No orders found.</div>
      ) : (
        <table>
          <thead>
            <tr>
              <th>Order ID</th>
              <th>Product</th>
              <th>Customer</th>
              <th>Qty</th>
              <th>Pricing (USD)</th>
              <th>Status</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            {orders.map((o: any) => (
              <tr key={o.id}>
                <td>
                  <strong style={{ fontFamily: 'monospace', fontSize: 13 }}>{o.order_id}</strong>
                  <div style={{ fontSize: 10, color: '#9CA3AF' }}>
                    {new Date(o.created_at).toLocaleDateString()}
                  </div>
                </td>
                <td>
                  <div style={{ fontWeight: 600, maxWidth: 200, overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>
                    {o.product_name_en}
                  </div>
                  <div style={{ fontSize: 11, color: '#9CA3AF' }}>{o.site_name_en}</div>
                </td>
                <td>
                  <div style={{ fontWeight: 600 }}>{o.customerName}</div>
                  <div style={{ fontSize: 11, color: '#9CA3AF' }}>{o.customerBoxCode}</div>
                </td>
                <td style={{ fontWeight: 700 }}>×{o.quantity}</td>
                <td>
                  {o.unit_price_usd > 0 ? (
                    <div>
                      <div style={{ fontWeight: 700 }}>${o.total_price_usd?.toFixed(2)}</div>
                      <div className="price-info">${o.unit_price_usd?.toFixed(2)} × {o.quantity}</div>
                    </div>
                  ) : (
                    <span style={{ color: '#9CA3AF', fontSize: 12 }}>Not quoted</span>
                  )}
                </td>
                <td>{statusChip(o)}</td>
                <td>
                  <div style={{ display: 'flex', gap: 6, flexWrap: 'wrap' }}>
                    {(o.status === 'UNDER_REVIEW' || o.status === 'PRICE_PENDING') && (
                      <button
                        className="btn-sm btn-price"
                        onClick={() => setPricingModal({ id: o.id, orderId: o.order_id, product: o.product_name_en, qty: o.quantity })}
                      >
                        💰 Set Price
                      </button>
                    )}
                    <select
                      className="inline"
                      defaultValue=""
                      onChange={e => { if (e.target.value) handleSetStatus(o.id, e.target.value); }}
                    >
                      <option value="" disabled>Advance →</option>
                      {STATUS_OPTIONS
                        .filter(s => s.key !== 'all' && s.key !== o.status)
                        .map(s => (
                          <option key={s.key} value={s.key}>{s.label.replace(/^[^\s]+ /, '')}</option>
                        ))}
                    </select>
                  </div>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      )}

      {pricingModal && (
        <div className="modal-overlay" onClick={() => setPricingModal(null)}>
          <div className="modal" onClick={e => e.stopPropagation()}>
            <h3>💰 Set Quotation Price</h3>
            <p>
              <strong>{pricingModal.orderId}</strong> — {pricingModal.product} (×{pricingModal.qty})
              <br />
              The customer will be notified and asked to approve this quote.
            </p>
            <form onSubmit={handleSetPrice}>
              <div className="field">
                <label>Unit Price (USD) *</label>
                <input
                  required
                  type="number"
                  step="0.01"
                  min="0.01"
                  placeholder="e.g. 25.00"
                  value={priceInput}
                  onChange={e => setPriceInput(e.target.value)}
                />
                {priceInput && pricingModal.qty > 1 && (
                  <div style={{ fontSize: 12, color: '#6B7280', marginTop: 4 }}>
                    Total: ${(parseFloat(priceInput) * pricingModal.qty).toFixed(2)} USD
                  </div>
                )}
              </div>
              <div className="field">
                <label>Internal Notes</label>
                <textarea rows={2} placeholder="Optional notes for audit log..." value={priceNote} onChange={e => setPriceNote(e.target.value)} />
              </div>
              <div className="modal-actions">
                <button type="button" className="btn-cancel" onClick={() => setPricingModal(null)}>Cancel</button>
                <button type="submit" className="btn-primary" disabled={submittingPrice}>
                  {submittingPrice ? 'Sending...' : 'Send Quote to Customer'}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </AdminLayout>
  );
}
