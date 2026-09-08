import React, { useEffect, useState } from 'react';
import AdminLayout from '../components/layout/AdminLayout';
import { OverviewService } from '../services/api';

interface Metrics {
  totalCustomers: number;
  activeCustomers: number;
  chinaBoxAccounts: number;
  packagesInWarehouse: number;
  readyForConsolidation: number;
  consolidationRequests: number;
  activeShipments: number;
  futian: {
    total: number;
    underReview: number;
    pricePending: number;
    approvalPending: number;
    purchased: number;
    shipped: number;
    arrived: number;
    cancelled: number;
  };
  auditLogsCount: number;
}

export default function Dashboard() {
  const [metrics, setMetrics] = useState<Metrics | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [ts, setTs] = useState('');

  useEffect(() => {
    OverviewService.getMetrics()
      .then((r) => {
        setMetrics(r.data.metrics);
        setTs(r.data.timestamp);
      })
      .catch(() => setError('Failed to load metrics — is the backend running?'))
      .finally(() => setLoading(false));
  }, []);

  const stat = (v: number | undefined) => (v ?? 0).toLocaleString();

  return (
    <AdminLayout title="Operations Dashboard">
      <style>{`
        .dash-header { display:flex; align-items:center; justify-content:space-between; margin-bottom:28px; }
        .dash-header h2 { font-size:22px; font-weight:900; color:#111827; }
        .ts-label { font-size:12px; color:#9CA3AF; }
        .section-title { font-size:13px; font-weight:700; color:#6B7280; text-transform:uppercase; letter-spacing:1px; margin:28px 0 14px; }
        .cards { display:grid; grid-template-columns:repeat(4,1fr); gap:16px; }
        .cards-3 { display:grid; grid-template-columns:repeat(3,1fr); gap:16px; }
        .card { background:#fff; border:1px solid #E5E7EB; border-radius:14px; padding:22px; }
        .card-accent { border-left:4px solid var(--accent,#FF6600); }
        .card label { font-size:12px; font-weight:600; color:#9CA3AF; text-transform:uppercase; letter-spacing:.6px; }
        .card .val { font-size:32px; font-weight:900; color:#111827; margin:6px 0 2px; }
        .card .sub { font-size:12px; color:#6B7280; }
        .card.orange { --accent:#FF6600; }
        .card.blue { --accent:#2563EB; }
        .card.green { --accent:#16A34A; }
        .card.purple { --accent:#9333EA; }
        .card.amber { --accent:#D97706; }
        .card.teal { --accent:#0D9488; }
        .card.red { --accent:#EF4444; }
        .card.indigo { --accent:#4F46E5; }
        .futian-grid { display:grid; grid-template-columns:repeat(4,1fr); gap:12px; }
        .f-chip { background:#fff; border:1px solid #E5E7EB; border-radius:10px; padding:16px; display:flex; flex-direction:column; align-items:flex-start; gap:4px; }
        .f-chip .n { font-size:26px; font-weight:900; }
        .f-chip .l { font-size:11px; font-weight:600; color:#6B7280; }
        .err { background:#FEF2F2; color:#B91C1C; border:1px solid #FECACA; border-radius:10px; padding:16px; margin-bottom:16px; }
        .skeleton { background:linear-gradient(90deg,#F3F4F6 25%,#E5E7EB 50%,#F3F4F6 75%); background-size:200% 100%; animation:shimmer 1.5s infinite; border-radius:14px; height:100px; }
        @keyframes shimmer { 0%{background-position:200% 0} 100%{background-position:-200% 0} }
      `}</style>

      <div className="dash-header">
        <h2>📊 Live Operations Overview</h2>
        {ts && <span className="ts-label">Last updated: {new Date(ts).toLocaleTimeString()}</span>}
      </div>

      {error && <div className="err">⚠️ {error}</div>}

      {loading ? (
        <div className="cards">
          {Array.from({ length: 8 }).map((_, i) => (
            <div key={i} className="skeleton" />
          ))}
        </div>
      ) : metrics ? (
        <>
          <div className="section-title">👥 Customers</div>
          <div className="cards">
            <div className="card card-accent orange">
              <label>Total Customers</label>
              <div className="val">{stat(metrics.totalCustomers)}</div>
              <div className="sub">All registered users</div>
            </div>
            <div className="card card-accent green">
              <label>Active Customers</label>
              <div className="val">{stat(metrics.activeCustomers)}</div>
              <div className="sub">Status: ACTIVE</div>
            </div>
            <div className="card card-accent blue">
              <label>China Box Accounts</label>
              <div className="val">{stat(metrics.chinaBoxAccounts)}</div>
              <div className="sub">With assigned box codes</div>
            </div>
            <div className="card card-accent teal">
              <label>Audit Log Entries</label>
              <div className="val">{stat(metrics.auditLogsCount)}</div>
              <div className="sub">Admin operations recorded</div>
            </div>
          </div>

          <div className="section-title">📦 My China Box</div>
          <div className="cards-3">
            <div className="card card-accent blue">
              <label>Packages in Warehouse</label>
              <div className="val">{stat(metrics.packagesInWarehouse)}</div>
              <div className="sub">Awaiting consolidation</div>
            </div>
            <div className="card card-accent amber">
              <label>Ready for Consolidation</label>
              <div className="val">{stat(metrics.readyForConsolidation)}</div>
              <div className="sub">Customer-approved</div>
            </div>
            <div className="card card-accent purple">
              <label>Consolidation Requests</label>
              <div className="val">{stat(metrics.consolidationRequests)}</div>
              <div className="sub">Awaiting processing</div>
            </div>
          </div>

          <div className="section-title">🛒 Purchases from Futian</div>
          <div className="futian-grid">
            <div className="f-chip">
              <span className="n" style={{ color: '#111827' }}>{stat(metrics.futian.total)}</span>
              <span className="l">All Orders</span>
            </div>
            <div className="f-chip">
              <span className="n" style={{ color: '#FF5500' }}>{stat(metrics.futian.underReview)}</span>
              <span className="l">Under Review</span>
            </div>
            <div className="f-chip">
              <span className="n" style={{ color: '#D97706' }}>{stat(metrics.futian.pricePending)}</span>
              <span className="l">Price Pending</span>
            </div>
            <div className="f-chip">
              <span className="n" style={{ color: '#9333EA' }}>{stat(metrics.futian.approvalPending)}</span>
              <span className="l">Awaiting Approval</span>
            </div>
            <div className="f-chip">
              <span className="n" style={{ color: '#2563EB' }}>{stat(metrics.futian.purchased)}</span>
              <span className="l">Purchased</span>
            </div>
            <div className="f-chip">
              <span className="n" style={{ color: '#0D9488' }}>{stat(metrics.futian.shipped)}</span>
              <span className="l">Shipped</span>
            </div>
            <div className="f-chip">
              <span className="n" style={{ color: '#16A34A' }}>{stat(metrics.futian.arrived)}</span>
              <span className="l">Arrived</span>
            </div>
            <div className="f-chip">
              <span className="n" style={{ color: '#EF4444' }}>{stat(metrics.futian.cancelled)}</span>
              <span className="l">Cancelled</span>
            </div>
          </div>
        </>
      ) : null}
    </AdminLayout>
  );
}
