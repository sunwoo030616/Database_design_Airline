INSERT IGNORE INTO Airport VALUES
('ICN', 'Incheon International Airport', 'Incheon', 'Korea'),
('GMP', 'Gimpo Airport', 'Seoul', 'Korea'),
('NRT', 'Narita International Airport', 'Tokyo', 'Japan'),
('KIX', 'Kansai International Airport', 'Osaka', 'Japan'),
('LAX', 'Los Angeles International Airport', 'Los Angeles', 'USA');

INSERT IGNORE INTO Aircraft VALUES
('A320-01', 'A320', 'Airbus', 180),
('B737-01', 'B737', 'Boeing', 160);

INSERT IGNORE INTO Seat (aircraft_id, seat_no, seat_class, status)
VALUES
('A320-01', '1A', 'Economy', 'AVAILABLE'),
('A320-01', '1B', 'Economy', 'AVAILABLE'),
('A320-01', '1C', 'Economy', 'AVAILABLE'),
('A320-01', '2A', 'Economy', 'AVAILABLE'),
('A320-01', '2B', 'Economy', 'AVAILABLE'),
('A320-01', '2C', 'Economy', 'AVAILABLE'),
('B737-01', '1A', 'Economy', 'AVAILABLE'),
('B737-01', '1B', 'Economy', 'AVAILABLE'),
('B737-01', '1C', 'Economy', 'AVAILABLE'),
('B737-01', '2A', 'Economy', 'AVAILABLE');

INSERT IGNORE INTO Route (origin, destination, distance, base_duration)
VALUES
('ICN', 'NRT', 1250, 120),
('ICN', 'KIX', 1100, 110),
('ICN', 'LAX', 9530, 720),
('GMP', 'ICN', 50, 30),
('NRT', 'LAX', 8800, 660);

INSERT IGNORE INTO Member (name, email, phone_num, user_type) VALUES
('Kim Customer', 'kim@example.com', '010-1234-5678', 'customer'),
('Lee Customer', 'lee@example.com', '010-8765-4321', 'customer'),
('Admin Park', 'admin@example.com', '010-0000-0000', 'admin');

INSERT IGNORE INTO Customer VALUES
(1, 1000, 'Silver'),
(2, 500, 'Bronze');

INSERT IGNORE INTO Admin VALUES
(3, 1);

INSERT IGNORE INTO Flight (route_id, aircraft_id, base_fare, current_fare, departure_time, arrival_time, status)
VALUES
(1, 'A320-01', 200.00, 200.00, '2025-12-01 09:00', '2025-12-01 11:00', 'SCHEDULED'),
(3, 'B737-01', 800.00, 800.00, '2025-12-05 15:00', '2025-12-05 23:00', 'SCHEDULED');

-- Initial reservations, duplication-safe on unique (flight_id, seat_no)
INSERT INTO Reservation (flight_id, seat_no, user_id, resv_time, status)
SELECT 1, '1A', 1, NOW(), 'BOOKED' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM Reservation r WHERE r.flight_id=1 AND r.seat_no='1A');
INSERT INTO Reservation (flight_id, seat_no, user_id, resv_time, status)
SELECT 1, '1B', 2, NOW(), 'BOOKED' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM Reservation r WHERE r.flight_id=1 AND r.seat_no='1B');

-- Additional Reservation & Payment seeds to enrich analytics
-- Assumptions:
-- - Routes and Flights exist for popular pairs (ICN->LAX, ICN->NRT, LAX->SFO, NRT->ICN)
-- - Flight IDs 1..8 map to those routes on 2025-11 and 2025-12
-- - Member IDs 1..20 exist

-- Reservations for November (2025-11)
INSERT INTO Reservation (flight_id, seat_no, user_id, resv_time, status)
VALUES
	(1, '1A', 1,  '2025-11-02 09:15:00', 'CONFIRMED'),
	(1, '1B', 2,  '2025-11-02 09:18:00', 'CONFIRMED'),
	(2, '2A', 3,  '2025-11-05 13:40:00', 'CONFIRMED'),
	(2, '2B', 4,  '2025-11-05 13:42:00', 'CONFIRMED'),
	(3, '3A', 5,  '2025-11-10 07:20:00', 'CONFIRMED'),
	(3, '3B', 6,  '2025-11-10 07:23:00', 'CONFIRMED'),
	(4, '4A', 7,  '2025-11-15 18:05:00', 'CONFIRMED'),
	(4, '4B', 8,  '2025-11-15 18:07:00', 'CONFIRMED');

