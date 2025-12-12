INSERT IGNORE INTO Airport VALUES
('ICN', 'Incheon International Airport', 'Incheon', 'Korea'),
('GMP', 'Gimpo Airport', 'Seoul', 'Korea'),
('NRT', 'Narita International Airport', 'Tokyo', 'Japan'),
('KIX', 'Kansai International Airport', 'Osaka', 'Japan'),
('LAX', 'Los Angeles International Airport', 'Los Angeles', 'USA');

-- 추가: 항공기 샘플 더 늘리기
INSERT IGNORE INTO Aircraft (aircraft_id, model, capacity)
VALUES
('A321', 'Airbus A321', 190),
('B789', 'Boeing 787-9', 280)
ON DUPLICATE KEY UPDATE model=VALUES(model), capacity=VALUES(capacity);

-- 추가: 노선 샘플 더 늘리기
INSERT IGNORE INTO Route (route_id, origin, destination, distance, base_duration)
VALUES
(2001, 'ICN', 'SFO', 9180, 660),
(2002, 'ICN', 'NRT', 1270, 125),
(2003, 'NRT', 'LAX', 8810, 650)
ON DUPLICATE KEY UPDATE origin=VALUES(origin), destination=VALUES(destination), distance=VALUES(distance), base_duration=VALUES(base_duration);

-- 추가: 항공편 샘플 더 늘리기 (출발/도착 시간은 예시)
INSERT IGNORE INTO Flight (flight_id, route_id, aircraft_id, departure_time, arrival_time)
VALUES
(3001, 2001, 'B789', '2025-12-20 10:00:00', '2025-12-20 21:00:00'),
(3002, 2002, 'A321', '2025-12-21 08:30:00', '2025-12-21 10:35:00'),
(3003, 2003, 'B789', '2025-12-22 12:15:00', '2025-12-22 23:05:00')
ON DUPLICATE KEY UPDATE route_id=VALUES(route_id), aircraft_id=VALUES(aircraft_id), departure_time=VALUES(departure_time), arrival_time=VALUES(arrival_time);

-- 예약 테스트를 위한 추가 항공편 (동일 노선에 일자만 달리 배치)
INSERT IGNORE INTO Flight (flight_id, route_id, aircraft_id, departure_time, arrival_time)
VALUES
(3004, 2001, 'B789', '2025-12-23 09:00:00', '2025-12-23 20:00:00'),
(3005, 2002, 'A321', '2025-12-24 07:45:00', '2025-12-24 09:50:00'),
(3006, 2003, 'B789', '2025-12-25 13:30:00', '2025-12-25 23:59:00')
ON DUPLICATE KEY UPDATE route_id=VALUES(route_id), aircraft_id=VALUES(aircraft_id), departure_time=VALUES(departure_time), arrival_time=VALUES(arrival_time);

-- 예약 검증용 초기 가용 좌석 보장: 각 신규 항공편의 항공기 좌석을 AVAILABLE로 맞춤
-- B789 좌석 표본
INSERT IGNORE INTO Seat (aircraft_id, seat_no, seat_class, status)
VALUES
('B789','30A','ECONOMY','AVAILABLE'),('B789','30B','ECONOMY','AVAILABLE'),('B789','30C','ECONOMY','AVAILABLE'),
('B789','31A','ECONOMY','AVAILABLE'),('B789','31B','ECONOMY','AVAILABLE'),('B789','31C','ECONOMY','AVAILABLE')
ON DUPLICATE KEY UPDATE seat_class=VALUES(seat_class), status=VALUES(status);

-- A321 좌석 표본
INSERT IGNORE INTO Seat (aircraft_id, seat_no, seat_class, status)
VALUES
('A321','20A','ECONOMY','AVAILABLE'),('A321','20B','ECONOMY','AVAILABLE'),('A321','20C','ECONOMY','AVAILABLE'),
('A321','21A','ECONOMY','AVAILABLE'),('A321','21B','ECONOMY','AVAILABLE'),('A321','21C','ECONOMY','AVAILABLE')
ON DUPLICATE KEY UPDATE seat_class=VALUES(seat_class), status=VALUES(status);

-- 예약 성공을 바로 확인하기 위한 샘플 예약+결제 (존재 시 건너뜀)
-- Flight 3004(B789) 좌석 30A, 사용자 9001
INSERT INTO Reservation (flight_id, seat_no, user_id, resv_time, status)
SELECT 3004, '30A', 9001, NOW(), 'CONFIRMED' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM Reservation r WHERE r.flight_id=3004 AND r.seat_no='30A');
INSERT INTO Payment (resv_id, amount, pay_time, method, status)
SELECT r.resv_id, 950.00, NOW(), 'CARD', 'SUCCESS'
FROM Reservation r
WHERE r.flight_id=3004 AND r.seat_no='30A'
AND NOT EXISTS (SELECT 1 FROM Payment p WHERE p.resv_id=r.resv_id);

-- Flight 3005(A321) 좌석 20A, 사용자 9002
INSERT INTO Reservation (flight_id, seat_no, user_id, resv_time, status)
SELECT 3005, '20A', 9002, NOW(), 'CONFIRMED' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM Reservation r WHERE r.flight_id=3005 AND r.seat_no='20A');
INSERT INTO Payment (resv_id, amount, pay_time, method, status)
SELECT r.resv_id, 220.00, NOW(), 'CARD', 'SUCCESS'
FROM Reservation r
WHERE r.flight_id=3005 AND r.seat_no='20A'
AND NOT EXISTS (SELECT 1 FROM Payment p WHERE p.resv_id=r.resv_id);

