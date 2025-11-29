USE airline;

-- 노선(route) / 월(month) / 좌석 등급(seat_class)별 매출 + 소계
SELECT
    r.route_id,
    DATE_FORMAT(p.pay_time, '%Y-%m-01') AS month,
    s.seat_class,
    SUM(p.amount) AS total_revenue
FROM Payment p
JOIN Reservation res ON p.resv_id = res.resv_id
JOIN Flight f       ON res.flight_id = f.flight_id
JOIN Route r        ON f.route_id = r.route_id
JOIN Aircraft a     ON f.aircraft_id = a.aircraft_id
JOIN Seat s         ON a.aircraft_id = s.aircraft_id
                    AND s.seat_no = res.seat_no
GROUP BY
    r.route_id,
    DATE_FORMAT(p.pay_time, '%Y-%m-01'),
    s.seat_class
WITH ROLLUP;
