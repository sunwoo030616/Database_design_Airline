CREATE TABLE DynamicFareLog (
  log_id INT AUTO_INCREMENT PRIMARY KEY,
  flight_id INT NOT NULL,
  resv_id INT NULL,
  old_fare DECIMAL(10,2) NOT NULL,
  new_fare DECIMAL(10,2) NOT NULL,
  change_time DATETIME NOT NULL,
  trigger_event VARCHAR(100) NOT NULL,
  FOREIGN KEY (flight_id) REFERENCES Flight(flight_id),
  FOREIGN KEY (resv_id) REFERENCES Reservation(resv_id)
);
