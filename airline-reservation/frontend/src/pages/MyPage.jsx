import React, { useEffect, useState } from "react";
import api from "../api/axios";
import { cancelReservationApi } from "../api/reserve";
import "./MyPage.css";

export default function MyPage() {
  const [reservations, setReservations] = useState([]);
  const memberId = localStorage.getItem("member_id");

  const fetchReservations = () => {
    api
      .get("/reserve/my/", { params: { member_id: memberId } })
      .then((res) => {
        setReservations(res.data);
      })
      .catch((err) => console.log(err));
  };

  useEffect(() => {
    fetchReservations();
  }, []);

  // 🔥 예약 취소
  const handleCancel = (resv_id) => {
    if (!window.confirm("정말 예약을 취소하시겠습니까?")) return;

    cancelReservationApi(resv_id, memberId)
      .then(() => {
        alert("예약이 취소되었습니다.");
        fetchReservations(); // 목록 새로 불러오기
      })
      .catch((err) => {
        console.log(err);
        alert("취소 실패");
      });
  };

  return (
    <div className="mypage-container">
      <h1>나의 예약 내역</h1>

      {reservations.length === 0 && (
        <p style={{ marginTop: "20px" }}>예약 내역이 없습니다.</p>
      )}

      {reservations.map((r) => (
        <div key={r.resv_id} className="reservation-card">
          <h2>예약번호 #{r.resv_id}</h2>
          <p><strong>노선:</strong> {r.flight.route.origin} → {r.flight.route.destination}</p>
          <p><strong>출발:</strong> {r.flight.departure_time}</p>
          <p><strong>좌석:</strong> {r.seat_no}</p>
          <p><strong>상태:</strong> {r.status}</p>

          {/* 🔥 BOOKED일 때만 취소 버튼 */}
          {r.status === "BOOKED" && (
            <button
              className="cancel-btn"
              onClick={() => handleCancel(r.resv_id)}
            >
              예약 취소
            </button>
          )}

          {/* 이미 취소된 경우 표시 */}
          {r.status === "CANCELLED" && (
            <p style={{ color: "gray" }}>이미 취소된 예약</p>
          )}
        </div>
      ))}
    </div>
  );
}
