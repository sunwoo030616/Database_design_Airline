import React, { useState } from 'react';
import { fetchShortestPaths } from '../api/routes';
import './RouteSearch.css';

export default function RouteSearch() {
  const [origin, setOrigin] = useState('');
  const [destination, setDestination] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const [paths, setPaths] = useState([]);
  const [maxHops, setMaxHops] = useState(2);   // 최대 경유 횟수 (기본 2)
  const [maxResults, setMaxResults] = useState(5); // 결과 개수 (기본 5)

  const onSearch = async (e) => {
    e.preventDefault();
    setLoading(true);
    setError('');
    setPaths([]);
    try {
      const data = await fetchShortestPaths(origin.trim(), destination.trim(), { max_hops: maxHops, max_results: maxResults });
      const raw = data.paths || [];
      // 프런트에서도 중복 제거: 동일한 노드 시퀀스는 하나만 유지
      const seen = new Set();
      const unique = [];
      for (const p of raw) {
        const buildNodes = (x) => {
          if (x.nodes && x.nodes.length) return x.nodes;
          if (!x.steps || !x.steps.length) return [x.origin, x.destination];
          const ns = [x.steps[0].origin];
          for (const s of x.steps) ns.push(s.destination);
          return ns;
        };
        const key = buildNodes(p).join('->');
        if (!seen.has(key)) {
          seen.add(key);
          unique.push(p);
        }
      }
      setPaths(unique);
    } catch (err) {
      const msg = err?.response?.data?.detail || err?.message || '검색 중 오류가 발생했습니다';
      setError(String(msg));
    } finally {
      setLoading(false);
    }
  };

  const Steps = ({ steps }) => (
    <ol style={{ paddingLeft: 18 }}>
      {steps?.map((s, idx) => (
        <li key={idx}>
          {s.origin} → {s.destination} · 거리 {s.distance}
        </li>
      ))}
    </ol>
  );

  const Layovers = ({ nodes }) => {
    if (!nodes || nodes.length < 3) return null; // 직항이면 경유 없음
    const layovers = nodes.slice(1, -1);
    return (
      <div className="layovers">
        경유: {layovers.join(' → ')}
      </div>
    );
  };

  return (
    <div className="route-search-page">
      <h2>최단 경로 검색</h2>
      <form onSubmit={onSearch} className="route-search-form">
        <input
          value={origin}
          onChange={(e) => setOrigin(e.target.value.toUpperCase())}
          placeholder="출발 공항 코드 (예: ICN)"
        />
        <span className="arrow">→</span>
        <input
          value={destination}
          onChange={(e) => setDestination(e.target.value.toUpperCase())}
          placeholder="도착 공항 코드 (예: LAX)"
        />
        <label className="route-label">
          최대 경유 횟수
          <input
            type="number"
            value={maxHops}
            min={1}
            max={2}
            onChange={(e) => setMaxHops(Number(e.target.value) || 2)}
            aria-label="최대 경유 횟수"
          />
          <span className="route-hint">탐색 허용 경유 수 (기본 2)</span>
        </label>
        <label className="route-label">
          결과 개수
          <input
            type="number"
            value={maxResults}
            min={1}
            max={20}
            onChange={(e) => setMaxResults(Number(e.target.value) || 5)}
            aria-label="결과 개수"
          />
          <span className="route-hint">표시할 상위 경로 수 (기본 5)</span>
        </label>
        <button type="submit" disabled={loading || !origin || !destination}>
          {loading ? '검색 중…' : '검색'}
        </button>
      </form>

      {error && (
        <div className="route-error">오류: {error}</div>
      )}

      {paths.length > 0 && (
        <div className="route-result">
          <div className="route-count">경로 후보 {paths.length}개</div>
          {paths.map((p, idx) => (
            <div key={idx} className="route-card">
              {/* 상단 배지 유지 */}
              <div className="summary">
                <div className="route-badges">
                  <span className="badge badge-origin">출발 {p.origin}</span>
                  <span className="badge badge-dest">도착 {p.destination}</span>
                  <span className="badge badge-distance">총 거리 {Number(p.total_distance).toLocaleString()}</span>
                  <span className="badge badge-hops">경유 {p.hops ?? 0}</span>
                </div>
              </div>
              {/* 유틸: nodes가 없으면 steps로부터 노드 시퀀스 복원 */}
              {(() => {
                const buildNodes = (p) => {
                  if (p.nodes && p.nodes.length) return p.nodes;
                  if (!p.steps || !p.steps.length) return [p.origin, p.destination];
                  const nodes = [p.steps[0].origin];
                  for (const s of p.steps) nodes.push(s.destination);
                  return nodes;
                };
                const nodes = buildNodes(p);
                const hops = p.hops != null ? p.hops : Math.max(0, nodes.length - 2);
                const layovers = nodes.length > 2 ? nodes.slice(1, -1) : [];
                const distanceStr = Number(p.total_distance).toLocaleString();
                return (
                  <div className="route-summary">
                    {nodes.join(' → ')} · 거리 {distanceStr} · 경유 {hops}
                    {layovers.length ? ` · 경유지: ${layovers.join(' → ')}` : ''}
                    {/* 경유지 칩 형태로 별도 표시 */}
                    <Layovers nodes={nodes} />
                  </div>
                );
              })()}
              {/* 상세 구간 리스트는 숨김 (원하면 토글로 추가 가능) */}
              {/* <Steps steps={p.steps} /> */}
            </div>
          ))}
        </div>
      )}
    </div>
  );
}