-- 추가: 좌석 샘플 대량 생성 (간단히 가용 좌석 20개씩)
-- ICN->SFO (B789)
INSERT IGNORE INTO Seat (aircraft_id, seat_no, seat_class, status)
VALUES
('B789', '1A', 'BUSINESS', 'AVAILABLE'),
('B789', '1B', 'BUSINESS', 'AVAILABLE'),
('B789', '2A', 'BUSINESS', 'AVAILABLE'),
('B789', '2B', 'BUSINESS', 'AVAILABLE'),
('B789', '10A', 'ECONOMY', 'AVAILABLE'),
('B789', '10B', 'ECONOMY', 'AVAILABLE'),
('B789', '10C', 'ECONOMY', 'AVAILABLE'),
('B789', '11A', 'ECONOMY', 'AVAILABLE'),
('B789', '11B', 'ECONOMY', 'AVAILABLE'),
('B789', '11C', 'ECONOMY', 'AVAILABLE'),
('B789', '12A', 'ECONOMY', 'AVAILABLE'),
('B789', '12B', 'ECONOMY', 'AVAILABLE'),
('B789', '12C', 'ECONOMY', 'AVAILABLE')
ON DUPLICATE KEY UPDATE seat_class=VALUES(seat_class), status=VALUES(status);

-- ICN->NRT (A321)
INSERT IGNORE INTO Seat (aircraft_id, seat_no, seat_class, status)
VALUES
('A321', '1A', 'BUSINESS', 'AVAILABLE'),
('A321', '1B', 'BUSINESS', 'AVAILABLE'),
('A321', '8A', 'ECONOMY', 'AVAILABLE'),
('A321', '8B', 'ECONOMY', 'AVAILABLE'),
('A321', '8C', 'ECONOMY', 'AVAILABLE'),
('A321', '9A', 'ECONOMY', 'AVAILABLE'),
('A321', '9B', 'ECONOMY', 'AVAILABLE'),
('A321', '9C', 'ECONOMY', 'AVAILABLE')
ON DUPLICATE KEY UPDATE seat_class=VALUES(seat_class), status=VALUES(status);

-- NRT->LAX (B789)
INSERT IGNORE INTO Seat (aircraft_id, seat_no, seat_class, status)
VALUES
('B789', '20A', 'ECONOMY', 'AVAILABLE'),
('B789', '20B', 'ECONOMY', 'AVAILABLE'),
('B789', '20C', 'ECONOMY', 'AVAILABLE'),
('B789', '21A', 'ECONOMY', 'AVAILABLE'),
('B789', '21B', 'ECONOMY', 'AVAILABLE'),
('B789', '21C', 'ECONOMY', 'AVAILABLE')
ON DUPLICATE KEY UPDATE seat_class=VALUES(seat_class), status=VALUES(status);

-- 예약 원활화를 위한 좌석 추가 확보: B789 이코노미 22A~26C
INSERT IGNORE INTO Seat (aircraft_id, seat_no, seat_class, status)
VALUES
('B789','22A','ECONOMY','AVAILABLE'),('B789','22B','ECONOMY','AVAILABLE'),('B789','22C','ECONOMY','AVAILABLE'),
('B789','23A','ECONOMY','AVAILABLE'),('B789','23B','ECONOMY','AVAILABLE'),('B789','23C','ECONOMY','AVAILABLE'),
('B789','24A','ECONOMY','AVAILABLE'),('B789','24B','ECONOMY','AVAILABLE'),('B789','24C','ECONOMY','AVAILABLE'),
('B789','25A','ECONOMY','AVAILABLE'),('B789','25B','ECONOMY','AVAILABLE'),('B789','25C','ECONOMY','AVAILABLE'),
('B789','26A','ECONOMY','AVAILABLE'),('B789','26B','ECONOMY','AVAILABLE'),('B789','26C','ECONOMY','AVAILABLE')
ON DUPLICATE KEY UPDATE seat_class=VALUES(seat_class), status=VALUES(status);

-- A321 이코노미 좌석 추가 확보: 12A~16C
INSERT IGNORE INTO Seat (aircraft_id, seat_no, seat_class, status)
VALUES
('A321','12A','ECONOMY','AVAILABLE'),('A321','12B','ECONOMY','AVAILABLE'),('A321','12C','ECONOMY','AVAILABLE'),
('A321','13A','ECONOMY','AVAILABLE'),('A321','13B','ECONOMY','AVAILABLE'),('A321','13C','ECONOMY','AVAILABLE'),
('A321','14A','ECONOMY','AVAILABLE'),('A321','14B','ECONOMY','AVAILABLE'),('A321','14C','ECONOMY','AVAILABLE'),
('A321','15A','ECONOMY','AVAILABLE'),('A321','15B','ECONOMY','AVAILABLE'),('A321','15C','ECONOMY','AVAILABLE'),
('A321','16A','ECONOMY','AVAILABLE'),('A321','16B','ECONOMY','AVAILABLE'),('A321','16C','ECONOMY','AVAILABLE')
ON DUPLICATE KEY UPDATE seat_class=VALUES(seat_class), status=VALUES(status);

-- 테스트 편의를 위한 간단 회원/고객 샘플 (존재하면 갱신)
INSERT IGNORE INTO Member (user_id, email, name)
VALUES
(9001, 'test1@example.com', 'Test One'),
(9002, 'test2@example.com', 'Test Two')
ON DUPLICATE KEY UPDATE email=VALUES(email), name=VALUES(name);

INSERT IGNORE INTO Customer (user_id, grade)
VALUES
(9001, 'ECONOMY'),
(9002, 'BUSINESS')
ON DUPLICATE KEY UPDATE grade=VALUES(grade);

-- 결제 샘플 (예약 전에 결제 데이터가 필요한 경우에 맞춰 조정)
-- 예약 테스트는 애플리케이션 API로 좌석 선택 후 진행 권장

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
