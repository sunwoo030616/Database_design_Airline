-- 확장된 시드 데이터 (50개 이상의 레코드)

-- 추가 공항 (20개)
INSERT INTO Airport VALUES
('CDG', 'Charles de Gaulle Airport', 'Paris', 'France'),
('LHR', 'Heathrow Airport', 'London', 'United Kingdom'),
('FRA', 'Frankfurt Airport', 'Frankfurt', 'Germany'),
('AMS', 'Amsterdam Airport Schiphol', 'Amsterdam', 'Netherlands'),
('SIN', 'Singapore Changi Airport', 'Singapore', 'Singapore'),
('HKG', 'Hong Kong International Airport', 'Hong Kong', 'Hong Kong'),
('DXB', 'Dubai International Airport', 'Dubai', 'UAE'),
('IST', 'Istanbul Airport', 'Istanbul', 'Turkey'),
('PEK', 'Beijing Capital International Airport', 'Beijing', 'China'),
('PVG', 'Shanghai Pudong International Airport', 'Shanghai', 'China'),
('SYD', 'Sydney Kingsford Smith Airport', 'Sydney', 'Australia'),
('MEL', 'Melbourne Airport', 'Melbourne', 'Australia'),
('JFK', 'John F. Kennedy International Airport', 'New York', 'USA'),
('SFO', 'San Francisco International Airport', 'San Francisco', 'USA'),
('ORD', 'Chicago O''Hare International Airport', 'Chicago', 'USA'),
('DFW', 'Dallas/Fort Worth International Airport', 'Dallas', 'USA'),
('YVR', 'Vancouver International Airport', 'Vancouver', 'Canada'),
('YYZ', 'Toronto Pearson International Airport', 'Toronto', 'Canada'),
('BKK', 'Suvarnabhumi Airport', 'Bangkok', 'Thailand'),
('KUL', 'Kuala Lumpur International Airport', 'Kuala Lumpur', 'Malaysia');

-- 추가 항공기 (10개)
INSERT INTO Aircraft VALUES
('A380-01', 'A380', 'Airbus', 550),
('A380-02', 'A380', 'Airbus', 550),
('B747-01', 'B747-8', 'Boeing', 467),
('B747-02', 'B747-8', 'Boeing', 467),
('B777-01', 'B777-300ER', 'Boeing', 396),
('B777-02', 'B777-300ER', 'Boeing', 396),
('A330-01', 'A330-300', 'Airbus', 335),
('A330-02', 'A330-300', 'Airbus', 335),
('B787-01', 'B787-9', 'Boeing', 290),
('B787-02', 'B787-9', 'Boeing', 290);

-- 추가 좌석 (A380 기종에 대해 많은 좌석 생성)
INSERT INTO Seat (aircraft_id, seat_no, seat_class, status)
VALUES
-- A380-01 퍼스트 클래스
('A380-01', '1A', 'First', 'AVAILABLE'),
('A380-01', '1B', 'First', 'AVAILABLE'),
('A380-01', '1C', 'First', 'AVAILABLE'),
('A380-01', '1D', 'First', 'AVAILABLE'),
('A380-01', '2A', 'First', 'AVAILABLE'),
('A380-01', '2B', 'First', 'AVAILABLE'),
('A380-01', '2C', 'First', 'AVAILABLE'),
('A380-01', '2D', 'First', 'AVAILABLE'),
-- A380-01 비즈니스 클래스
('A380-01', '6A', 'Business', 'AVAILABLE'),
('A380-01', '6B', 'Business', 'AVAILABLE'),
('A380-01', '6C', 'Business', 'AVAILABLE'),
('A380-01', '6D', 'Business', 'AVAILABLE'),
('A380-01', '7A', 'Business', 'AVAILABLE'),
('A380-01', '7B', 'Business', 'AVAILABLE'),
('A380-01', '7C', 'Business', 'AVAILABLE'),
('A380-01', '7D', 'Business', 'AVAILABLE'),
-- A380-01 이코노미 클래스 (일부만)
('A380-01', '20A', 'Economy', 'AVAILABLE'),
('A380-01', '20B', 'Economy', 'AVAILABLE'),
('A380-01', '20C', 'Economy', 'AVAILABLE'),
('A380-01', '20D', 'Economy', 'AVAILABLE'),
('A380-01', '20E', 'Economy', 'AVAILABLE'),
('A380-01', '20F', 'Economy', 'AVAILABLE'),
('A380-01', '20G', 'Economy', 'AVAILABLE'),
('A380-01', '20H', 'Economy', 'AVAILABLE'),
-- B777-01 좌석들
('B777-01', '1A', 'Business', 'AVAILABLE'),
('B777-01', '1B', 'Business', 'AVAILABLE'),
('B777-01', '1C', 'Business', 'AVAILABLE'),
('B777-01', '2A', 'Business', 'AVAILABLE'),
('B777-01', '2B', 'Business', 'AVAILABLE'),
('B777-01', '2C', 'Business', 'AVAILABLE'),
('B777-01', '10A', 'Economy', 'AVAILABLE'),
('B777-01', '10B', 'Economy', 'AVAILABLE'),
('B777-01', '10C', 'Economy', 'AVAILABLE'),
('B777-01', '10D', 'Economy', 'AVAILABLE'),
('B777-01', '10E', 'Economy', 'AVAILABLE'),
('B777-01', '10F', 'Economy', 'AVAILABLE');

