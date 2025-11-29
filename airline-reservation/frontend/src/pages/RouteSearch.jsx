import React, { useState } from "react";
import { searchDirectFlights, searchMinDistanceRoute } from "../api/routes";
import "./RouteSearch.css";

export default function RouteSearch() {
  const [origin, setOrigin] = useState("");
  const [destination, setDestination] = useState("");
  const [result, setResult] = useState(null);
  const [loading, setLoading] = useState(false);

  const handleSearch = async () => {
    if (!origin || !destination) {
      alert("출발지와 도착지를 입력하세요.");
      return;
    }

    setLoading(true);
    setResult(null);

    try {
      // 1) 직항 먼저 시도
      const direct = await searchDirectFlights(origin, destination);

      if (direct.data.length > 0) {
        setResult({
          type: "direct",
          flights: direct.data
        });
        setLoading(false);
        return;
      }

      // 2) 직항 없으면 최단 거리 경유 경로 찾기
      const path = await searchMinDistanceRoute(origin, destination);
      setResult({
        type: "transfer",
        path: path.data
      });

    } catch (err) {
      console.error(err);
      alert("경로 검색 중 오류 발생");
    }

    setLoading(false);
  };

  return (
    <div className="route-search-container">
      <h1>✈ 경유 / 직항 노선 검색</h1>

      <div className="input-box">
        <input
          placeholder="출발지 (예: ICN)"
          value={origin}
          onChange={(e) => setOrigin(e.target.value.toUpperCase())}
        />
        <input
          placeholder="도착지 (예: LAX)"
          value={destination}
          onChange={(e) => setDestination(e.target.value.toUpperCase())}
        />
        <button onClick={handleSearch}>검색</button>
      </div>

      {loading && <p>검색 중...</p>}

      {/* 검색 결과 */}
      {result && result.type === "direct" && (
        <div className="result-box direct-box">
          <h2>🚀 직항 노선 발견!</h2>
          {result.flights.map((f) => (
            <div key={f.flight_id} className="flight-card">
              <p>{f.route.origin} → {f.route.destination}</p>
              <p>출발: {f.departure_time}</p>
              <p>도착: {f.arrival_time}</p>
              <p>운임: {f.current_fare} USD</p>
            </div>
          ))}
        </div>
      )}

      {result && result.type === "transfer" && (
        <div className="result-box transfer-box">
          <h2>🔁 경유 노선 추천</h2>
          <p>총 경유 횟수: {result.path.stops}</p>
          <p>총 거리: {result.path.total_distance} km</p>

          <div className="path-box">
            {result.path.path.split(" -> ").map((airport, idx) => (
              <div key={idx} className="step">
                <div className="circle">{idx + 1}</div>
                <span>{airport}</span>
              </div>
            ))}
          </div>
        </div>
      )}
    </div>
  );
}
