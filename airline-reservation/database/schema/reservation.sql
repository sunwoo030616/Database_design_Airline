CREATE TABLE Reservation (
  resv_id INT AUTO_INCREMENT PRIMARY KEY,
  flight_id INT NOT NULL,
  seat_no VARCHAR(10) NOT NULL,
  user_id INT NOT NULL,
  resv_time DATETIME NOT NULL,
  status VARCHAR(20) NOT NULL,
  UNIQUE (flight_id, seat_no),
  FOREIGN KEY (flight_id) REFERENCES Flight(flight_id),
  FOREIGN KEY (user_id) REFERENCES Member(user_id)
);
