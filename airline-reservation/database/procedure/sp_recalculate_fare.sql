USE airline;

DROP PROCEDURE IF EXISTS sp_recalculate_fare;

DELIMITER $$

CREATE PROCEDURE sp_recalculate_fare(
    IN p_flight_id INT,
    IN p_resv_id   INT,
    IN p_trigger_event VARCHAR(50)
)
BEGIN
    DECLARE v_aircraft_id CHAR(10);
    DECLARE v_base_fare DECIMAL(10,2);
    DECLARE v_old_fare  DECIMAL(10,2);
    DECLARE v_new_fare  DECIMAL(10,2);
    DECLARE v_total_seats   INT;
    DECLARE v_booked_seats  INT;
    DECLARE v_occupancy     DECIMAL(5,2);
    DECLARE v_departure     DATETIME;
    DECLARE v_hours_to_dep  INT;
    DECLARE v_occ_factor    DECIMAL(5,2);
    DECLARE v_time_factor   DECIMAL(5,2);

    -- 1. 기본 정보 + 잠금
    SELECT aircraft_id, base_fare, current_fare, departure_time
      INTO v_aircraft_id, v_base_fare, v_old_fare, v_departure
      FROM Flight
     WHERE flight_id = p_flight_id
     FOR UPDATE;

    -- 2. 좌석 수 정보
    SELECT COUNT(*) INTO v_total_seats
      FROM Seat
     WHERE aircraft_id = v_aircraft_id;

    SELECT COUNT(*) INTO v_booked_seats
      FROM Reservation
     WHERE flight_id = p_flight_id
       AND status = 'BOOKED';

    IF v_total_seats = 0 THEN
        SET v_occ_factor = 1.00;
    ELSE
        SET v_occupancy = v_booked_seats * 100.0 / v_total_seats;

        -- 점유율 기반 요인
        --  <30%  : 10% 할인
        --  30~50 : 기본
        --  50~80 : 10% 인상
        --  >=80% : 20% 인상
        IF v_occupancy < 30 THEN
            SET v_occ_factor = 0.90;
        ELSEIF v_occupancy < 50 THEN
            SET v_occ_factor = 1.00;
        ELSEIF v_occupancy < 80 THEN
            SET v_occ_factor = 1.10;
        ELSE
            SET v_occ_factor = 1.20;
        END IF;
    END IF;

    -- 3. 출발까지 남은 시간 기반 요인
    --   72시간 초과 : 영향 없음
    --   24~72시간   : 5% 인상
    --   24시간 이내 : 10% 인상
    SET v_hours_to_dep = TIMESTAMPDIFF(HOUR, NOW(), v_departure);

    IF v_hours_to_dep IS NULL OR v_hours_to_dep > 72 THEN
        SET v_time_factor = 1.00;
    ELSEIF v_hours_to_dep > 24 THEN
        SET v_time_factor = 1.05;
    ELSE
        SET v_time_factor = 1.10;
    END IF;

    -- 4. 최종 요금 계산: base_fare * 점유율 요인 * 시간 요인
    SET v_new_fare = ROUND(v_base_fare * v_occ_factor * v_time_factor, 2);

    -- 5. 변경 시 업데이트 + 로그, 변경 없더라도 취소 이벤트는 로그 남김
    IF v_new_fare <> v_old_fare THEN
        UPDATE Flight
           SET current_fare = v_new_fare
         WHERE flight_id = p_flight_id;

        INSERT INTO DynamicFareLog
            (flight_id, resv_id, old_fare, new_fare, change_time, trigger_event)
        VALUES
            (p_flight_id, p_resv_id, v_old_fare, v_new_fare, NOW(), p_trigger_event);
    ELSEIF p_trigger_event = 'CANCEL_RESERVATION' THEN
        -- 취소로 점유율만 변경되어 요금 변동이 없더라도 이벤트 기록
        INSERT INTO DynamicFareLog
            (flight_id, resv_id, old_fare, new_fare, change_time, trigger_event)
        VALUES
            (p_flight_id, p_resv_id, v_old_fare, v_old_fare, NOW(), p_trigger_event);
    END IF;
END$$

DELIMITER ;
