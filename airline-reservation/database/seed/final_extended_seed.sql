-- 최종 수정된 확장 시드 데이터

-- 추가 공항 (완전히 새로운 공항들만)
INSERT IGNORE INTO Airport VALUES
('MAD', 'Adolfo Suárez Madrid-Barajas Airport', 'Madrid', 'Spain'),
('FCO', 'Leonardo da Vinci International Airport', 'Rome', 'Italy'),
('ZUR', 'Zurich Airport', 'Zurich', 'Switzerland'),
('VIE', 'Vienna International Airport', 'Vienna', 'Austria'),
('CPH', 'Copenhagen Airport', 'Copenhagen', 'Denmark'),
('ARN', 'Stockholm Arlanda Airport', 'Stockholm', 'Sweden'),
('HEL', 'Helsinki Airport', 'Helsinki', 'Finland'),
('WAW', 'Warsaw Chopin Airport', 'Warsaw', 'Poland'),
('PRG', 'Václav Havel Airport Prague', 'Prague', 'Czech Republic'),
('BUD', 'Budapest Ferenc Liszt International Airport', 'Budapest', 'Hungary'),
('ATH', 'Athens International Airport', 'Athens', 'Greece'),
('LIS', 'Lisbon Airport', 'Lisbon', 'Portugal'),
('OSL', 'Oslo Airport', 'Oslo', 'Norway'),
('GOT', 'Gothenburg Landvetter Airport', 'Gothenburg', 'Sweden'),
('TRD', 'Trondheim Airport', 'Trondheim', 'Norway');

-- 추가 항공기 (완전히 새로운 항공기들만)
INSERT IGNORE INTO Aircraft VALUES
('A350-01', 'A350-900', 'Airbus', 325),
('A350-02', 'A350-900', 'Airbus', 325),
('A321-01', 'A321', 'Airbus', 220),
('A321-02', 'A321', 'Airbus', 220),
('B738-01', 'B737-800', 'Boeing', 189),
('B738-02', 'B737-800', 'Boeing', 189),
('B78X-01', 'B787-10', 'Boeing', 330),
('B78X-02', 'B787-10', 'Boeing', 330);

-- 새로운 항공기들에 대한 좌석 추가 (중복 방지)
INSERT IGNORE INTO Seat (aircraft_id, seat_no, seat_class, status)
VALUES
-- A350-01 좌석들
('A350-01', '1A', 'Business', 'AVAILABLE'),
('A350-01', '1B', 'Business', 'AVAILABLE'),
('A350-01', '1C', 'Business', 'AVAILABLE'),
('A350-01', '2A', 'Business', 'AVAILABLE'),
('A350-01', '2B', 'Business', 'AVAILABLE'),
('A350-01', '2C', 'Business', 'AVAILABLE'),
('A350-01', '15A', 'Economy', 'AVAILABLE'),
('A350-01', '15B', 'Economy', 'AVAILABLE'),
('A350-01', '15C', 'Economy', 'AVAILABLE'),
('A350-01', '15D', 'Economy', 'AVAILABLE'),
-- A350-02 좌석들
('A350-02', '1A', 'Business', 'AVAILABLE'),
('A350-02', '1B', 'Business', 'AVAILABLE'),
('A350-02', '1C', 'Business', 'AVAILABLE'),
('A350-02', '15A', 'Economy', 'AVAILABLE'),
('A350-02', '15B', 'Economy', 'AVAILABLE'),
('A350-02', '15C', 'Economy', 'AVAILABLE'),
-- A321-01 좌석들
('A321-01', '1A', 'Business', 'AVAILABLE'),
('A321-01', '1B', 'Business', 'AVAILABLE'),
('A321-01', '1C', 'Business', 'AVAILABLE'),
('A321-01', '10A', 'Economy', 'AVAILABLE'),
('A321-01', '10B', 'Economy', 'AVAILABLE'),
('A321-01', '10C', 'Economy', 'AVAILABLE'),
('A321-01', '10D', 'Economy', 'AVAILABLE'),
('A321-01', '10E', 'Economy', 'AVAILABLE'),
('A321-01', '10F', 'Economy', 'AVAILABLE'),
-- A321-02 좌석들
('A321-02', '1A', 'Business', 'AVAILABLE'),
('A321-02', '1B', 'Business', 'AVAILABLE'),
('A321-02', '1C', 'Business', 'AVAILABLE'),
('A321-02', '10A', 'Economy', 'AVAILABLE'),
('A321-02', '10B', 'Economy', 'AVAILABLE'),
('A321-02', '10C', 'Economy', 'AVAILABLE'),
-- B738-01 좌석들
('B738-01', '1A', 'Business', 'AVAILABLE'),
('B738-01', '1B', 'Business', 'AVAILABLE'),
('B738-01', '1C', 'Business', 'AVAILABLE'),
('B738-01', '12A', 'Economy', 'AVAILABLE'),
('B738-01', '12B', 'Economy', 'AVAILABLE'),
('B738-01', '12C', 'Economy', 'AVAILABLE'),
-- B738-02 좌석들
('B738-02', '1A', 'Business', 'AVAILABLE'),
('B738-02', '1B', 'Business', 'AVAILABLE'),
('B738-02', '1C', 'Business', 'AVAILABLE'),
('B738-02', '12A', 'Economy', 'AVAILABLE'),
('B738-02', '12B', 'Economy', 'AVAILABLE'),
('B738-02', '12C', 'Economy', 'AVAILABLE');

