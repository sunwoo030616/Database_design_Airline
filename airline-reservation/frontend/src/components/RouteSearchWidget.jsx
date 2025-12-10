import React, { useState } from 'react';
import { fetchShortestPath } from '../api/routes';

export default function RouteSearchWidget() {
  const [origin, setOrigin] = useState('');
  const [destination, setDestination] = useState('');
  const [mode, setMode] = useState('distance'); // distance | duration | hops
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const [result, setResult] = useState(null);

  const onSearch = async (e) => {
    e?.preventDefault?.();
    setLoading(true);
    setError('');
    setResult(null);
    try {
      if (mode === 'distance') {
        const data = await fetchShortestPath(origin.trim(), destination.trim());
        setResult(data);
      } else {
        setError('해당 모드는 아직 준비 중입니다. 거리 기준을 사용하세요.');
      }
    } catch (err) {
      const msg = err?.response?.data?.detail || err?.message || '검색 중 오류가 발생했습니다';
      setError(String(msg));
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="route-widget">
      <h3>최단 경로 검색</h3>
      <form onSubmit={onSearch} className="route-widget-form">
        <input
          value={origin}
          onChange={(e) => setOrigin(e.target.value.toUpperCase())}
          placeholder="출발 (예: ICN)"
        />
        <span className="arrow">→</span>
        <input
          value={destination}
          onChange={(e) => setDestination(e.target.value.toUpperCase())}
          placeholder="도착 (예: LAX)"
        />
        <select value={mode} onChange={(e) => setMode(e.target.value)}>
          <option value="distance">거리</option>
          <option value="duration">시간(준비중)</option>
          <option value="hops">환승(준비중)</option>
        </select>
        <button type="submit" disabled={loading || !origin || !destination}>
          {loading ? '검색 중…' : '검색'}
        </button>
      </form>
      {error && <div className="route-widget-error">{error}</div>}
      {result && (
        <div className="route-widget-result">
          <div className="summary">
            <div>출발: {result.origin} · 도착: {result.destination}</div>
            <div>총 거리: {result.total_distance} · 경유 횟수: {result.hops}</div>
          </div>
          <ol className="steps">
            {result.steps?.map((s, i) => (
              <li key={i}>
                <span className="step-index">{i + 1}</span>
                <span>{s.origin} → {s.destination}</span>
                <span className="step-distance">{s.distance}</span>
              </li>
            ))}
          </ol>
        </div>
      )}
    </div>
  );
}
