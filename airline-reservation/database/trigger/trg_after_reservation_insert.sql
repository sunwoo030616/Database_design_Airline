USE airline;

DROP TRIGGER IF EXISTS trg_after_reservation_insert;

DELIMITER $$

CREATE TRIGGER trg_after_reservation_insert
AFTER INSERT ON Reservation
FOR EACH ROW
BEGIN
    -- 예약 발생 시 고급 요금 재계산 로직 호출
    CALL sp_recalculate_fare(NEW.flight_id, NEW.resv_id, 'NEW_RESERVATION');
END$$

DELIMITER ;
