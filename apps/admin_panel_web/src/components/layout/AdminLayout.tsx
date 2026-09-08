import React, { useEffect, useState } from 'react';
import Head from 'next/head';
import Link from 'next/link';
import { useRouter } from 'next/router';

interface Props {
  children: React.ReactNode;
  title: string;
}

const NAV_LINKS = [
  { href: '/dashboard',     label: '📊 Dashboard',          },
  { href: '/packages',      label: '📦 Packages (China Box)' },
  { href: '/futian-orders', label: '🛒 Futian Orders'        },
  { href: '/customers',     label: '👥 Customers'            },
  { href: '/shipping-rates',label: '🚢 Shipping Rates'       },
  { href: '/audit-logs',    label: '📋 Audit Logs'           },
];

const AdminLayout: React.FC<Props> = ({ children, title }) => {
  const router = useRouter();
  const [adminName, setAdminName] = useState('Admin');

  useEffect(() => {
    // read stored identity if available
    if (typeof window !== 'undefined') {
      const identity = localStorage.getItem('ahmedbaba_admin_identity');
      if (identity) setAdminName(identity);
    }
  }, []);

  const handleLogout = () => {
    if (typeof window !== 'undefined') {
      localStorage.removeItem('ahmedbaba_admin_token');
      localStorage.removeItem('ahmedbaba_admin_identity');
      router.push('/');
    }
  };

  return (
    <>
      <Head>
        <title>{title} | A.BABA Admin Console</title>
        <meta name="robots" content="noindex,nofollow" />
        <link
          href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap"
          rel="stylesheet"
        />
      </Head>

      <div className="admin-root">
        {/* ─── Sidebar ─────────────────────────────────────────── */}
        <aside className="sidebar">
          <div className="logo-area">
            <span className="logo-mark">A</span>
            <div>
              <div className="logo-name">A.BABA</div>
              <div className="logo-sub">ADMIN CONSOLE</div>
            </div>
          </div>

          <nav className="nav">
            {NAV_LINKS.map(({ href, label }) => {
              const active = router.pathname === href;
              return (
                <Link key={href} href={href} className={`nav-item${active ? ' active' : ''}`}>
                  {label}
                </Link>
              );
            })}
          </nav>

          <button className="logout-btn" onClick={handleLogout}>
            🚪 Sign Out
          </button>
        </aside>

        {/* ─── Main ────────────────────────────────────────────── */}
        <main className="main">
          <header className="topbar">
            <h1 className="page-title">{title}</h1>
            <div className="user-pill">
              <div className="avatar">{adminName.charAt(0).toUpperCase()}</div>
              <span>{adminName}</span>
            </div>
          </header>

          <div className="content">{children}</div>
        </main>
      </div>

      <style global jsx>{`
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        body {
          font-family: 'Inter', -apple-system, sans-serif;
          background: #F8F9FB;
          color: #111827;
        }
        a { text-decoration: none; }

        .admin-root { display: flex; min-height: 100vh; }

        /* Sidebar */
        .sidebar {
          width: 240px;
          background: #fff;
          border-right: 1px solid #E5E7EB;
          display: flex;
          flex-direction: column;
          padding: 24px 16px;
          position: fixed;
          top: 0; left: 0; bottom: 0;
          z-index: 100;
        }
        .logo-area {
          display: flex;
          align-items: center;
          gap: 12px;
          margin-bottom: 32px;
          padding: 0 8px;
        }
        .logo-mark {
          width: 38px; height: 38px;
          background: linear-gradient(135deg, #FF6600, #FF9900);
          border-radius: 10px;
          display: flex; align-items: center; justify-content: center;
          color: #fff; font-weight: 900; font-size: 18px;
          flex-shrink: 0;
        }
        .logo-name { font-size: 16px; font-weight: 900; color: #111827; }
        .logo-sub  { font-size: 9px; font-weight: 700; color: #9CA3AF; letter-spacing: 1.5px; }

        .nav { display: flex; flex-direction: column; gap: 4px; flex: 1; }
        .nav-item {
          display: block;
          padding: 10px 14px;
          border-radius: 10px;
          font-size: 13px;
          font-weight: 500;
          color: #6B7280;
          transition: all .15s;
        }
        .nav-item:hover { background: #FFF5F0; color: #FF6600; }
        .nav-item.active { background: #FFF5F0; color: #FF6600; font-weight: 700; }

        .logout-btn {
          margin-top: 12px;
          background: none;
          border: 1px solid #E5E7EB;
          border-radius: 10px;
          padding: 10px 14px;
          font-size: 13px;
          font-weight: 600;
          color: #6B7280;
          cursor: pointer;
          text-align: left;
          transition: all .15s;
        }
        .logout-btn:hover { background: #FEF2F2; color: #B91C1C; border-color: #FECACA; }

        /* Main */
        .main {
          margin-left: 240px;
          flex: 1;
          display: flex;
          flex-direction: column;
        }
        .topbar {
          background: #fff;
          border-bottom: 1px solid #E5E7EB;
          padding: 16px 32px;
          display: flex;
          align-items: center;
          justify-content: space-between;
          position: sticky;
          top: 0;
          z-index: 50;
        }
        .page-title { font-size: 17px; font-weight: 800; color: #111827; }
        .user-pill {
          display: flex; align-items: center; gap: 10px;
          font-size: 13px; font-weight: 600; color: #374151;
        }
        .avatar {
          width: 34px; height: 34px; border-radius: 50%;
          background: linear-gradient(135deg, #FF6600, #FF9900);
          color: #fff; font-weight: 800; font-size: 14px;
          display: flex; align-items: center; justify-content: center;
        }
        .content { padding: 28px 32px; }
      `}</style>
    </>
  );
};

export default AdminLayout;
