// src/pages/SearchFlights.jsx
import { useState } from "react";
import { useNavigate } from "react-router-dom";
import { searchFlights } from "../api/flights";
import "./SearchFlights.css";

export default function SearchFlights() {
  const [origin, setOrigin] = useState("");
  const [destination, setDestination] = useState("");
  const [date, setDate] = useState("");
  const [flights, setFlights] = useState([]);

  const navigate = useNavigate();

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
          <p>출발지와 도착지만 입력하면, 최적의 항공편을 찾아드립니다.</p>
        </div>
        <div className="hero-badge">
          ✈ ACTIVE DATABASE 기반<br />
          실시간 운임/좌석 반영
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

      {/* 결과 리스트 */}
      <div className="flight-list">
        {flights.length === 0 && (
          <div className="empty-text">검색 조건을 입력하고 항공편을 조회해 보세요.</div>
        )}

        {flights.map((f) => (
          <div
            key={f.flight_id}
            className="flight-card"
            onClick={() => navigate(`/seat-select/${f.flight_id}`)} // 나중에 좌석페이지
          >
            <div className="fc-left">
              <div className="fc-route">
                <span className="fc-airport">{f.route.origin.airport_code}</span>
                <span className="fc-arrow">➜</span>
                <span className="fc-airport">{f.route.destination.airport_code}</span>
              </div>
              <div className="fc-time">
                {f.departure_time.slice(0, 16)} 출발
              </div>
            </div>

            <div className="fc-right">
              <div className="fc-price">
                ₩ {Number(f.current_fare).toLocaleString()}
              </div>
              <button
                className="fc-btn"
              >
                좌석 선택
              </button>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}
