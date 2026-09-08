import AdminLayout from '../components/layout/AdminLayout';
import React, { useState } from 'react';

export default function ApiManagement() {
    const [syncStatus, setSyncStatus] = useState('ACTIVE');

    return (
        <AdminLayout title="1688 API Control Center">
            <div className="card">
                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                    <h3>Global Sync Hub</h3>
                    <span className={`status-badge ${syncStatus.toLowerCase()}`}>{syncStatus}</span>
                </div>
                <p style={{ color: 'var(--text-secondary)', marginTop: '8px' }}>
                    Managing connectivity with Alibaba 1688 Open Platform.
                </p>

                <div className="sync-stats">
                    <div className="stat-box">
                        <span className="label">Last Full Sync</span>
                        <span className="value">May 13, 01:45 AM</span>
                    </div>
                    <div className="stat-box">
                        <span className="label">Products Indexed</span>
                        <span className="value">1.4M+</span>
                    </div>
                    <div className="stat-box">
                        <span className="label">Sync Success Rate</span>
                        <span className="value">99.8%</span>
                    </div>
                </div>

                <div className="control-section">
                    <h4>API Authentication</h4>
                    <div className="input-group">
                        <label>App Key</label>
                        <input type="text" defaultValue="8821992102" />
                    </div>
                    <div className="input-group">
                        <label>App Secret</label>
                        <input type="password" defaultValue="••••••••••••••••" />
                    </div>
                    <button className="btn-primary">Safe Update Credentials</button>
                </div>

                <div className="control-section">
                    <h4>Smart Price Markup (Global)</h4>
                    <p style={{ fontSize: '13px', color: '#666', marginBottom: '15px' }}>
                        This percentage is automatically added to the 1688 landing price to calculate AhmedBaba retail price.
                    </p>
                    <div className="markup-slider">
                        <input type="range" min="0" max="100" defaultValue="15" className="slider" />
                        <span className="percentage">15%</span>
                    </div>
                    <button className="btn-secondary">Apply Global Pricing Rule</button>
                </div>
            </div>

            <style jsx>{`
        .sync-stats { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; margin: 30px 0; }
        .stat-box { background: #F8FAFC; padding: 20px; border-radius: 12px; border: 1px solid #E2E8F0; }
        .stat-box .label { display: block; color: var(--text-secondary); font-size: 12px; font-weight: 600; margin-bottom: 8px; }
        .stat-box .value { font-size: 18px; font-weight: 800; color: var(--primary); }
        
        .status-badge { padding: 4px 12px; border-radius: 20px; font-size: 12px; font-weight: 800; text-transform: uppercase; }
        .status-badge.active { background: #DCFCE7; color: #166534; }
        
        .control-section { margin-top: 40px; padding-top: 30px; border-top: 1px solid var(--border); }
        .input-group { margin-bottom: 20px; }
        .input-group label { display: block; font-size: 13px; font-weight: 600; margin-bottom: 8px; }
        .input-group input { width: 100%; padding: 12px; border: 1px solid var(--border); border-radius: 8px; font-family: monospace; }
        
        .markup-slider { display: flex; align-items: center; gap: 20px; margin-bottom: 20px; }
        .slider { flex: 1; accent-color: var(--primary); }
        .percentage { font-size: 20px; font-weight: 800; min-width: 60px; }
        
        h4 { margin-bottom: 20px; font-size: 16px; font-weight: 800; }
      `}</style>
        </AdminLayout>
    );
}
