import { useLocation, useNavigate } from "react-router-dom";
import { useState } from "react";
import { createReservation } from "../api/reserve";
import "./ReservationConfirm.css";

export default function ReservationConfirm() {
  const navigate = useNavigate();
  const { state } = useLocation();
  const { flight, selectedSeat } = state;

  const [method, setMethod] = useState("CARD");
  const member = JSON.parse(localStorage.getItem("member"));

  async function handlePayment() {
    try {
      await createReservation(
        flight.flight_id,
        selectedSeat,
        method,
        member.user_id
      );
      alert("예약이 완료되었습니다!");
      navigate("/mypage");
    } catch (e) {
      console.error(e);
      alert("결제 실패: " + e.message);
    }
  }

  return (
    <div className="confirm-container">

      <div className="ticket-card">
        <div className="route">
          <span className="airport">{flight.route.origin.airport_code}</span>
          <span className="arrow">✈</span>
          <span className="airport">{flight.route.destination.airport_code}</span>
        </div>

        <div className="time">
          출발: {flight.departure_time.slice(0, 16)}
        </div>
        <div className="seat">좌석: <b>{selectedSeat}</b></div>
        <div className="price">금액: ₩ {Number(flight.current_fare).toLocaleString()}</div>
      </div>

      <div className="payment-box">
        <h3>결제 수단</h3>
        <select value={method} onChange={(e) => setMethod(e.target.value)}>
          <option value="CARD">카드 결제</option>
          <option value="POINT">포인트 결제</option>
          <option value="BANK">계좌이체</option>
        </select>
      </div>

      <button className="pay-btn" onClick={handlePayment}>
        결제하기
      </button>
    </div>
  );
}
