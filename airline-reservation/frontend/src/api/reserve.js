import api from "./axios";

export const createReservation = (flight_id, seat_no, payment_method, member_id) =>
  api.post("reserve/", {
    flight_id,
    seat_no,
    payment_method,
    member_id,
  });

export const cancelReservationApi = (resv_id, member_id) =>
  api.post(`/reserve/${resv_id}/cancel/`, { member_id });