-- 추가 노선 (25개)
INSERT INTO Route (origin, destination, distance, base_duration)
VALUES
('ICN', 'CDG', 8800, 660),
('ICN', 'LHR', 8900, 670),
('ICN', 'FRA', 8600, 650),
('ICN', 'SIN', 5300, 400),
('ICN', 'HKG', 2100, 180),
('ICN', 'DXB', 7000, 520),
('ICN', 'SYD', 8200, 620),
('ICN', 'JFK', 10900, 820),
('ICN', 'SFO', 9600, 720),
('GMP', 'NRT', 1200, 115),
('GMP', 'KIX', 1050, 105),
('NRT', 'SIN', 5300, 420),
('NRT', 'SFO', 8600, 650),
('KIX', 'BKK', 4600, 350),
('LAX', 'SFO', 550, 80),
('CDG', 'LHR', 460, 70),
('LHR', 'FRA', 650, 90),
('FRA', 'AMS', 370, 65),
('SIN', 'HKG', 2600, 210),
('HKG', 'BKK', 1700, 150),
('DXB', 'IST', 2000, 170),
('SYD', 'MEL', 710, 90),
('JFK', 'LAX', 4000, 360),
('PEK', 'PVG', 1200, 120),
('YVR', 'YYZ', 3400, 270);

-- 추가 회원 (25명) - password 필드 추가
INSERT INTO Member (name, email, phone_num, user_type, password) VALUES
('Park Jimin', 'jimin.park@email.com', '010-1111-2222', 'customer', 'password123'),
('Choi Sooyoung', 'sooyoung.choi@email.com', '010-3333-4444', 'customer', 'password123'),
('Jung Hoseok', 'hoseok.jung@email.com', '010-5555-6666', 'customer', 'password123'),
('Kim Taehyung', 'taehyung.kim@email.com', '010-7777-8888', 'customer', 'password123'),
('Jeon Jungkook', 'jungkook.jeon@email.com', '010-9999-0000', 'customer', 'password123'),
('Song Minho', 'minho.song@email.com', '010-1122-3344', 'customer', 'password123'),
('Lee Jennie', 'jennie.lee@email.com', '010-5566-7788', 'customer', 'password123'),
('Kim Rose', 'rose.kim@email.com', '010-9900-1122', 'customer', 'password123'),
('Park Lisa', 'lisa.park@email.com', '010-3344-5566', 'customer', 'password123'),
('Jisoo Kim', 'jisoo.kim@email.com', '010-7788-9900', 'customer', 'password123'),
('Min Yoongi', 'yoongi.min@email.com', '010-2211-4433', 'customer', 'password123'),
('Kim Seokjin', 'seokjin.kim@email.com', '010-6655-8877', 'customer', 'password123'),
('Kim Namjoon', 'namjoon.kim@email.com', '010-1100-3355', 'customer', 'password123'),
('Yamada Taro', 'taro.yamada@email.com', '080-1234-5678', 'customer', 'password123'),
('Sato Hanako', 'hanako.sato@email.com', '080-8765-4321', 'customer', 'password123'),
('Smith John', 'john.smith@email.com', '555-0123', 'customer', 'password123'),
('Johnson Emma', 'emma.johnson@email.com', '555-0456', 'customer', 'password123'),
('Brown Michael', 'michael.brown@email.com', '555-0789', 'customer', 'password123'),
('Davis Sarah', 'sarah.davis@email.com', '555-0987', 'customer', 'password123'),
('Wilson David', 'david.wilson@email.com', '555-0654', 'customer', 'password123'),
('Taylor Anna', 'anna.taylor@email.com', '555-0321', 'customer', 'password123'),
('Miller Chris', 'chris.miller@email.com', '555-0159', 'customer', 'password123'),
('Garcia Maria', 'maria.garcia@email.com', '555-0753', 'customer', 'password123'),
('Rodriguez Carlos', 'carlos.rodriguez@email.com', '555-0147', 'customer', 'password123'),
('Admin Johnson', 'admin.johnson@email.com', '010-0000-1111', 'admin', 'admin123');

