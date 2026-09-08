import React from 'react';

const APIDiscoveryPage = () => {
    const routes = [
        { method: 'GET', endpoint: '/api/v1/catalog/sync', service: 'Catalog', status: 'Healthy' },
        { method: 'POST', endpoint: '/api/v1/trade/escrow/init', service: 'Order', status: 'Healthy' },
        { method: 'GET', endpoint: '/api/v1/logistics/estimate', service: 'Logistics', status: 'Maintenance' },
        { method: 'POST', endpoint: '/api/v1/auth/refresh', service: 'Auth', status: 'Healthy' },
    ];

    return (
        <div className="p-8 bg-gray-50 min-h-screen">
            <h1 className="text-3xl font-black mb-8 text-orange-600">AHMEDBABA SERVICE AUDIT</h1>
            <div className="bg-white rounded-xl shadow-sm overflow-hidden border border-gray-100">
                <table className="w-full text-left">
                    <thead className="bg-gray-50 border-b border-gray-100">
                        <tr>
                            <th className="p-4 font-bold text-gray-600">Method</th>
                            <th className="p-4 font-bold text-gray-600">Endpoint</th>
                            <th className="p-4 font-bold text-gray-600">Upstream Service</th>
                            <th className="p-4 font-bold text-gray-600">Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        {routes.map((r, i) => (
                            <tr key={i} className="hover:bg-gray-50 border-b border-gray-100 transition-colors">
                                <td className="p-4"><span className="px-3 py-1 bg-blue-100 text-blue-700 rounded-md text-xs font-black">{r.method}</span></td>
                                <td className="p-4 font-mono text-sm">{r.endpoint}</td>
                                <td className="p-4 text-sm font-medium">{r.service}</td>
                                <td className="p-4">
                                    <div className="flex items-center gap-2">
                                        <div className={`w-2 h-2 rounded-full ${r.status === 'Healthy' ? 'bg-green-500' : 'bg-orange-500'}`} />
                                        <span className="text-sm">{r.status}</span>
                                    </div>
                                </td>
                            </tr>
                        ))}
                    </tbody>
                </table>
            </div>
        </div>
    );
};

export default APIDiscoveryPage;
