import api from './axios';

export async function getAvailableSeats(flightId) {
  const url = `/backend/flights/${flightId}/available-seats/`;
  const { data } = await api.get(url);
  return data; // { flight_id, aircraft_id, available_count, seats: [...] }
}

export const searchFlights = (params) => api.get('/flights/', { params });

// 나중에 최단 경로 API도 여기 추가 가능
// export const getMinRoute = (origin, destination) => ...
