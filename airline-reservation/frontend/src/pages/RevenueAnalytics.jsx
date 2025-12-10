import React, { useState } from 'react';
import { fetchRevenueRollup, fetchRevenueCube } from '../api/analytics';

export default function RevenueAnalytics() {
  const [fromDate, setFromDate] = useState('');
  const [toDate, setToDate] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const [rollup, setRollup] = useState([]);
  const [cube, setCube] = useState([]);

  const totalRevenue = (rows) => rows.reduce((sum, r) => sum + (Number(r.revenue) || 0), 0);
  const isAllRow = (r) => (r.origin === 'ALL' || r.destination === 'ALL' || r.month === 'ALL');

  const loadData = async () => {
    setLoading(true);
    setError('');
    try {
      const params = {};
      if (fromDate) params.from = fromDate;
      if (toDate) params.to = toDate;
      const [r, c] = await Promise.all([
        fetchRevenueRollup(params),
        fetchRevenueCube(params),
      ]);
      setRollup(r);
      setCube(c);
    } catch (err) {
      const msg = err?.response?.data?.detail || err?.message || '분석 조회 중 오류';
      setError(String(msg));
    } finally {
      setLoading(false);
    }
  };

  return (
    <div style={{ maxWidth: 1100, margin: '24px auto', padding: 16 }}>
      <h2 style={{ color: '#0a3d62', marginBottom: 16 }}>매출 분석 (ROLLUP / CUBE)</h2>
      <div style={{ display: 'flex', gap: 8, alignItems: 'center', marginBottom: 12 }}>
        <input type="date" value={fromDate} onChange={(e) => setFromDate(e.target.value)} />
        <span>~</span>
        <input type="date" value={toDate} onChange={(e) => setToDate(e.target.value)} />
        <button onClick={loadData} disabled={loading}>{loading ? '로딩…' : '조회'}</button>
      </div>
      {error && <div style={{ color: 'crimson', marginBottom: 12 }}>오류: {error}</div>}

      {/* Summary cards */}
      <div style={{ display: 'flex', gap: 16, marginBottom: 24 }}>
        <div style={{ flex: 1, background: '#eef5fb', border: '1px solid #d0e3f2', borderRadius: 8, padding: 12 }}>
          <div style={{ fontSize: 13, color: '#1b4f72' }}>기간</div>
          <div style={{ fontSize: 18, fontWeight: 600 }}>{fromDate || '무제한'} ~ {toDate || '무제한'}</div>
        </div>
        <div style={{ flex: 1, background: '#f7fcf2', border: '1px solid #d6ead1', borderRadius: 8, padding: 12 }}>
          <div style={{ fontSize: 13, color: '#1b5e20' }}>ROLLUP 총매출</div>
          <div style={{ fontSize: 20, fontWeight: 700 }}>{totalRevenue(rollup).toLocaleString()}</div>
        </div>
        <div style={{ flex: 1, background: '#fff7e6', border: '1px solid #ffe0b2', borderRadius: 8, padding: 12 }}>
          <div style={{ fontSize: 13, color: '#e65100' }}>CUBE 총매출</div>
          <div style={{ fontSize: 20, fontWeight: 700 }}>{totalRevenue(cube).toLocaleString()}</div>
        </div>
      </div>

      <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 16 }}>
        <div>
          <h3>ROLLUP 결과</h3>
          <table width="100%" border="0" cellPadding="6" style={{ borderCollapse: 'collapse' }}>
            <thead>
              <tr style={{ background: '#f3f4f6' }}>
                <th>Origin</th>
                <th>Destination</th>
                <th>Month</th>
                <th style={{ textAlign: 'right' }}>Revenue</th>
              </tr>
            </thead>
            <tbody>
              {rollup.map((row, idx) => {
                const highlight = isAllRow(row);
                return (
                  <tr key={idx} style={{ background: highlight ? '#fcfdff' : undefined }}>
                    <td style={{ textAlign: 'center', fontWeight: row.origin === 'ALL' ? 600 : 400 }}>{row.origin ?? ''}</td>
                    <td style={{ textAlign: 'center', fontWeight: row.destination === 'ALL' ? 600 : 400 }}>{row.destination ?? ''}</td>
                    <td style={{ textAlign: 'center', fontWeight: row.month === 'ALL' ? 600 : 400 }}>{row.month ?? ''}</td>
                    <td style={{ textAlign: 'right', fontWeight: highlight ? 600 : 400 }}>{Number(row.revenue || 0).toLocaleString()}</td>
                  </tr>
                );
              })}
              <tr>
                <td colSpan={3} style={{ paddingTop: 8, borderTop: '2px solid #ccc', textAlign: 'right', fontWeight: 700 }}>합계</td>
                <td style={{ paddingTop: 8, borderTop: '2px solid #ccc', textAlign: 'right', fontWeight: 700 }}>{totalRevenue(rollup).toLocaleString()}</td>
              </tr>
            </tbody>
          </table>
        </div>

        <div>
          <h3>CUBE 결과</h3>
          <table width="100%" border="0" cellPadding="6" style={{ borderCollapse: 'collapse' }}>
            <thead>
              <tr style={{ background: '#f3f4f6' }}>
                <th>Origin</th>
                <th>Destination</th>
                <th>Month</th>
                <th style={{ textAlign: 'right' }}>Revenue</th>
              </tr>
            </thead>
            <tbody>
              {cube.map((row, idx) => {
                const highlight = isAllRow(row);
                return (
                  <tr key={idx} style={{ background: highlight ? '#fcfdff' : undefined }}>
                    <td style={{ textAlign: 'center', fontWeight: row.origin === 'ALL' ? 600 : 400 }}>{row.origin ?? ''}</td>
                    <td style={{ textAlign: 'center', fontWeight: row.destination === 'ALL' ? 600 : 400 }}>{row.destination ?? ''}</td>
                    <td style={{ textAlign: 'center', fontWeight: row.month === 'ALL' ? 600 : 400 }}>{row.month ?? ''}</td>
                    <td style={{ textAlign: 'right', fontWeight: highlight ? 600 : 400 }}>{Number(row.revenue || 0).toLocaleString()}</td>
                  </tr>
                );
              })}
              <tr>
                <td colSpan={3} style={{ paddingTop: 8, borderTop: '2px solid #ccc', textAlign: 'right', fontWeight: 700 }}>합계</td>
                <td style={{ paddingTop: 8, borderTop: '2px solid #ccc', textAlign: 'right', fontWeight: 700 }}>{totalRevenue(cube).toLocaleString()}</td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
}
