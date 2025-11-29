USE airline;

DROP TRIGGER IF EXISTS trg_after_reservation_insert_seat;

DELIMITER $$

CREATE TRIGGER trg_after_reservation_insert_seat
AFTER INSERT ON Reservation
FOR EACH ROW
BEGIN
    DECLARE v_aircraft_id CHAR(10);

    -- 1. 예약한 항공편이 사용하는 항공기 ID 조회
    SELECT aircraft_id
      INTO v_aircraft_id
      FROM Flight
     WHERE flight_id = NEW.flight_id;

    -- 2. 해당 항공기의 좌석을 BOOKED로 변경
    UPDATE Seat
       SET status = 'BOOKED'
     WHERE aircraft_id = v_aircraft_id
       AND seat_no = NEW.seat_no;
END$$

DELIMITER ;
