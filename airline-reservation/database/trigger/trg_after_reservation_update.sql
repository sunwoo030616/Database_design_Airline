USE airline;

DROP TRIGGER IF EXISTS trg_after_reservation_update;

DELIMITER $$

CREATE TRIGGER trg_after_reservation_update
AFTER UPDATE ON Reservation
FOR EACH ROW
BEGIN
    DECLARE v_aircraft_id CHAR(10);
    DECLARE v_curr_fare DECIMAL(10,2);

    -- 상태가 CANCELLED로 바뀐 경우에만 동작
    IF OLD.status <> 'CANCELLED' AND NEW.status = 'CANCELLED' THEN

        -- 1. 항공편의 기체 ID 조회
        SELECT aircraft_id
          INTO v_aircraft_id
          FROM Flight
         WHERE flight_id = NEW.flight_id;

        -- 2. 좌석 상태를 AVAILABLE로 변경
        UPDATE Seat
           SET status = 'AVAILABLE'
         WHERE aircraft_id = v_aircraft_id
           AND seat_no = NEW.seat_no;

        -- 3. 현재 요금 조회 후 로그 기록
        SELECT current_fare
          INTO v_curr_fare
          FROM Flight
         WHERE flight_id = NEW.flight_id;

        INSERT INTO DynamicFareLog
            (flight_id, resv_id, old_fare, new_fare, change_time, trigger_event)
        VALUES
            (NEW.flight_id, NEW.resv_id, v_curr_fare, v_curr_fare, NOW(), 'CANCEL_RESERVATION');
    END IF;
END$$

DELIMITER ;
