// src/api/flights.js
import api from "./axios";

export const searchFlights = (params) =>
  api.get("/flights/", { params });

// 나중에 최단 경로 API도 여기 추가 가능
// export const getMinRoute = (origin, destination) => ...
