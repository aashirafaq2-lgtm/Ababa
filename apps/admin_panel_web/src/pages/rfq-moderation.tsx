import React from 'react';
import AdminLayout from '../components/layout/AdminLayout';

export default function RFQModeration() {
    return (
        <AdminLayout title="Global RFQ Governance Area">
            <div className="alert-box">
                <span className="icon">⚠️</span>
                <div className="text">
                    <strong>Moderation Protocol Active</strong>
                    <p>All automated 1688 supplier bidding is active. Monitor flagged or high-volume RFQs manually to ensure fair B2B trade practices.</p>
                </div>
            </div>

            <div className="card">
                <div className="header-flex">
                    <h3>Active Requests For Quotation (RFQ)</h3>
                    <div className="filters">
                        <button className="active">Pending Review</button>
                        <button>Live Bidding</button>
                        <button>Closed / Matched</button>
                    </div>
                </div>

                <table className="rfq-table">
                    <thead>
                        <tr>
                            <th>RFQ Reference</th>
                            <th>Product Details</th>
                            <th>Target Quantity</th>
                            <th>Buyer Region</th>
                            <th>Bids Received</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td><span className="mono">REQ-89012</span></td>
                            <td><strong>Industrial Cotton Roles (Grade A)</strong><br /><span className="subtext">Requires specific thread count</span></td>
                            <td>10,000 Kg</td>
                            <td>Dubai, UAE</td>
                            <td><span className="bids-badge">12 Bids</span></td>
                            <td><button className="btn-action">Review Bids</button></td>
                        </tr>
                        <tr>
                            <td><span className="mono">REQ-89011</span></td>
                            <td><strong>Custom Printed Circuit Boards (PCB)</strong><br /><span className="subtext">Gerber files attached</span></td>
                            <td>5,000 Pieces</td>
                            <td>Karachi, PK</td>
                            <td><span className="bids-badge">4 Bids</span></td>
                            <td><button className="btn-action">Review Bids</button></td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <style jsx>{`
        .alert-box { display: flex; align-items: flex-start; padding: 16px; background: #FFFBEB; border: 1px solid #FDE68A; border-radius: 8px; margin-bottom: 30px; }
        .alert-box .icon { font-size: 20px; margin-right: 12px; }
        .alert-box strong { display: block; color: #92400E; font-size: 14px; margin-bottom: 4px; }
        .alert-box p { color: #B45309; font-size: 13px; margin: 0; }
        
        .card { background: white; padding: 24px; border-radius: 12px; border: 1px solid #E5E7EB; }
        .header-flex { display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px; }
        .header-flex h3 { font-size: 18px; font-weight: 900; }
        
        .filters button { padding: 8px 16px; border: 1px solid #E5E7EB; background: white; color: #6B7280; font-size: 13px; font-weight: 600; cursor: pointer; }
        .filters button:first-child { border-radius: 6px 0 0 6px; }
        .filters button:last-child { border-radius: 0 6px 6px 0; }
        .filters button.active { background: #F3F4F6; color: #111827; border-color: #D1D5DB; }
        
        .rfq-table { width: 100%; border-collapse: collapse; }
        .rfq-table th { text-align: left; padding: 12px; background: #F9FAFB; color: #6B7280; font-size: 12px; font-weight: 800; border-bottom: 1px solid #E5E7EB; }
        .rfq-table td { padding: 16px 12px; border-bottom: 1px solid #F3F4F6; font-size: 14px; }
        
        .mono { font-family: monospace; font-weight: 600; color: #1F2937; }
        .subtext { color: #6B7280; font-size: 12px; margin-top: 4px; display: inline-block; }
        
        .bids-badge { background: #FEF3C7; color: #D97706; padding: 4px 10px; border-radius: 12px; font-size: 12px; font-weight: bold; }
        
        .btn-action { background: #FF6600; color: white; border: none; padding: 8px 16px; border-radius: 6px; font-weight: 600; cursor: pointer; transition: 0.2s; }
        .btn-action:hover { background: #E65C00; }
      `}</style>
        </AdminLayout>
    );
}
