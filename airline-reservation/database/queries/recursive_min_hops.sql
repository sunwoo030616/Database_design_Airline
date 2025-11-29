-- 최소 경유 횟수 경로 찾기 (수정 완료)
WITH RECURSIVE route_paths AS (
    SELECT
        route_id,
        origin,
        destination,
        distance,
        base_duration,
        -- **수정 1: path 컬럼에 VARCHAR(1000)으로 길이 명시**
        CAST(CONCAT(origin,' -> ',destination) AS CHAR(1000)) AS path,
        1 AS depth,
        -- **수정 2: visited 컬럼에 VARCHAR(1000)으로 길이 명시**
        CAST(CONCAT(origin,',',destination) AS CHAR(1000)) AS visited
    FROM Route
    WHERE origin = 'ICN'

    UNION ALL

    SELECT
        r.route_id,
        rp.origin,
        r.destination,
        r.distance,
        r.base_duration,
        CONCAT(rp.path,' -> ',r.destination),
        rp.depth + 1,
        CONCAT(rp.visited,',',r.destination)
    FROM Route r
    JOIN route_paths rp ON r.origin = rp.destination
    -- 이미 방문한 공항을 다시 방문하지 않도록 방지
    WHERE FIND_IN_SET(r.destination, rp.visited) = 0
      -- 무한 루프 방지 및 효율성 제고를 위한 최대 경유 횟수 제한 (5개)
      AND rp.depth < 5
)
SELECT *
FROM route_paths
WHERE destination = 'LAX'
ORDER BY depth ASC
LIMIT 1;