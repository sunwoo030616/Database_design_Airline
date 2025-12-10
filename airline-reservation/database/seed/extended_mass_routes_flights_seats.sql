USE airline;

-- 대량 경로/항공편/좌석 시드 추가

-- 1) 경로 추가 (여러 허브/도시)
INSERT INTO Route (origin_airport, destination_airport, distance, base_duration)
VALUES
 ('ICN','SFO', 9100, 650),
 ('ICN','NRT', 1250, 150),
 ('NRT','SFO', 8200, 600),
 ('ICN','KIX', 860, 110),
 ('KIX','LAX', 9000, 650),
 ('ICN','DXB', 6760, 540),
 ('DXB','LAX', 13395, 980),
 ('SFO','LAX', 543, 90),
 ('ICN','SIN', 4650, 380),
 ('SIN','SYD', 6300, 540),
 ('SYD','LAX', 12050, 900),
 ('ICN','BKK', 3700, 320),
 ('BKK','LAX', 12800, 960),
 ('ICN','TPE', 1500, 140),
 ('TPE','LAX', 10900, 780),
 ('ICN','HKG', 2070, 210),
 ('HKG','LAX', 10400, 760),
 ('ICN','SEA', 8500, 630),
 ('SEA','LAX', 1540, 180),
 ('ICN','YVR', 7900, 600),
 ('YVR','LAX', 1730, 190),
 ('ICN','JFK', 11000, 820),
 ('JFK','LAX', 3970, 360);

-- 2) 항공기 추가 (간단 샘플)
INSERT INTO Aircraft (aircraft_id, model, capacity)
VALUES
 ('AC001','A350-900', 300),
 ('AC002','B787-9', 290),
 ('AC003','B777-300ER', 360),
 ('AC004','A330-300', 280),
 ('AC005','B737-800', 180);

-- 3) 항공편 추가 (여러 날짜/노선)
-- 주의: route_id는 실제 DB의 Route PK에 맞춰야 하므로, 여기서는 예시로 SELECT로 매칭하여 삽입
-- ICN→LAX 경유 후보들을 다양하게 생성
INSERT INTO Flight (route_id, aircraft_id, departure_time, arrival_time, status, current_fare)
SELECT r.route_id, 'AC001', '2025-12-15 09:00:00', '2025-12-15 19:50:00', 'SCHEDULED', 1200000
FROM Route r WHERE r.origin_airport='ICN' AND r.destination_airport='SFO'; -- flight_id 예상: 자동증가

INSERT INTO Flight (route_id, aircraft_id, departure_time, arrival_time, status, current_fare)
SELECT r.route_id, 'AC002', '2025-12-15 08:30:00', '2025-12-15 10:00:00', 'SCHEDULED', 400000
FROM Route r WHERE r.origin_airport='ICN' AND r.destination_airport='NRT';

INSERT INTO Flight (route_id, aircraft_id, departure_time, arrival_time, status, current_fare)
SELECT r.route_id, 'AC002', '2025-12-15 13:00:00', '2025-12-15 23:00:00', 'SCHEDULED', 950000
FROM Route r WHERE r.origin_airport='NRT' AND r.destination_airport='SFO';

INSERT INTO Flight (route_id, aircraft_id, departure_time, arrival_time, status, current_fare)
SELECT r.route_id, 'AC003', '2025-12-15 07:40:00', '2025-12-15 09:30:00', 'SCHEDULED', 300000
FROM Route r WHERE r.origin_airport='ICN' AND r.destination_airport='KIX';

INSERT INTO Flight (route_id, aircraft_id, departure_time, arrival_time, status, current_fare)
SELECT r.route_id, 'AC003', '2025-12-15 12:00:00', '2025-12-15 22:50:00', 'SCHEDULED', 980000
FROM Route r WHERE r.origin_airport='KIX' AND r.destination_airport='LAX';