-- Payments (SUCCESS focus) for November reservations
INSERT INTO Payment (resv_id, amount, pay_time, method, status)
SELECT r.resv_id,
						 CASE WHEN r.seat_no LIKE '%A' THEN 450.00 ELSE 420.00 END AS amount,
						 DATE_ADD(r.resv_time, INTERVAL 5 MINUTE) AS pay_time,
						 'CARD' AS method,
						 'SUCCESS' AS status
FROM Reservation r
WHERE r.resv_time BETWEEN '2025-11-01' AND '2025-11-30'
	AND NOT EXISTS (SELECT 1 FROM Payment p WHERE p.resv_id = r.resv_id)
ON DUPLICATE KEY UPDATE amount=VALUES(amount), pay_time=VALUES(pay_time), method=VALUES(method), status=VALUES(status);

-- Reservations for December (2025-12)
INSERT INTO Reservation (flight_id, seat_no, user_id, resv_time, status)
VALUES
	(5, '5A', 9,  '2025-12-02 09:15:00', 'CONFIRMED'),
	(5, '5B', 10, '2025-12-02 09:18:00', 'CONFIRMED'),
	(6, '6A', 11, '2025-12-05 13:40:00', 'CONFIRMED'),
	(6, '6B', 12, '2025-12-05 13:42:00', 'CONFIRMED'),
	(7, '7A', 13, '2025-12-10 07:20:00', 'CONFIRMED'),
	(7, '7B', 14, '2025-12-10 07:23:00', 'CONFIRMED'),
	(8, '8A', 15, '2025-12-15 18:05:00', 'CONFIRMED'),
	(8, '8B', 16, '2025-12-15 18:07:00', 'CONFIRMED');

-- Payments for December reservations
INSERT INTO Payment (resv_id, amount, pay_time, method, status)
SELECT r.resv_id,
						 CASE WHEN r.seat_no LIKE '%A' THEN 520.00 ELSE 480.00 END AS amount,
						 DATE_ADD(r.resv_time, INTERVAL 6 MINUTE) AS pay_time,
						 'CARD' AS method,
						 'SUCCESS' AS status
FROM Reservation r
WHERE r.resv_time BETWEEN '2025-12-01' AND '2025-12-31'
	AND NOT EXISTS (SELECT 1 FROM Payment p WHERE p.resv_id = r.resv_id)
ON DUPLICATE KEY UPDATE amount=VALUES(amount), pay_time=VALUES(pay_time), method=VALUES(method), status=VALUES(status);

-- A few FAILED payments to simulate non-counted transactions (won't affect analytics)
INSERT INTO Payment (resv_id, amount, pay_time, method, status)
SELECT r.resv_id, 420.00, '2025-11-15 18:15:00', 'CARD', 'FAILED' FROM Reservation r
WHERE r.seat_no='4B' AND NOT EXISTS (SELECT 1 FROM Payment p WHERE p.resv_id=r.resv_id);
INSERT INTO Payment (resv_id, amount, pay_time, method, status)
SELECT r.resv_id, 480.00, '2025-12-15 18:16:00', 'CARD', 'FAILED' FROM Reservation r
WHERE r.seat_no='8B' AND NOT EXISTS (SELECT 1 FROM Payment p WHERE p.resv_id=r.resv_id);

INSERT INTO Payment (resv_id, amount, pay_time, method, status)
SELECT 1, 200.00, NOW(), 'CARD', 'PAID' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM Payment p WHERE p.resv_id=1);
INSERT INTO Payment (resv_id, amount, pay_time, method, status)
SELECT 2, 200.00, NOW(), 'CARD', 'PAID' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM Payment p WHERE p.resv_id=2);
