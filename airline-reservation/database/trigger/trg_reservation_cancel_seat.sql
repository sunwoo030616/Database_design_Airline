USE airline;

DROP TRIGGER IF EXISTS trg_reservation_cancel_seat;

DELIMITER $$

CREATE TRIGGER trg_reservation_cancel_seat
AFTER UPDATE ON Reservation
FOR EACH ROW
BEGIN
    DECLARE v_aircraft_id CHAR(10);

    IF OLD.status = 'BOOKED' AND NEW.status = 'CANCELLED' THEN

        -- 좌석 상태 복구
        SELECT aircraft_id INTO v_aircraft_id
        FROM Flight
        WHERE flight_id = NEW.flight_id;

        UPDATE Seat
        SET status = 'AVAILABLE'
        WHERE aircraft_id = v_aircraft_id
          AND seat_no = NEW.seat_no;

        -- ★ 결제 금액을 매출에서 제외 (0원 처리 + 상태 변경)
        UPDATE Payment
        SET amount = 0,
            status = 'CANCELLED'
        WHERE resv_id = NEW.resv_id;

        -- ★ 요금 재계산 (점유율 감소 반영)
        CALL sp_recalculate_fare(
            NEW.flight_id,
            NEW.resv_id,
            'CANCEL_RESERVATION'
        );

    END IF;
END$$


DELIMITER ;
