CREATE TABLE Member (
  user_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(50),
  email VARCHAR(100) UNIQUE NOT NULL,
  phone_num VARCHAR(20),
  user_type VARCHAR(20) NOT NULL
);

CREATE TABLE Customer (
  user_id INT PRIMARY KEY,
  mileage INT NOT NULL DEFAULT 0,
  grade VARCHAR(20) NOT NULL DEFAULT 'Bronze',
  FOREIGN KEY (user_id) REFERENCES Member(user_id)
);

CREATE TABLE Admin (
  user_id INT PRIMARY KEY,
  role INT NOT NULL,
  FOREIGN KEY (user_id) REFERENCES Member(user_id)
);
