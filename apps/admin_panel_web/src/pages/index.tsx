import React, { useState } from 'react';
import Head from 'next/head';
import { useRouter } from 'next/router';
import { AdminAuthService } from '../services/api';

export default function AdminLogin() {
  const router = useRouter();
  const [identity, setIdentity] = useState('');
  const [password, setPassword] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    setError('');
    setLoading(true);
    try {
      const res = await AdminAuthService.signIn(identity.trim(), password);
      const { token, user } = res.data;

      if (!token) throw new Error('No token returned');
      if (user.role !== 'ADMIN' && user.role !== 'STAFF') {
        setError('Access denied. You do not have admin privileges.');
        return;
      }

      localStorage.setItem('ahmedbaba_admin_token', token);
      localStorage.setItem('ahmedbaba_admin_identity', user.identity || identity);
      router.push('/dashboard');
    } catch (err: any) {
      const msg = err?.response?.data?.error || err?.message || 'Login failed';
      setError(msg);
    } finally {
      setLoading(false);
    }
  };

  return (
    <>
      <Head>
        <title>Admin Login | A.BABA Console</title>
        <meta name="robots" content="noindex,nofollow" />
        <link
          href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800;900&display=swap"
          rel="stylesheet"
        />
      </Head>

      <div className="login-root">
        <div className="login-card">
          {/* Logo */}
          <div className="logo-area">
            <div className="logo-mark">A</div>
            <div>
              <div className="logo-name">A.BABA</div>
              <div className="logo-sub">ADMIN CONSOLE</div>
            </div>
          </div>

          <h1 className="login-title">Sign in to Admin</h1>
          <p className="login-sub">For authorised staff only</p>

          {error && (
            <div className="error-box">⚠️ {error}</div>
          )}

          <form onSubmit={handleLogin}>
            <div className="field">
              <label htmlFor="identity">Email / Phone</label>
              <input
                id="identity"
                type="text"
                placeholder="admin@ahmedbaba.com"
                value={identity}
                onChange={e => setIdentity(e.target.value)}
                required
                autoComplete="username"
              />
            </div>
            <div className="field">
              <label htmlFor="password">Password</label>
              <input
                id="password"
                type="password"
                placeholder="••••••••"
                value={password}
                onChange={e => setPassword(e.target.value)}
                required
                autoComplete="current-password"
              />
            </div>
            <button type="submit" className="btn-login" disabled={loading}>
              {loading ? 'Signing in...' : 'Sign In →'}
            </button>
          </form>

          <p className="hint">
            Default demo admin: <strong>admin@ahmedbaba.com</strong>
          </p>
        </div>
      </div>

      <style global jsx>{`
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        body {
          font-family: 'Inter', -apple-system, sans-serif;
          background: linear-gradient(135deg, #FF6600 0%, #FF9900 100%);
          min-height: 100vh;
        }
        .login-root {
          min-height: 100vh;
          display: flex;
          align-items: center;
          justify-content: center;
          padding: 24px;
        }
        .login-card {
          background: #fff;
          border-radius: 20px;
          padding: 40px;
          width: 100%;
          max-width: 420px;
          box-shadow: 0 20px 60px rgba(0,0,0,.15);
        }
        .logo-area {
          display: flex;
          align-items: center;
          gap: 12px;
          margin-bottom: 32px;
        }
        .logo-mark {
          width: 44px; height: 44px;
          background: linear-gradient(135deg, #FF6600, #FF9900);
          border-radius: 12px;
          display: flex; align-items: center; justify-content: center;
          color: #fff; font-weight: 900; font-size: 22px;
        }
        .logo-name { font-size: 18px; font-weight: 900; color: #111827; }
        .logo-sub  { font-size: 10px; font-weight: 700; color: #9CA3AF; letter-spacing: 1.5px; }
        .login-title { font-size: 24px; font-weight: 900; color: #111827; margin-bottom: 4px; }
        .login-sub { font-size: 14px; color: #9CA3AF; margin-bottom: 24px; }
        .error-box {
          background: #FEF2F2;
          color: #B91C1C;
          border: 1px solid #FECACA;
          border-radius: 10px;
          padding: 12px 16px;
          font-size: 13px;
          font-weight: 600;
          margin-bottom: 16px;
        }
        .field { margin-bottom: 16px; }
        .field label {
          display: block;
          font-size: 12px;
          font-weight: 700;
          color: #374151;
          margin-bottom: 6px;
          text-transform: uppercase;
          letter-spacing: .5px;
        }
        .field input {
          width: 100%;
          padding: 12px 14px;
          border: 1.5px solid #E5E7EB;
          border-radius: 10px;
          font-size: 14px;
          color: #111827;
          transition: border-color .15s;
        }
        .field input:focus {
          outline: none;
          border-color: #FF6600;
        }
        .btn-login {
          width: 100%;
          padding: 14px;
          background: linear-gradient(135deg, #FF6600, #FF9900);
          color: #fff;
          border: none;
          border-radius: 12px;
          font-size: 15px;
          font-weight: 800;
          cursor: pointer;
          margin-top: 8px;
          transition: opacity .15s;
        }
        .btn-login:hover:not(:disabled) { opacity: .9; }
        .btn-login:disabled { opacity: .6; cursor: not-allowed; }
        .hint {
          margin-top: 20px;
          font-size: 12px;
          color: #9CA3AF;
          text-align: center;
        }
      `}</style>
    </>
  );
}
