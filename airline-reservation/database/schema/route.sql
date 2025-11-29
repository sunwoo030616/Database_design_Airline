CREATE TABLE Route (
  route_id INT AUTO_INCREMENT PRIMARY KEY,
  origin CHAR(3) NOT NULL,
  destination CHAR(3) NOT NULL,
  distance INT NOT NULL,
  base_duration INT NOT NULL,
  FOREIGN KEY (origin) REFERENCES Airport(airport_code),
  FOREIGN KEY (destination) REFERENCES Airport(airport_code)
);