INSERT INTO Flight (route_id, aircraft_id, departure_time, arrival_time, status, current_fare)
SELECT r.route_id, 'AC004', '2025-12-15 10:20:00', '2025-12-15 18:40:00', 'SCHEDULED', 700000
FROM Route r WHERE r.origin_airport='ICN' AND r.destination_airport='DXB';

INSERT INTO Flight (route_id, aircraft_id, departure_time, arrival_time, status, current_fare)
SELECT r.route_id, 'AC004', '2025-12-15 23:20:00', '2025-12-16 11:40:00', 'SCHEDULED', 1300000
FROM Route r WHERE r.origin_airport='DXB' AND r.destination_airport='LAX';

INSERT INTO Flight (route_id, aircraft_id, departure_time, arrival_time, status, current_fare)
SELECT r.route_id, 'AC005', '2025-12-15 20:30:00', '2025-12-15 22:10:00', 'SCHEDULED', 250000
FROM Route r WHERE r.origin_airport='SFO' AND r.destination_airport='LAX';

-- 4) 좌석 시드: 각 항공기에 좌석 대량 생성 (간단히 앞 20석만)
-- 좌석 클래스는 단순히 앞쪽 비즈니스, 뒤쪽 이코노미 예시
-- AC001
INSERT INTO Seat (aircraft_id, seat_no, seat_class, status)
VALUES
 ('AC001','1A','BUSINESS','AVAILABLE'),('AC001','1B','BUSINESS','AVAILABLE'),('AC001','1C','BUSINESS','AVAILABLE'),('AC001','1D','BUSINESS','AVAILABLE'),
 ('AC001','2A','BUSINESS','AVAILABLE'),('AC001','2B','BUSINESS','AVAILABLE'),('AC001','2C','BUSINESS','AVAILABLE'),('AC001','2D','BUSINESS','AVAILABLE'),
 ('AC001','3A','ECONOMY','AVAILABLE'),('AC001','3B','ECONOMY','AVAILABLE'),('AC001','3C','ECONOMY','AVAILABLE'),('AC001','3D','ECONOMY','AVAILABLE'),
 ('AC001','4A','ECONOMY','AVAILABLE'),('AC001','4B','ECONOMY','AVAILABLE'),('AC001','4C','ECONOMY','AVAILABLE'),('AC001','4D','ECONOMY','AVAILABLE'),
 ('AC001','5A','ECONOMY','AVAILABLE'),('AC001','5B','ECONOMY','AVAILABLE'),('AC001','5C','ECONOMY','AVAILABLE'),('AC001','5D','ECONOMY','AVAILABLE');

-- AC002
INSERT INTO Seat (aircraft_id, seat_no, seat_class, status)
VALUES
 ('AC002','1A','BUSINESS','AVAILABLE'),('AC002','1B','BUSINESS','AVAILABLE'),('AC002','1C','BUSINESS','AVAILABLE'),('AC002','1D','BUSINESS','AVAILABLE'),
 ('AC002','2A','BUSINESS','AVAILABLE'),('AC002','2B','BUSINESS','AVAILABLE'),('AC002','2C','BUSINESS','AVAILABLE'),('AC002','2D','BUSINESS','AVAILABLE'),
 ('AC002','3A','ECONOMY','AVAILABLE'),('AC002','3B','ECONOMY','AVAILABLE'),('AC002','3C','ECONOMY','AVAILABLE'),('AC002','3D','ECONOMY','AVAILABLE'),
 ('AC002','4A','ECONOMY','AVAILABLE'),('AC002','4B','ECONOMY','AVAILABLE'),('AC002','4C','ECONOMY','AVAILABLE'),('AC002','4D','ECONOMY','AVAILABLE'),
 ('AC002','5A','ECONOMY','AVAILABLE'),('AC002','5B','ECONOMY','AVAILABLE'),('AC002','5C','ECONOMY','AVAILABLE'),('AC002','5D','ECONOMY','AVAILABLE');

