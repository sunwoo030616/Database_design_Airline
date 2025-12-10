USE airline;

DROP PROCEDURE IF EXISTS sp_create_reservation_with_payment_strict;

DELIMITER $$

CREATE PROCEDURE sp_create_reservation_with_payment_strict(
    IN p_flight_id INT,
    IN p_user_id INT,
    IN p_seat_no VARCHAR(10),
    IN p_amount DECIMAL(10,2),
    IN p_method VARCHAR(20)
)
BEGIN
    /* 선행 유효성 검증으로 정확한 실패 이유를 제공 */
    -- Flight 존재 확인
    IF (SELECT COUNT(*) FROM Flight WHERE flight_id = p_flight_id) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '유효하지 않은 항공편입니다.';
    END IF;

    -- Member 존재 확인
    IF (SELECT COUNT(*) FROM Member WHERE user_id = p_user_id) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '유효하지 않은 회원입니다.';
    END IF;

    -- 좌석 유효성 및 사용 가능 여부 확인
    IF (SELECT COUNT(*) FROM Seat WHERE seat_no = p_seat_no AND aircraft_id = (SELECT aircraft_id FROM Flight WHERE flight_id = p_flight_id)) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '유효하지 않은 좌석입니다.';
    END IF;

    IF (SELECT status FROM Seat WHERE seat_no = p_seat_no AND aircraft_id = (SELECT aircraft_id FROM Flight WHERE flight_id = p_flight_id)) <> 'AVAILABLE' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '이미 예약된 좌석입니다.';
    END IF;

    -- 결제 수단 허용값 확인
    IF (SELECT NOT (p_method IN ('CARD','POINT','BANK_TRANSFER'))) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '허용되지 않은 결제 수단입니다.';
    END IF;

    START TRANSACTION;

    -- 1) 예약 INSERT
    INSERT INTO Reservation (flight_id, seat_no, user_id, resv_time, status)
    VALUES (p_flight_id, p_seat_no, p_user_id, NOW(), 'BOOKED');

    -- 좌석 상태 점유로 변경 (트리거가 있다면 생략 가능)
    UPDATE Seat
    SET status = 'BOOKED'
    WHERE seat_no = p_seat_no
      AND aircraft_id = (SELECT aircraft_id FROM Flight WHERE flight_id = p_flight_id);

    -- 가장 최근 예약 번호
    SET @new_resv_id = LAST_INSERT_ID();

    -- 2) 결제 INSERT
    INSERT INTO Payment (resv_id, amount, pay_time, method, status)
    VALUES (@new_resv_id, p_amount, NOW(), p_method, 'PAID');

    COMMIT;
END$$

DELIMITER ;
