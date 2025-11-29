CREATE TABLE Flight (
  flight_id INT AUTO_INCREMENT PRIMARY KEY,
  route_id INT NOT NULL,
  aircraft_id CHAR(10) NOT NULL,
  base_fare DECIMAL(10,2) NOT NULL,
  current_fare DECIMAL(10,2) NOT NULL,
  departure_time DATETIME NOT NULL,
  arrival_time DATETIME NOT NULL,
  status ENUM('SCHEDULED','DELAYED','CANCELLED','DEPARTED','ARRIVED'),
  FOREIGN KEY (route_id) REFERENCES Route(route_id),
  FOREIGN KEY (aircraft_id) REFERENCES Aircraft(aircraft_id)
);
