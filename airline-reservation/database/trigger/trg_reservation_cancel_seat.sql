USE airline;

DROP TRIGGER IF EXISTS trg_reservation_cancel_seat;

DELIMITER $$

CREATE TRIGGER trg_reservation_cancel_seat
AFTER UPDATE ON Reservation
FOR EACH ROW
BEGIN
    -- DECLARE 문은 BEGIN 바로 아래에서만!
    DECLARE v_aircraft_id CHAR(10);

    -- BOOKED → CANCELLED 일 때만 동작
    IF OLD.status = 'BOOKED' AND NEW.status = 'CANCELLED' THEN

        -- 1. flight_id로 aircraft_id 가져오기
        SELECT aircraft_id
        INTO v_aircraft_id
        FROM Flight
        WHERE flight_id = NEW.flight_id;

        -- 2. 좌석 상태를 AVAILABLE 로 변경
        UPDATE Seat
        SET status = 'AVAILABLE'
        WHERE aircraft_id = v_aircraft_id
          AND seat_no = NEW.seat_no;

    END IF;
END$$

DELIMITER ;
