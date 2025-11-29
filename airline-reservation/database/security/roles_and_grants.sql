USE airline;

-- ROLE 생성 (MySQL 8 이상 지원)
CREATE ROLE IF NOT EXISTS role_admin;
CREATE ROLE IF NOT EXISTS role_staff;
CREATE ROLE IF NOT EXISTS role_auditor;

-- 관리자: 모든 권한
GRANT ALL PRIVILEGES ON airline.* TO role_admin;

-- 스태프: 조회 + 예약/결제 INSERT/UPDATE
GRANT SELECT ON airline.* TO role_staff;
GRANT INSERT, UPDATE ON airline.Reservation TO role_staff;
GRANT INSERT, UPDATE ON airline.Payment     TO role_staff;

-- 감사(Auditor): SELECT만
GRANT SELECT ON airline.* TO role_auditor;

-- 실제 사용자에게 ROLE 부여 예시
-- (MySQL 사용자 sunwoo, teammate 가 이미 있다고 가정)
GRANT role_admin  TO 'sunwoo'@'localhost';
GRANT role_staff  TO 'teammate'@'localhost';

-- ROLE 활성화 예시
SET ROLE role_staff;