-- Customer 데이터 (24명)
INSERT INTO Customer VALUES
(4, 3500, 'Gold'),
(5, 1200, 'Silver'),
(6, 800, 'Bronze'),
(7, 5000, 'Gold'),
(8, 2100, 'Silver'),
(9, 900, 'Bronze'),
(10, 4200, 'Gold'),
(11, 1800, 'Silver'),
(12, 600, 'Bronze'),
(13, 3100, 'Gold'),
(14, 1500, 'Silver'),
(15, 750, 'Bronze'),
(16, 2800, 'Gold'),
(17, 1300, 'Silver'),
(18, 950, 'Bronze'),
(19, 2200, 'Silver'),
(20, 1100, 'Bronze'),
(21, 3300, 'Gold'),
(22, 1700, 'Silver'),
(23, 850, 'Bronze'),
(24, 2900, 'Gold'),
(25, 1400, 'Silver'),
(26, 700, 'Bronze'),
(27, 2600, 'Gold');

-- Admin 데이터 (1명)
INSERT INTO Admin VALUES
(28, 2);

-- 추가 항공편 (30편)
INSERT INTO Flight (route_id, aircraft_id, base_fare, current_fare, departure_time, arrival_time, status)
VALUES
-- 인천발 국제선
(6, 'A380-01', 1200.00, 1350.00, '2025-12-11 08:30', '2025-12-11 19:30', 'SCHEDULED'),
(7, 'B777-01', 1100.00, 1250.00, '2025-12-11 14:20', '2025-12-12 01:40', 'SCHEDULED'),
(8, 'A380-02', 1000.00, 1150.00, '2025-12-12 10:15', '2025-12-12 21:15', 'SCHEDULED'),
(9, 'B777-02', 800.00, 920.00, '2025-12-12 16:45', '2025-12-13 03:25', 'SCHEDULED'),
(10, 'B787-01', 850.00, 970.00, '2025-12-13 12:30', '2025-12-13 15:40', 'SCHEDULED'),
(11, 'A330-01', 950.00, 1080.00, '2025-12-13 18:10', '2025-12-14 06:50', 'SCHEDULED'),
(12, 'B787-02', 900.00, 1030.00, '2025-12-14 09:25', '2025-12-14 17:45', 'SCHEDULED'),
(13, 'A330-02', 1300.00, 1480.00, '2025-12-14 22:15', '2025-12-15 16:35', 'SCHEDULED'),
(14, 'B747-01', 1500.00, 1700.00, '2025-12-15 11:40', '2025-12-16 02:40', 'SCHEDULED'),
(15, 'B747-02', 1400.00, 1590.00, '2025-12-15 20:30', '2025-12-16 11:30', 'SCHEDULED'),
-- 김포발 항공편
(26, 'A320-01', 180.00, 205.00, '2025-12-16 07:15', '2025-12-16 09:10', 'SCHEDULED'),
(27, 'B737-01', 170.00, 195.00, '2025-12-16 13:30', '2025-12-16 15:25', 'SCHEDULED'),
-- 나리타발 항공편
(28, 'B787-01', 750.00, 850.00, '2025-12-17 10:20', '2025-12-17 17:20', 'SCHEDULED'),
(29, 'A330-01', 600.00, 680.00, '2025-12-17 15:45', '2025-12-18 01:45', 'SCHEDULED'),
-- 간사이발 항공편
(30, 'B737-01', 450.00, 520.00, '2025-12-18 08:30', '2025-12-18 14:20', 'SCHEDULED'),
-- 기타 국제선
(31, 'A320-01', 120.00, 140.00, '2025-12-18 16:10', '2025-12-18 17:30', 'SCHEDULED'),
(32, 'B777-01', 250.00, 290.00, '2025-12-19 11:25', '2025-12-19 12:35', 'SCHEDULED'),
(33, 'A380-01', 300.00, 340.00, '2025-12-19 19:50', '2025-12-19 21:00', 'SCHEDULED'),
(34, 'B787-02', 400.00, 460.00, '2025-12-20 14:15', '2025-12-20 17:45', 'SCHEDULED'),
(35, 'A330-02', 350.00, 400.00, '2025-12-20 22:30', '2025-12-21 01:00', 'SCHEDULED'),
(36, 'B747-01', 500.00, 570.00, '2025-12-21 06:40', '2025-12-21 08:20', 'SCHEDULED'),
(37, 'B737-01', 380.00, 430.00, '2025-12-21 12:55', '2025-12-21 19:55', 'SCHEDULED'),
(38, 'A320-01', 800.00, 920.00, '2025-12-22 09:10', '2025-12-22 15:10', 'SCHEDULED'),
(39, 'B777-02', 220.00, 250.00, '2025-12-22 17:25', '2025-12-23 02:55', 'SCHEDULED'),
(40, 'A380-02', 280.00, 320.00, '2025-12-23 13:45', '2025-12-23 17:15', 'SCHEDULED'),
-- 추가 항공편들
(16, 'B787-01', 320.00, 370.00, '2025-12-24 08:20', '2025-12-24 09:30', 'SCHEDULED'),
(17, 'A330-01', 200.00, 230.00, '2025-12-24 14:50', '2025-12-24 16:20', 'SCHEDULED'),
(18, 'B777-01', 180.00, 210.00, '2025-12-25 10:15', '2025-12-25 11:20', 'SCHEDULED'),
(19, 'A380-01', 420.00, 480.00, '2025-12-25 16:30', '2025-12-25 20:00', 'SCHEDULED'),
(20, 'B747-02', 380.00, 440.00, '2025-12-26 12:40', '2025-12-26 15:10', 'SCHEDULED');

