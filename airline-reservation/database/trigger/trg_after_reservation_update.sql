USE airline;

DROP TRIGGER IF EXISTS trg_after_reservation_update;

DELIMITER $$

CREATE TRIGGER trg_after_reservation_update
AFTER UPDATE ON Reservation
FOR EACH ROW
BEGIN
    DECLARE v_aircraft_id CHAR(10);

    -- BOOKED → CANCELLED 로 바뀔 때만 동작
    IF OLD.status <> 'CANCELLED' AND NEW.status = 'CANCELLED' THEN

        -- 1. 좌석 상태 AVAILABLE로 복구
        SELECT aircraft_id
          INTO v_aircraft_id
          FROM Flight
         WHERE flight_id = NEW.flight_id;

        UPDATE Seat
           SET status = 'AVAILABLE'
         WHERE aircraft_id = v_aircraft_id
           AND seat_no = NEW.seat_no;

        -- 2. 점유율 감소 반영해서 요금 재계산 (필요하면 인하)
        CALL sp_recalculate_fare(NEW.flight_id, NEW.resv_id, 'CANCEL_RESERVATION');
    END IF;
END$$

DELIMITER ;
