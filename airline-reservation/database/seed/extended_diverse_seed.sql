/*
Extended diverse seeds: more routes, flights, seat classes, and months.
Idempotent: uses INSERT IGNORE and NOT EXISTS to avoid duplicates.
Assumes base tables exist from seed.sql.
*/

-- More routes (if not present)
INSERT IGNORE INTO Route (origin, destination, distance, base_duration) VALUES
('ICN','JFK', 11000, 840),
('ICN','SFO', 9500, 780),
('LAX','JFK', 4000, 360),
('NRT','ICN', 1250, 120);

-- Additional connectors to enrich multi-hop paths
INSERT IGNORE INTO Route (origin, destination, distance, base_duration) VALUES
('ICN','DXB', 7200, 540),
('DXB','LAX', 13300, 900),
('ICN','SFO', 9500, 780),
('SFO','LAX', 550, 90),
('NRT','SFO', 8200, 720),
('KIX','LAX', 9000, 750);

-- More flights spanning Nov 2025 ~ Feb 2026
INSERT IGNORE INTO Flight (route_id, aircraft_id, base_fare, current_fare, departure_time, arrival_time, status)
VALUES
( (SELECT route_id FROM Route WHERE origin='ICN' AND destination='JFK' LIMIT 1), 'A320-01', 900, 900, '2025-11-20 10:00', '2025-11-20 23:00', 'SCHEDULED'),
( (SELECT route_id FROM Route WHERE origin='ICN' AND destination='SFO' LIMIT 1), 'B737-01', 850, 850, '2025-12-12 12:00', '2025-12-12 22:00', 'SCHEDULED'),
( (SELECT route_id FROM Route WHERE origin='LAX' AND destination='JFK' LIMIT 1), 'A320-01', 400, 400, '2026-01-08 09:00', '2026-01-08 15:00', 'SCHEDULED'),
( (SELECT route_id FROM Route WHERE origin='NRT' AND destination='ICN' LIMIT 1), 'B737-01', 200, 200, '2026-02-03 08:00', '2026-02-03 10:00', 'SCHEDULED');

-- Helper: create reservations for a flight if seats are free
-- Economy block
INSERT INTO Reservation (flight_id, seat_no, user_id, resv_time, status)
SELECT f.flight_id, s.seat_no, 1 + MOD(f.flight_id, 10), DATE_SUB(f.departure_time, INTERVAL 2 DAY), 'CONFIRMED'
FROM Flight f
JOIN Seat s ON s.aircraft_id = f.aircraft_id AND s.seat_class = 'Economy'
WHERE (f.departure_time BETWEEN '2025-11-01' AND '2026-02-28')
  AND s.seat_no IN ('1A','1B','1C','2A','2B','2C')
  AND NOT EXISTS (
    SELECT 1 FROM Reservation r WHERE r.flight_id = f.flight_id AND r.seat_no = s.seat_no
  );

-- Remove business seat simulation (3A/3B) to avoid '유효하지 않은 좌석' trigger errors.
-- Use only valid existing seats: 1A,1B,1C,2A,2B,2C

-- Payments: SUCCESS mostly, some FAILED to vary analytics
INSERT INTO Payment (resv_id, amount, pay_time, method, status)
SELECT r.resv_id,
       CASE
         WHEN r.seat_no IN ('1A','1B') THEN 950
         WHEN r.seat_no IN ('1C','2A','2B','2C') THEN 900
         WHEN r.seat_no IN ('3A','3B') THEN 1200
         ELSE 700
       END AS amount,
       DATE_ADD(r.resv_time, INTERVAL 30 MINUTE) AS pay_time,
       'CARD' AS method,
       CASE WHEN r.seat_no IN ('2B','3B') THEN 'FAILED' ELSE 'SUCCESS' END AS status
FROM Reservation r
WHERE NOT EXISTS (SELECT 1 FROM Payment p WHERE p.resv_id = r.resv_id)
ON DUPLICATE KEY UPDATE amount=VALUES(amount), pay_time=VALUES(pay_time), method=VALUES(method), status=VALUES(status);

-- A few CASH payments to diversify methods
INSERT INTO Payment (resv_id, amount, pay_time, method, status)
SELECT r.resv_id,
       800,
       DATE_ADD(r.resv_time, INTERVAL 1 HOUR),
       'CASH',
       'SUCCESS'
