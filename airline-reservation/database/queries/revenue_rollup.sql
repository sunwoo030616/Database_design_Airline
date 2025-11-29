-- 등급 × 노선 × 월별 매출 분석 (ROLLUP)
SELECT
    c.grade,
    r.route_id,
    DATE_FORMAT(p.pay_time, '%Y-%m-01') AS month,
    SUM(p.amount) AS total_revenue
FROM Payment p
JOIN Reservation res ON p.resv_id = res.resv_id
JOIN Flight f       ON res.flight_id = f.flight_id
JOIN Route r        ON f.route_id = r.route_id
JOIN Member m       ON res.user_id = m.user_id
JOIN Customer c     ON m.user_id = c.user_id
GROUP BY
    c.grade,
    r.route_id,
    DATE_FORMAT(p.pay_time, '%Y-%m-01')
WITH ROLLUP;

-- 출발 시간(HOUR)별 예약 수요
SELECT
    HOUR(f.departure_time) AS dep_hour,
    COUNT(DISTINCT res.resv_id) AS reservation_count
FROM Reservation res
JOIN Flight f ON res.flight_id = f.flight_id
GROUP BY dep_hour
ORDER BY dep_hour;

-- 항공편별 비행시간
SELECT
    flight_id,
    route_id,
    TIMESTAMPDIFF(MINUTE, departure_time, arrival_time) AS duration_min
FROM Flight;
