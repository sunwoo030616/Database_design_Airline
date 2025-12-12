USE airline;

DROP PROCEDURE IF EXISTS sp_create_reservation_with_payment;

DELIMITER $$

CREATE PROCEDURE sp_create_reservation_with_payment (
    IN p_flight_id INT,
    IN p_user_id   INT,
    IN p_seat_no   VARCHAR(10),
    IN p_amount    DECIMAL(10,2),
    IN p_method    VARCHAR(20)
)
BEGINSELECT * FROM INFORMATION_SCHEMA.ENABLED_ROLES;
    DECLARE v_resv_id INT;

    -- 에러 핸들러: 중간에 오류 나면 전체 롤백 + 에러 발생
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = '예약/결제 처리 중 오류가 발생하여 롤백되었습니다.';
    END;

    START TRANSACTION;

    -- 1. 예약 생성 (좌석 유효성 트리거, 동적 가격 트리거 자동 작동)
    INSERT INTO Reservation (flight_id, seat_no, user_id, resv_time, status)
    VALUES (p_flight_id, p_seat_no, p_user_id, NOW(), 'BOOKED');

    SET v_resv_id = LAST_INSERT_ID();

    -- 2. 결제 생성
    INSERT INTO Payment (resv_id, amount, pay_time, method, status)
    VALUES (v_resv_id, p_amount, NOW(), p_method, 'PAID');

    COMMIT;
END$$

DELIMITER ;
