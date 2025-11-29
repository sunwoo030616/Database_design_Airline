USE airline;

DROP TRIGGER IF EXISTS trg_check_seat_validity;

DELIMITER $$

CREATE TRIGGER trg_check_seat_validity
BEFORE INSERT ON Reservation
FOR EACH ROW
BEGIN
    DECLARE v_aircraft_id CHAR(10);

    -- 1. 예약하려는 항공편의 기체 ID 조회
    SELECT aircraft_id
      INTO v_aircraft_id
      FROM Flight
     WHERE flight_id = NEW.flight_id;

    IF v_aircraft_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = '존재하지 않는 항공편입니다.';
    END IF;

    -- 2. 해당 기체에 해당 좌석이 실제 존재하는지 확인
    IF NOT EXISTS (
        SELECT 1
          FROM Seat
         WHERE aircraft_id = v_aircraft_id
           AND seat_no = NEW.seat_no
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = '유효하지 않은 좌석입니다.';
    END IF;
END$$

DELIMITER ;
