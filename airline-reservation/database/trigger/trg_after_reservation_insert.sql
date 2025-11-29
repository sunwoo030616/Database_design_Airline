USE airline;

DROP TRIGGER IF EXISTS trg_after_reservation_insert;

DELIMITER $$

CREATE TRIGGER trg_after_reservation_insert
AFTER INSERT ON Reservation
FOR EACH ROW
BEGIN
    DECLARE v_aircraft_id CHAR(10);
    DECLARE v_old_fare DECIMAL(10,2);
    DECLARE v_new_fare DECIMAL(10,2);
    DECLARE v_total_seats INT;
    DECLARE v_booked_seats INT;
    DECLARE v_occupancy DECIMAL(5,2);

    -- 1. 항공편의 기체/현재 요금 조회 (잠금)
    SELECT aircraft_id, current_fare
      INTO v_aircraft_id, v_old_fare
      FROM Flight
     WHERE flight_id = NEW.flight_id
     FOR UPDATE;

    -- 2. 해당 기체 총 좌석 수
    SELECT COUNT(*)
      INTO v_total_seats
      FROM Seat
     WHERE aircraft_id = v_aircraft_id;

    -- 3. 해당 항공편의 BOOKED 좌석 수
    SELECT COUNT(*)
      INTO v_booked_seats
      FROM Reservation
     WHERE flight_id = NEW.flight_id
       AND status = 'BOOKED';

    SET v_occupancy = v_booked_seats * 100.0 / v_total_seats;
    SET v_new_fare = v_old_fare;

    -- 4. 점유율에 따른 요금 인상
    IF v_occupancy >= 80 THEN
        SET v_new_fare = v_old_fare * 1.20;
    ELSEIF v_occupancy >= 50 THEN
        SET v_new_fare = v_old_fare * 1.10;
    END IF;

    -- 5. 요금이 변경된 경우에만 업데이트 + 로그
    IF v_new_fare <> v_old_fare THEN
        UPDATE Flight
           SET current_fare = v_new_fare
         WHERE flight_id = NEW.flight_id;

        INSERT INTO DynamicFareLog
            (flight_id, resv_id, old_fare, new_fare, change_time, trigger_event)
        VALUES
            (NEW.flight_id, NEW.resv_id, v_old_fare, v_new_fare, NOW(), 'NEW_RESERVATION');
    END IF;
END$$

DELIMITER ;