-- 추가 예약 (30개)
INSERT INTO Reservation (flight_id, seat_no, user_id, resv_time, status)
VALUES
(3, '1A', 4, '2025-12-10 10:30:00', 'BOOKED'),
(3, '1B', 5, '2025-12-10 10:35:00', 'BOOKED'),
(3, '1C', 6, '2025-12-10 10:40:00', 'BOOKED'),
(4, '1A', 7, '2025-12-10 11:15:00', 'BOOKED'),
(4, '1B', 8, '2025-12-10 11:20:00', 'BOOKED'),
(5, '6A', 9, '2025-12-10 12:45:00', 'BOOKED'),
(5, '6B', 10, '2025-12-10 12:50:00', 'BOOKED'),
(6, '20A', 11, '2025-12-10 13:25:00', 'BOOKED'),
(6, '20B', 12, '2025-12-10 13:30:00', 'BOOKED'),
(7, '10A', 13, '2025-12-10 14:10:00', 'BOOKED'),
(7, '10B', 14, '2025-12-10 14:15:00', 'BOOKED'),
(8, '1A', 15, '2025-12-10 15:20:00', 'BOOKED'),
(8, '1B', 16, '2025-12-10 15:25:00', 'BOOKED'),
(9, '6A', 17, '2025-12-10 16:40:00', 'BOOKED'),
(10, '20A', 18, '2025-12-10 17:55:00', 'BOOKED'),
(11, '1A', 19, '2025-12-10 18:30:00', 'BOOKED'),
(12, '6A', 20, '2025-12-10 19:15:00', 'BOOKED'),
(13, '20A', 21, '2025-12-10 20:45:00', 'BOOKED'),
(14, '1A', 22, '2025-12-10 21:20:00', 'BOOKED'),
(15, '6A', 23, '2025-12-10 22:10:00', 'BOOKED'),
(16, '1A', 24, '2025-12-10 08:15:00', 'BOOKED'),
(17, '1B', 25, '2025-12-10 08:45:00', 'BOOKED'),
(18, '10A', 26, '2025-12-10 09:30:00', 'BOOKED'),
(19, '20A', 27, '2025-12-10 10:15:00', 'BOOKED'),
(20, '10A', 4, '2025-12-10 11:30:00', 'BOOKED'),
(21, '1A', 5, '2025-12-10 12:20:00', 'BOOKED'),
(22, '6A', 6, '2025-12-10 13:40:00', 'BOOKED'),
(23, '20A', 7, '2025-12-10 14:55:00', 'BOOKED'),
(24, '1A', 8, '2025-12-10 15:35:00', 'CANCELLED'),
(25, '10A', 9, '2025-12-10 16:25:00', 'BOOKED');

