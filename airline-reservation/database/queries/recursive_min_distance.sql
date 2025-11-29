WITH RECURSIVE min_dist_path AS (
    SELECT
        route_id,
        origin,
        destination,
        distance,
        base_duration,
        -- 수정 1: route_path_str 길이 명시 (이전 단계에서 수정됨)
        CAST(CONCAT(origin,' -> ',destination) AS CHAR(1000)) AS route_path_str,
        1 AS depth,
        distance AS total_dist,
        -- **수정 2: visited 길이 명시**
        CAST(CONCAT(origin,',',destination) AS CHAR(500)) AS visited
    FROM Route
    WHERE origin = 'ICN'

    UNION ALL

    SELECT
        r.route_id,
        p.origin,
        r.destination,
        r.distance,
        r.base_duration,
        CONCAT(p.route_path_str,' -> ',r.destination),
        p.depth + 1,
        p.total_dist + r.distance,
        CONCAT(p.visited,',',r.destination)
    FROM Route r
    JOIN min_dist_path p ON r.origin = p.destination
    WHERE FIND_IN_SET(r.destination, p.visited) = 0
      AND p.total_dist + r.distance < 50000
)
SELECT *
FROM min_dist_path
WHERE destination = 'LAX'
ORDER BY total_dist ASC
LIMIT 1;