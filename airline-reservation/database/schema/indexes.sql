USE airline;

-- Route indexes
CREATE INDEX IF NOT EXISTS idx_route_origin_dest ON Route (origin, destination);
CREATE INDEX IF NOT EXISTS idx_route_distance ON Route (distance);
CREATE INDEX IF NOT EXISTS idx_route_duration ON Route (duration);

-- Flight indexes
CREATE INDEX IF NOT EXISTS idx_flight_route ON Flight (route_id);
CREATE INDEX IF NOT EXISTS idx_flight_departure_time ON Flight (departure_time);
CREATE INDEX IF NOT EXISTS idx_flight_status ON Flight (status);
CREATE INDEX IF NOT EXISTS idx_flight_route_departure ON Flight (route_id, departure_time);

-- Seat indexes
CREATE INDEX IF NOT EXISTS idx_seat_aircraft_status ON Seat (aircraft_id, status);
CREATE UNIQUE INDEX IF NOT EXISTS ux_seat_aircraft_seatno ON Seat (aircraft_id, seat_no);

-- Reservation indexes
CREATE INDEX IF NOT EXISTS idx_reservation_flight_status ON Reservation (flight_id, status);
CREATE INDEX IF NOT EXISTS idx_reservation_member_status ON Reservation (member_id, status);
CREATE UNIQUE INDEX IF NOT EXISTS ux_reservation_flight_seat ON Reservation (flight_id, seat_no);

-- Payment indexes
CREATE INDEX IF NOT EXISTS idx_payment_resv ON Payment (resv_id);
CREATE INDEX IF NOT EXISTS idx_payment_status ON Payment (status);

-- DynamicFareLog indexes
CREATE INDEX IF NOT EXISTS idx_dfl_flight_time ON DynamicFareLog (flight_id, change_time);
CREATE INDEX IF NOT EXISTS idx_dfl_resv ON DynamicFareLog (resv_id);
CREATE INDEX IF NOT EXISTS idx_dfl_trigger_event ON DynamicFareLog (trigger_event);
