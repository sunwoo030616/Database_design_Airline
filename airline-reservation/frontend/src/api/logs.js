import api from "./axios";

// Fetch dynamic fare logs. If flightId provided, filter by it.
export const fetchFareLogs = (flightId = null) => {
  const params = {};
  if (flightId) params.flight_id = flightId;
  // Backend exposes fare log under /api/admin/fare-log/
  return api.get("/admin/fare-log/", { params });
};
