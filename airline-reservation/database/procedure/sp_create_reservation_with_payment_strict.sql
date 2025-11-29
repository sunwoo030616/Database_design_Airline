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
    -- 오류가 발생하면 자동으로 ROLLBACK + 에러 메시지 반환
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = '예약 또는 결제 처리 중 오류가 발생하여 전체 작업이 취소되었습니다.';
    END;

    START TRANSACTION;

    -- 1) 예약 INSERT
    INSERT INTO Reservation (flight_id, seat_no, user_id, resv_time, status)
    VALUES (p_flight_id, p_seat_no, p_user_id, NOW(), 'BOOKED');

    -- 가장 최근 예약 번호
    SET @new_resv_id = LAST_INSERT_ID();

    -- 2) 결제 INSERT
    INSERT INTO Payment (resv_id, amount, pay_time, method, status)
    VALUES (@new_resv_id, p_amount, NOW(), p_method, 'PAID');

    COMMIT;
END$$

DELIMITER ;
