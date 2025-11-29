import api from "./axios";

// 전체 로그 또는 특정 flight_id 로그
export const fetchFareLogs = (flightId = null) =>
  api.get("/admin/fare-log/", {
    params: { flight_id: flightId }
  });
