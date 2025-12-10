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
    /* 지역 변수는 BEGIN 바로 다음, 어떤 SQL 이전에 선언해야 합니다 */
    DECLARE v_existing_resv_id INT DEFAULT NULL;
    DECLARE v_existing_status VARCHAR(20) DEFAULT NULL;
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

        /* 중복 예약 키(Flight, Seat)에 대해 기존 CANCELLED 레코드가 있으면 재사용, 그렇지 않으면 새로 생성 */

        SELECT resv_id, status
            INTO v_existing_resv_id, v_existing_status
            FROM Reservation
         WHERE flight_id = p_flight_id
             AND seat_no = p_seat_no
         LIMIT 1;

        IF v_existing_resv_id IS NOT NULL THEN
                -- 기존 예약이 존재하는 경우 상태에 따라 처리
                IF v_existing_status = 'CANCELLED' THEN
                        -- 취소된 예약을 다시 BOOKED로 전환하여 재사용
                        UPDATE Reservation
                             SET user_id = p_user_id,
                                     resv_time = NOW(),
                                     status = 'BOOKED'
                         WHERE resv_id = v_existing_resv_id;

                        SET @new_resv_id = v_existing_resv_id;
                ELSE
                        -- 이미 활성 예약이 존재
                        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '이미 예약된 좌석입니다.';
                END IF;
        ELSE
                -- 기존 예약이 없으면 새로 생성
                INSERT INTO Reservation (flight_id, seat_no, user_id, resv_time, status)
                VALUES (p_flight_id, p_seat_no, p_user_id, NOW(), 'BOOKED');

                -- 가장 최근 예약 번호
                SET @new_resv_id = LAST_INSERT_ID();
        END IF;

        -- 좌석 상태 점유로 변경 (트리거가 없다면 안전하게 동기화)
        UPDATE Seat
             SET status = 'BOOKED'
         WHERE seat_no = p_seat_no
             AND aircraft_id = (SELECT aircraft_id FROM Flight WHERE flight_id = p_flight_id);

    -- 2) 결제 처리: 재사용된 예약에 기존 결제가 있으면 업데이트로 대체
    -- Payment의 기본 키가 resv_id인 환경을 고려하여 UPSERT 사용
    INSERT INTO Payment (resv_id, amount, pay_time, method, status)
    VALUES (@new_resv_id, p_amount, NOW(), p_method, 'PAID')
    ON DUPLICATE KEY UPDATE
        amount = VALUES(amount),
        pay_time = VALUES(pay_time),
        method = VALUES(method),
        status = VALUES(status);

    COMMIT;
END$$

DELIMITER ;