FROM Reservation r
WHERE r.seat_no IN ('2A','2C')
  AND NOT EXISTS (SELECT 1 FROM Payment p WHERE p.resv_id = r.resv_id);

-- Explicit successful payments for key routes/months to ensure non-zero analytics
-- ICN->JFK in 2025-12
INSERT INTO Reservation (flight_id, seat_no, user_id, resv_time, status)
SELECT f.flight_id, '1A', 21, DATE_SUB(f.departure_time, INTERVAL 1 DAY), 'CONFIRMED'
FROM Flight f
JOIN Route r ON r.route_id = f.route_id
WHERE r.origin='ICN' AND r.destination='JFK'
  AND DATE_FORMAT(f.departure_time, '%Y-%m')='2025-12'
  AND NOT EXISTS (SELECT 1 FROM Reservation x WHERE x.flight_id=f.flight_id AND x.seat_no='1A');

INSERT INTO Payment (resv_id, amount, pay_time, method, status)
SELECT rr.resv_id, 950, DATE_ADD(rr.resv_time, INTERVAL 20 MINUTE), 'CARD', 'SUCCESS'
FROM Reservation rr
JOIN Flight f ON f.flight_id = rr.flight_id
JOIN Route r ON r.route_id = f.route_id
WHERE r.origin='ICN' AND r.destination='JFK'
  AND DATE_FORMAT(f.departure_time, '%Y-%m')='2025-12'
  AND rr.seat_no='1A'
  AND NOT EXISTS (SELECT 1 FROM Payment p WHERE p.resv_id=rr.resv_id);

-- ICN->SFO in 2025-12
INSERT INTO Reservation (flight_id, seat_no, user_id, resv_time, status)
SELECT f.flight_id, '1B', 22, DATE_SUB(f.departure_time, INTERVAL 1 DAY), 'CONFIRMED'
FROM Flight f
JOIN Route r ON r.route_id = f.route_id
WHERE r.origin='ICN' AND r.destination='SFO'
  AND DATE_FORMAT(f.departure_time, '%Y-%m')='2025-12'
  AND NOT EXISTS (SELECT 1 FROM Reservation x WHERE x.flight_id=f.flight_id AND x.seat_no='1B');

INSERT INTO Payment (resv_id, amount, pay_time, method, status)
SELECT rr.resv_id, 900, DATE_ADD(rr.resv_time, INTERVAL 25 MINUTE), 'CARD', 'SUCCESS'
FROM Reservation rr
JOIN Flight f ON f.flight_id = rr.flight_id
JOIN Route r ON r.route_id = f.route_id
WHERE r.origin='ICN' AND r.destination='SFO'
  AND DATE_FORMAT(f.departure_time, '%Y-%m')='2025-12'
  AND rr.seat_no='1B'
  AND NOT EXISTS (SELECT 1 FROM Payment p WHERE p.resv_id=rr.resv_id);

-- LAX->JFK in 2026-01
INSERT INTO Reservation (flight_id, seat_no, user_id, resv_time, status)
SELECT f.flight_id, '2A', 23, DATE_SUB(f.departure_time, INTERVAL 2 DAY), 'CONFIRMED'
FROM Flight f
JOIN Route r ON r.route_id = f.route_id
WHERE r.origin='LAX' AND r.destination='JFK'
  AND DATE_FORMAT(f.departure_time, '%Y-%m')='2026-01'
  AND NOT EXISTS (SELECT 1 FROM Reservation x WHERE x.flight_id=f.flight_id AND x.seat_no='2A');

INSERT INTO Payment (resv_id, amount, pay_time, method, status)
SELECT rr.resv_id, 700, DATE_ADD(rr.resv_time, INTERVAL 15 MINUTE), 'CASH', 'SUCCESS'
FROM Reservation rr
JOIN Flight f ON f.flight_id = rr.flight_id
JOIN Route r ON r.route_id = f.route_id
WHERE r.origin='LAX' AND r.destination='JFK'
  AND DATE_FORMAT(f.departure_time, '%Y-%m')='2026-01'
  AND rr.seat_no='2A'
  AND NOT EXISTS (SELECT 1 FROM Payment p WHERE p.resv_id=rr.resv_id);