-- AC003
INSERT INTO Seat (aircraft_id, seat_no, seat_class, status)
VALUES
 ('AC003','1A','BUSINESS','AVAILABLE'),('AC003','1B','BUSINESS','AVAILABLE'),('AC003','1C','BUSINESS','AVAILABLE'),('AC003','1D','BUSINESS','AVAILABLE'),
 ('AC003','2A','BUSINESS','AVAILABLE'),('AC003','2B','BUSINESS','AVAILABLE'),('AC003','2C','BUSINESS','AVAILABLE'),('AC003','2D','BUSINESS','AVAILABLE'),
 ('AC003','3A','ECONOMY','AVAILABLE'),('AC003','3B','ECONOMY','AVAILABLE'),('AC003','3C','ECONOMY','AVAILABLE'),('AC003','3D','ECONOMY','AVAILABLE'),
 ('AC003','4A','ECONOMY','AVAILABLE'),('AC003','4B','ECONOMY','AVAILABLE'),('AC003','4C','ECONOMY','AVAILABLE'),('AC003','4D','ECONOMY','AVAILABLE'),
 ('AC003','5A','ECONOMY','AVAILABLE'),('AC003','5B','ECONOMY','AVAILABLE'),('AC003','5C','ECONOMY','AVAILABLE'),('AC003','5D','ECONOMY','AVAILABLE');

-- AC004
INSERT INTO Seat (aircraft_id, seat_no, seat_class, status)
VALUES
 ('AC004','1A','BUSINESS','AVAILABLE'),('AC004','1B','BUSINESS','AVAILABLE'),('AC004','1C','BUSINESS','AVAILABLE'),('AC004','1D','BUSINESS','AVAILABLE'),
 ('AC004','2A','BUSINESS','AVAILABLE'),('AC004','2B','BUSINESS','AVAILABLE'),('AC004','2C','BUSINESS','AVAILABLE'),('AC004','2D','BUSINESS','AVAILABLE'),
 ('AC004','3A','ECONOMY','AVAILABLE'),('AC004','3B','ECONOMY','AVAILABLE'),('AC004','3C','ECONOMY','AVAILABLE'),('AC004','3D','ECONOMY','AVAILABLE'),
 ('AC004','4A','ECONOMY','AVAILABLE'),('AC004','4B','ECONOMY','AVAILABLE'),('AC004','4C','ECONOMY','AVAILABLE'),('AC004','4D','ECONOMY','AVAILABLE'),
 ('AC004','5A','ECONOMY','AVAILABLE'),('AC004','5B','ECONOMY','AVAILABLE'),('AC004','5C','ECONOMY','AVAILABLE'),('AC004','5D','ECONOMY','AVAILABLE');

-- AC005
INSERT INTO Seat (aircraft_id, seat_no, seat_class, status)
VALUES
 ('AC005','1A','BUSINESS','AVAILABLE'),('AC005','1B','BUSINESS','AVAILABLE'),('AC005','1C','BUSINESS','AVAILABLE'),('AC005','1D','BUSINESS','AVAILABLE'),
 ('AC005','2A','BUSINESS','AVAILABLE'),('AC005','2B','BUSINESS','AVAILABLE'),('AC005','2C','BUSINESS','AVAILABLE'),('AC005','2D','BUSINESS','AVAILABLE'),
 ('AC005','3A','ECONOMY','AVAILABLE'),('AC005','3B','ECONOMY','AVAILABLE'),('AC005','3C','ECONOMY','AVAILABLE'),('AC005','3D','ECONOMY','AVAILABLE'),
 ('AC005','4A','ECONOMY','AVAILABLE'),('AC005','4B','ECONOMY','AVAILABLE'),('AC005','4C','ECONOMY','AVAILABLE'),('AC005','4D','ECONOMY','AVAILABLE'),
 ('AC005','5A','ECONOMY','AVAILABLE'),('AC005','5B','ECONOMY','AVAILABLE'),('AC005','5C','ECONOMY','AVAILABLE'),('AC005','5D','ECONOMY','AVAILABLE');
