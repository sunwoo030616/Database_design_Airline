import api from "./axios";

// 직항 여부 체크 API
export const searchDirectFlights = (origin, destination) =>
  api.get("/flights/", { params: { origin, destination } });

// 최단 거리 경유 경로 API
export const searchMinDistanceRoute = (origin, destination) =>
  api.get("/flights/routes/min-distance/", { params: { origin, destination } });
