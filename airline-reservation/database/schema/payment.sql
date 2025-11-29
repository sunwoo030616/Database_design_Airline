CREATE TABLE Payment (
  resv_id INT PRIMARY KEY,
  amount DECIMAL(10,2) NOT NULL,
  pay_time DATETIME NOT NULL,
  method VARCHAR(20) NOT NULL,
  status VARCHAR(20) NOT NULL,
  FOREIGN KEY (resv_id) REFERENCES Reservation(resv_id)
);
