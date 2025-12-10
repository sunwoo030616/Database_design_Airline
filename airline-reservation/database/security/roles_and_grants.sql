USE airline;

-- ROLE 생성 (MySQL 8 이상 지원)
CREATE ROLE IF NOT EXISTS role_admin;
CREATE ROLE IF NOT EXISTS role_staff;
CREATE ROLE IF NOT EXISTS role_auditor;
CREATE ROLE IF NOT EXISTS role_analytics_reader;

-- 관리자: 모든 권한
GRANT ALL PRIVILEGES ON airline.* TO role_admin;

-- 스태프: 조회 + 예약/결제 INSERT/UPDATE
GRANT SELECT ON airline.* TO role_staff;
GRANT INSERT, UPDATE ON airline.Reservation TO role_staff;
GRANT INSERT, UPDATE ON airline.Payment     TO role_staff;

-- 감사(Auditor): SELECT만
GRANT SELECT ON airline.* TO role_auditor;

-- Analytics Reader: 최소 권한으로 매출 통계에 필요한 테이블만 조회
GRANT SELECT ON airline.Payment     TO role_analytics_reader;
GRANT SELECT ON airline.Reservation TO role_analytics_reader;
GRANT SELECT ON airline.Flight      TO role_analytics_reader;
GRANT SELECT ON airline.Route       TO role_analytics_reader;
GRANT SELECT ON airline.Airport     TO role_analytics_reader;

-- 실제 사용자에게 ROLE 부여 예시
-- (MySQL 사용자 sunwoo, teammate 가 이미 있다고 가정)
GRANT role_admin  TO 'sunwoo'@'localhost';
GRANT role_staff  TO 'teammate'@'localhost';
-- 관리자 계정만 analytics 접근 권한을 갖도록
GRANT role_analytics_reader TO 'sunwoo'@'localhost';

-- ROLE 활성화 예시
SET ROLE role_staff;
-- 필요 시
-- SET ROLE role_analytics_reader;
