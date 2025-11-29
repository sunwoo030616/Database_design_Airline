INSERT INTO Airport VALUES
('ICN', 'Incheon International Airport', 'Incheon', 'Korea'),
('GMP', 'Gimpo Airport', 'Seoul', 'Korea'),
('NRT', 'Narita International Airport', 'Tokyo', 'Japan'),
('KIX', 'Kansai International Airport', 'Osaka', 'Japan'),
('LAX', 'Los Angeles International Airport', 'Los Angeles', 'USA');

INSERT INTO Aircraft VALUES
('A320-01', 'A320', 'Airbus', 180),
('B737-01', 'B737', 'Boeing', 160);

INSERT INTO Seat (aircraft_id, seat_no, seat_class, status)
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

INSERT INTO Route (origin, destination, distance, base_duration)
VALUES
('ICN', 'NRT', 1250, 120),
('ICN', 'KIX', 1100, 110),
('ICN', 'LAX', 9530, 720),
('GMP', 'ICN', 50, 30),
('NRT', 'LAX', 8800, 660);

INSERT INTO Member (name, email, phone_num, user_type) VALUES
('Kim Customer', 'kim@example.com', '010-1234-5678', 'customer'),
('Lee Customer', 'lee@example.com', '010-8765-4321', 'customer'),
('Admin Park', 'admin@example.com', '010-0000-0000', 'admin');

INSERT INTO Customer VALUES
(1, 1000, 'Silver'),
(2, 500, 'Bronze');

INSERT INTO Admin VALUES
(3, 1);

INSERT INTO Flight (route_id, aircraft_id, base_fare, current_fare, departure_time, arrival_time, status)
VALUES
(1, 'A320-01', 200.00, 200.00, '2025-12-01 09:00', '2025-12-01 11:00', 'SCHEDULED'),
(3, 'B737-01', 800.00, 800.00, '2025-12-05 15:00', '2025-12-05 23:00', 'SCHEDULED');

INSERT INTO Reservation (flight_id, seat_no, user_id, resv_time, status)
VALUES
(1, '1A', 1, NOW(), 'BOOKED'),
(1, '1B', 2, NOW(), 'BOOKED');

INSERT INTO Payment VALUES
(1, 200.00, NOW(), 'CARD', 'PAID'),
(2, 200.00, NOW(), 'CARD', 'PAID');