-- 추가 노선 (새로운 공항들을 이용한 노선)
INSERT INTO Route (origin, destination, distance, base_duration)
VALUES
('ICN', 'MAD', 11000, 830),
('ICN', 'FCO', 9500, 720),
('ICN', 'ZUR', 9200, 690),
('ICN', 'VIE', 8800, 660),
('ICN', 'CPH', 7800, 590),
('ICN', 'ARN', 7600, 570),
('ICN', 'HEL', 7400, 560),
('ICN', 'WAW', 8200, 620),
('ICN', 'PRG', 8600, 650),
('ICN', 'BUD', 8900, 670),
('ICN', 'ATH', 9800, 740),
('ICN', 'LIS', 12000, 900),
('GMP', 'MAD', 11050, 835),
('GMP', 'FCO', 9550, 725),
('NRT', 'ZUR', 9800, 740);

-- 트리거 비활성화
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO';
SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, AUTOCOMMIT=0;
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;

-- 추가 항공편 (직접 route_id 값 사용)
INSERT INTO Flight (route_id, aircraft_id, base_fare, current_fare, departure_time, arrival_time, status)
VALUES
-- 새로운 노선들의 route_id는 기존 노선 수 + 1부터 시작
(31, 'A350-01', 1300.00, 1450.00, '2025-12-20 10:30', '2025-12-21 00:20', 'SCHEDULED'),
(32, 'A350-02', 1200.00, 1350.00, '2025-12-21 14:15', '2025-12-22 02:15', 'SCHEDULED'),
(33, 'A321-01', 1100.00, 1250.00, '2025-12-22 16:45', '2025-12-23 03:15', 'SCHEDULED'),
(34, 'A321-02', 1000.00, 1150.00, '2025-12-23 12:20', '2025-12-23 23:20', 'SCHEDULED'),
(35, 'B738-01', 900.00, 1030.00, '2025-12-24 18:30', '2025-12-25 04:20', 'SCHEDULED'),
(36, 'B738-02', 850.00, 980.00, '2025-12-25 08:45', '2025-12-25 18:15', 'SCHEDULED'),
(37, 'B78X-01', 800.00, 920.00, '2025-12-26 11:10', '2025-12-26 20:30', 'SCHEDULED'),
(38, 'B78X-02', 950.00, 1090.00, '2025-12-27 15:25', '2025-12-28 01:45', 'SCHEDULED');

-- 새로운 항공편들에 대한 예약 (직접 flight_id 값 사용)
INSERT INTO Reservation (flight_id, seat_no, user_id, resv_time, status)
VALUES
-- 새로 추가된 항공편들에 대한 예약 (flight_id는 계산하여 사용)
(41, '1A', 4, '2025-12-10 09:30:00', 'BOOKED'),
(42, '1B', 5, '2025-12-10 10:15:00', 'BOOKED'),
(43, '1A', 6, '2025-12-10 11:20:00', 'BOOKED'),
(44, '1B', 7, '2025-12-10 12:45:00', 'BOOKED'),
(45, '1A', 8, '2025-12-10 13:30:00', 'BOOKED'),
(46, '1B', 9, '2025-12-10 14:15:00', 'BOOKED'),
(47, '1A', 10, '2025-12-10 15:45:00', 'BOOKED'),
(48, '1B', 11, '2025-12-10 16:30:00', 'BOOKED');

-- 새로운 예약들에 대한 결제 (올바른 컬럼명 사용)
INSERT INTO Payment (resv_id, amount, pay_time, method, status)
VALUES
(41, 1450.00, '2025-12-10 09:30:00', 'CARD', 'PAID'),
(42, 1350.00, '2025-12-10 10:15:00', 'CARD', 'PAID'),
(43, 1250.00, '2025-12-10 11:20:00', 'BANK_TRANSFER', 'PAID'),
(44, 1150.00, '2025-12-10 12:45:00', 'CARD', 'PAID'),
(45, 1030.00, '2025-12-10 13:30:00', 'CARD', 'PAID'),
(46, 980.00, '2025-12-10 14:15:00', 'BANK_TRANSFER', 'PAID'),
(47, 920.00, '2025-12-10 15:45:00', 'CARD', 'PAID'),
(48, 1090.00, '2025-12-10 16:30:00', 'CARD', 'PAID');

-- 설정 복원
SET SQL_MODE=@OLD_SQL_MODE;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;