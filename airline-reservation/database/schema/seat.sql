CREATE TABLE Seat (
  aircraft_id CHAR(10) NOT NULL,
  seat_no VARCHAR(10) NOT NULL,
  seat_class VARCHAR(20) NOT NULL,
  status VARCHAR(20) NOT NULL DEFAULT 'AVAILABLE',
  PRIMARY KEY (aircraft_id, seat_no),
  FOREIGN KEY (aircraft_id) REFERENCES Aircraft(aircraft_id)
);
