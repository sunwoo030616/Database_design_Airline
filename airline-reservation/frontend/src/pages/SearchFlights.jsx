import { useState, useEffect } from "react";
import { useNavigate } from "react-router-dom";
import { searchFlights } from "../api/flights";
import axios from "axios";
import "./SearchFlights.css";

export default function SearchFlights() {
  const [origin, setOrigin] = useState("");
  const [destination, setDestination] = useState("");
  const [date, setDate] = useState("");
  const [flights, setFlights] = useState([]);

  const [routes, setRoutes] = useState([]);

  const navigate = useNavigate();

  // 🔥 노선 리스트 로드
  useEffect(() => {
    axios
      .get("http://127.0.0.1:8003/api/flights/routes/")
      .then((res) => setRoutes(res.data))
      .catch((error) => console.error("노선 불러오기 오류:", error));
  }, []);

  // 🔥 항공편 검색
  async function handleSearch() {
    try {
      const res = await searchFlights({ origin, destination, date });
      setFlights(res.data);
    } catch (e) {
      console.error(e);
      alert("항공편 조회 중 오류가 발생했습니다.");
    }
  }

  return (
    <div className="search-container">

      {/* 상단 배너 */}
      <div className="hero-card">
        <div className="hero-text">
          <h1>하늘을 잇는 여정, AirFly</h1>
          <p>출발지·도착지·날짜를 입력하고 항공편을 검색해보세요.</p>
        </div>
        <div className="hero-badge">
          ✈ ACTIVE DATABASE 기반<br />
          실시간 요금 & 좌석 반영
        </div>
      </div>

      {/* 검색 폼 */}
      <div className="search-box">
        <div className="field-group">
          <label>출발지</label>
          <input
            placeholder="예: ICN"
            value={origin}
            onChange={(e) => setOrigin(e.target.value)}
          />
        </div>

        <div className="field-group">
          <label>도착지</label>
          <input
            placeholder="예: LAX"
            value={destination}
            onChange={(e) => setDestination(e.target.value)}
          />
        </div>

        <div className="field-group">
          <label>출발일</label>
          <input
            type="date"
            value={date}
            onChange={(e) => setDate(e.target.value)}
          />
        </div>

        <button className="search-btn" onClick={handleSearch}>
          항공편 검색
        </button>
      </div>

      {/* 경로 검색 위젯 제거: 메인 화면은 원래대로 유지 */}

      {/* 🔵 검색 전 ⇒ 노선(Route) 목록 */}
      {flights.length === 0 && (
        <div className="route-grid">
          {routes.map((r) => (
            <div className="route-card" key={r.route_id}>
              
              <div className="route-header">
                <div className="airport">
                  <div className="city">{r.origin.city}</div>
                  <div className="code">{r.origin.airport_code}</div>
                </div>

                <div className="arrow">✈</div>

                <div className="airport">
                  <div className="city">{r.destination.city}</div>
                  <div className="code">{r.destination.airport_code}</div>
                </div>
              </div>

              <div className="route-info">
                <p>
                  거리: <strong>{r.distance.toLocaleString()} km</strong>
                </p>
                <p>
                  비행 시간: <strong>{r.base_duration} 분</strong>
                </p>
              </div>
            </div>
          ))}
        </div>
      )}

      {/* 🔴 검색 후 ⇒ 항공편 리스트 */}
      {flights.length > 0 && (
        <div className="flight-list">
          {flights.map((f) => (
            <div
              key={f.flight_id}
              className="flight-card"
              onClick={() => navigate(`/seat-select/${f.flight_id}`)}
            >
              <div className="fc-left">
                <div className="fc-route">
                  <span className="fc-airport">{f.route.origin.airport_code}</span>
                  <span className="fc-arrow">➜</span>
                  <span className="fc-airport">{f.route.destination.airport_code}</span>
                </div>
                <div className="fc-meta">
                  <div className="fc-line">
                    <strong>Flight #{f.flight_id}</strong>
                    {f.status ? ` · ${f.status}` : ''}
                    {f.aircraft ? ` · Aircraft ${f.aircraft}` : ''}
                  </div>
                  <div className="fc-line">
                    출발 {f.departure_time.slice(0, 16)} · 도착 {f.arrival_time.slice(0, 16)}
                  </div>
                  <div className="fc-line">
                    예상 소요 {f.route.base_duration}분 · 거리 {Number(f.route.distance).toLocaleString()} km
                  </div>
                </div>
              </div>

              <div className="fc-right">
                <div className="fc-price">
                  ₩ {Number(f.current_fare).toLocaleString()}
                </div>
                <button className="fc-btn">좌석 선택</button>
              </div>
            </div>
          ))}
        </div>
      )}

    </div>
  );
}
