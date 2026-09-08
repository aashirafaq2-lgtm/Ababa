import React, { useEffect, useState } from 'react';
import AdminLayout from '../components/layout/AdminLayout';
import { AuditService } from '../services/api';

const ACTION_COLORS: Record<string, string> = {
  PACKAGE_CHECK_IN:    '#0D9488',
  PACKAGE_UPDATE:      '#2563EB',
  ORDER_PRICING_SET:   '#D97706',
  ORDER_STATUS_CHANGE: '#9333EA',
  SHIPPING_RATE_UPDATE:'#FF6600',
};

export default function AuditLogsPage() {
  const [logs, setLogs] = useState<any[]>([]);
  const [q, setQ] = useState('');
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    setLoading(true);
    AuditService.list(200, q || undefined)
      .then(r => setLogs(r.data.logs || []))
      .catch(() => setLogs([]))
      .finally(() => setLoading(false));
  }, [q]);

  return (
    <AdminLayout title="Admin Audit Log">
      <style>{`
        .toolbar { display:flex; gap:12px; margin-bottom:20px; align-items:center; }
        .search-box { flex:1; padding:10px 14px; border:1px solid #E5E7EB; border-radius:10px; font-size:14px; }
        table { width:100%; border-collapse:collapse; background:#fff; border-radius:14px; overflow:hidden; border:1px solid #E5E7EB; }
        th { text-align:left; padding:12px 16px; font-size:11px; color:#9CA3AF; font-weight:700; text-transform:uppercase; background:#FAFAFA; border-bottom:2px solid #E5E7EB; }
        td { padding:12px 16px; font-size:13px; color:#374151; border-bottom:1px solid #F3F4F6; vertical-align:top; }
        tr:last-child td { border-bottom:none; }
        tr:hover td { background:#FAFAFA; }
        .action-badge { display:inline-block; padding:3px 10px; border-radius:20px; font-size:10px; font-weight:800; letter-spacing:.5px; background:#F3F4F6; color:#374151; }
        .entity-pill { font-family:monospace; font-size:11px; background:#F9FAFB; border:1px solid #E5E7EB; border-radius:6px; padding:2px 7px; color:#374151; }
        .diff { font-size:11px; color:#6B7280; max-width:280px; word-break:break-all; }
        .empty { text-align:center; padding:60px; color:#9CA3AF; }
        .ts { font-size:11px; color:#9CA3AF; white-space:nowrap; }
      `}</style>

      <div className="toolbar">
        <input
          className="search-box"
          placeholder="🔍 Filter by action, admin name, or entity ID..."
          value={q}
          onChange={e => setQ(e.target.value)}
        />
        <span style={{ fontSize:13, color:'#9CA3AF', whiteSpace:'nowrap' }}>
          {logs.length} entr{logs.length !== 1 ? 'ies' : 'y'}
        </span>
      </div>

      {loading ? (
        <div className="empty">Loading audit log...</div>
      ) : logs.length === 0 ? (
        <div className="empty">No audit entries found.</div>
      ) : (
        <table>
          <thead>
            <tr>
              <th>Timestamp</th>
              <th>Action</th>
              <th>Admin</th>
              <th>Entity</th>
              <th>Changes</th>
            </tr>
          </thead>
          <tbody>
            {logs.map((l: any, i: number) => {
              const color = ACTION_COLORS[l.action] || '#6B7280';
              let newVals = '';
              try { newVals = JSON.stringify(l.new_values || {}, null, 0); } catch { newVals = ''; }

              return (
                <tr key={l.id || i}>
                  <td className="ts">{l.created_at ? new Date(l.created_at).toLocaleString() : '—'}</td>
                  <td>
                    <span className="action-badge" style={{ background: color + '18', color }}>
                      {l.action}
                    </span>
                  </td>
                  <td style={{ fontWeight: 600 }}>{l.admin_name || '—'}</td>
                  <td>
                    <div style={{ fontWeight:600, fontSize:12 }}>{l.entity_type}</div>
                    <span className="entity-pill">{l.entity_id}</span>
                  </td>
                  <td>
                    <div className="diff">{newVals}</div>
                  </td>
                </tr>
              );
            })}
          </tbody>
        </table>
      )}
    </AdminLayout>
  );
}
