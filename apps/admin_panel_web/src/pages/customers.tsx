import React, { useEffect, useState } from 'react';
import AdminLayout from '../components/layout/AdminLayout';
import { CustomerService } from '../services/api';

export default function CustomersPage() {
  const [customers, setCustomers] = useState<any[]>([]);
  const [q, setQ] = useState('');
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    setLoading(true);
    CustomerService.list(q || undefined)
      .then(r => setCustomers(r.data.customers || []))
      .catch(() => setCustomers([]))
      .finally(() => setLoading(false));
  }, [q]);

  return (
    <AdminLayout title="Customer Management">
      <style>{`
        .toolbar { display:flex; gap:12px; margin-bottom:20px; align-items:center; }
        .search-box { flex:1; padding:10px 14px; border:1px solid #E5E7EB; border-radius:10px; font-size:14px; }
        table { width:100%; border-collapse:collapse; background:#fff; border-radius:14px; overflow:hidden; border:1px solid #E5E7EB; }
        th { text-align:left; padding:12px 16px; font-size:11px; color:#9CA3AF; font-weight:700; text-transform:uppercase; background:#FAFAFA; border-bottom:2px solid #E5E7EB; }
        td { padding:14px 16px; font-size:13px; color:#374151; border-bottom:1px solid #F3F4F6; }
        tr:last-child td { border-bottom:none; }
        tr:hover td { background:#FAFAFA; }
        .badge-active { background:#F0FDF4; color:#16A34A; padding:3px 10px; border-radius:20px; font-size:11px; font-weight:700; }
        .badge-susp { background:#FEF2F2; color:#B91C1C; padding:3px 10px; border-radius:20px; font-size:11px; font-weight:700; }
        .empty { text-align:center; padding:60px; color:#9CA3AF; }
        .box-code { font-family:monospace; font-size:13px; font-weight:700; color:#FF6600; background:#FFF5F0; padding:3px 8px; border-radius:6px; }
        .stat-pill { font-size:11px; color:#6B7280; }
      `}</style>

      <div className="toolbar">
        <input
          className="search-box"
          placeholder="🔍 Search by name, phone/email, or box code..."
          value={q}
          onChange={e => setQ(e.target.value)}
        />
        <span style={{ fontSize: 13, color: '#9CA3AF', whiteSpace: 'nowrap' }}>
          {customers.length} customer{customers.length !== 1 ? 's' : ''}
        </span>
      </div>

      {loading ? (
        <div className="empty">Loading customers...</div>
      ) : customers.length === 0 ? (
        <div className="empty">No customers found.</div>
      ) : (
        <table>
          <thead>
            <tr>
              <th>Name</th>
              <th>Contact</th>
              <th>Box Code</th>
              <th>Packages</th>
              <th>Orders</th>
              <th>Status</th>
              <th>Joined</th>
            </tr>
          </thead>
          <tbody>
            {customers.map((c: any) => (
              <tr key={c.id}>
                <td>
                  <strong>{c.fullName}</strong>
                </td>
                <td>
                  <div style={{ fontSize: 13 }}>{c.identity}</div>
                  {c.phone && c.phone !== c.identity && (
                    <div className="stat-pill">{c.phone}</div>
                  )}
                </td>
                <td>
                  <span className="box-code">{c.boxCode || '—'}</span>
                </td>
                <td style={{ fontWeight: 700 }}>{c.packageCount ?? 0}</td>
                <td style={{ fontWeight: 700 }}>{c.orderCount ?? 0}</td>
                <td>
                  {c.status === 'ACTIVE'
                    ? <span className="badge-active">ACTIVE</span>
                    : <span className="badge-susp">SUSPENDED</span>}
                </td>
                <td className="stat-pill">
                  {c.createdAt ? new Date(c.createdAt).toLocaleDateString() : '—'}
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      )}
    </AdminLayout>
  );
}