-- 추가 결제 (29개 - 취소된 예약 제외)
INSERT INTO Payment VALUES
(33, 1350.00, '2025-12-10 10:30:00', 'CARD', 'PAID'),
(34, 1350.00, '2025-12-10 10:35:00', 'CARD', 'PAID'),
(35, 1350.00, '2025-12-10 10:40:00', 'BANK_TRANSFER', 'PAID'),
(36, 1250.00, '2025-12-10 11:15:00', 'CARD', 'PAID'),
(37, 1250.00, '2025-12-10 11:20:00', 'CARD', 'PAID'),
(38, 1150.00, '2025-12-10 12:45:00', 'CARD', 'PAID'),
(39, 1150.00, '2025-12-10 12:50:00', 'BANK_TRANSFER', 'PAID'),
(40, 920.00, '2025-12-10 13:25:00', 'CARD', 'PAID'),
(41, 920.00, '2025-12-10 13:30:00', 'CARD', 'PAID'),
(42, 970.00, '2025-12-10 14:10:00', 'CARD', 'PAID'),
(43, 970.00, '2025-12-10 14:15:00', 'BANK_TRANSFER', 'PAID'),
(44, 1080.00, '2025-12-10 15:20:00', 'CARD', 'PAID'),
(45, 1080.00, '2025-12-10 15:25:00', 'CARD', 'PAID'),
(46, 1030.00, '2025-12-10 16:40:00', 'CARD', 'PAID'),
(47, 1480.00, '2025-12-10 17:55:00', 'BANK_TRANSFER', 'PAID'),
(48, 1700.00, '2025-12-10 18:30:00', 'CARD', 'PAID'),
(49, 1590.00, '2025-12-10 19:15:00', 'CARD', 'PAID'),
(50, 205.00, '2025-12-10 20:45:00', 'CARD', 'PAID'),
(51, 195.00, '2025-12-10 21:20:00', 'BANK_TRANSFER', 'PAID'),
(52, 850.00, '2025-12-10 22:10:00', 'CARD', 'PAID'),
(53, 680.00, '2025-12-10 08:15:00', 'CARD', 'PAID'),
(54, 520.00, '2025-12-10 08:45:00', 'CARD', 'PAID'),
(55, 140.00, '2025-12-10 09:30:00', 'BANK_TRANSFER', 'PAID'),
(56, 290.00, '2025-12-10 10:15:00', 'CARD', 'PAID'),
(57, 340.00, '2025-12-10 11:30:00', 'CARD', 'PAID'),
(58, 460.00, '2025-12-10 12:20:00', 'CARD', 'PAID'),
(59, 400.00, '2025-12-10 13:40:00', 'BANK_TRANSFER', 'PAID'),
(60, 570.00, '2025-12-10 14:55:00', 'CARD', 'PAID'),
(61, 250.00, '2025-12-10 16:25:00', 'CARD', 'PAID');