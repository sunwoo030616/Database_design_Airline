CREATE TABLE RevenueAnalysis (
  analysis_id INT AUTO_INCREMENT PRIMARY KEY,
  route_id INT NOT NULL,
  aircraft_id CHAR(10) NOT NULL,
  month DATE NOT NULL,
  seat_class VARCHAR(20) NOT NULL,
  total_revenue DECIMAL(12,2) NOT NULL,
  UNIQUE (route_id, aircraft_id, month, seat_class),
  FOREIGN KEY (route_id) REFERENCES Route(route_id),
  FOREIGN KEY (aircraft_id) REFERENCES Aircraft(aircraft_id)
);
