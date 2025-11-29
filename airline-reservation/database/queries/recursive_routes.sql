USE airline;

-- 출발지(ICN)에서 도착지(LAX)까지 가능한 경로 탐색 (최대 4구간 예시)
WITH RECURSIVE route_path AS (
    -- anchor: 출발지에서 바로 가는 직항
    SELECT
        origin,
        destination,
        CONCAT(origin, ' -> ', destination) AS path,
        1 AS depth
    FROM Route
    WHERE origin = 'ICN'

    UNION ALL

    -- recursive: 직항의 도착지를 다시 origin으로 사용
    SELECT
        r.origin,
        r.destination,
        CONCAT(rp.path, ' -> ', r.destination) AS path,
        rp.depth + 1
    FROM Route r
    JOIN route_path rp
      ON r.origin = rp.destination
    WHERE rp.depth < 4   -- 최대 4구간 제한
)
SELECT *
FROM route_path
WHERE destination = 'LAX';
