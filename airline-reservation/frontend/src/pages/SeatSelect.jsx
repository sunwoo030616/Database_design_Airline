// src/pages/SeatSelect.jsx
import { useEffect, useState } from "react";
import { useParams, useNavigate } from "react-router-dom";
import api from "../api/axios";
import "./SeatSelect.css";

export default function SeatSelect() {
  const { flightId } = useParams();
  const navigate = useNavigate();

  const [flight, setFlight] = useState(null);
  const [seats, setSeats] = useState([]);
  const [selectedSeat, setSelectedSeat] = useState(null);

  useEffect(() => {
    loadData();
  }, []);

  async function loadData() {
    try {
      const res = await api.get(`/flights/${flightId}/seats/`);
      setFlight(res.data.flight);
      setSeats(res.data.seats);
    } catch (e) {
      console.error(e);
      alert("좌석 정보를 불러오는 중 오류 발생");
    }
  }

  function handleSelect(seatNo, status) {
    if (status === "BOOKED") return;
    setSelectedSeat(seatNo);
  }

  function handleNext() {
    if (!selectedSeat) {
      alert("좌석을 선택해주세요!");
      return;
    }
    navigate("/reservation/confirm", {
      state: { flight, selectedSeat },
    });
  }

  if (!flight) return null;

  const origin = flight.route.origin;
  const destination = flight.route.destination;

  return (
    <div className="seat-container">

      {/* 🎫 항공권 헤더 */}
      <div className="ticket-header">
        <div className="airport">
          <div className="code">{origin.airport_code}</div>
          <div className="city">{origin.city}</div>
        </div>

        <div className="plane-icon">✈</div>

        <div className="airport">
          <div className="code">{destination.airport_code}</div>
          <div className="city">{destination.city}</div>
        </div>
      </div>

      {/* 상세 정보 */}
      <div className="flight-detail">
        <div>출발: <b>{flight.departure_time.slice(0, 16)}</b></div>
        <div>도착: <b>{flight.arrival_time.slice(0, 16)}</b></div>
        <div>항공기: {flight.aircraft}</div>
        <div>운임: ₩ {Number(flight.current_fare).toLocaleString()}</div>
      </div>

      {/* 좌석 제목 */}
      <h3 className="seat-title">좌석 선택</h3>

      {/* 좌석 그리드 */}
      <div className="seat-grid">
        {seats.map((s) => (
          <div
            key={s.seat_no}
            className={`seat 
              ${s.status === "BOOKED" ? "booked" : ""} 
              ${selectedSeat === s.seat_no ? "selected" : ""}`}
            onClick={() => handleSelect(s.seat_no, s.status)}
          >
            {s.seat_no}
          </div>
        ))}
      </div>

      <button className="next-btn" onClick={handleNext}>
        결제 단계로 이동
      </button>
    </div>
  );
}
