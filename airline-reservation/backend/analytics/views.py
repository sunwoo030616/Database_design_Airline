from rest_framework.decorators import api_view, permission_classes, authentication_classes
from rest_framework.response import Response
from .models import DynamicFareLog, RevenueAnalysis
from .serializers import DynamicFareLogSerializer, RevenueAnalysisSerializer
from django.db import connection
from members.auth import JWTAuthentication
from members.permissions import IsAdminUserType
from rest_framework.permissions import AllowAny


@api_view(['GET'])
# TEMP: Allow public access during development to avoid JWT expiry issues
@permission_classes([AllowAny])
@authentication_classes([])
def fare_log_list(request):
    """
    GET /api/admin/fare-log/?flight_id=123
    """
    qs = DynamicFareLog.objects.select_related('flight').order_by('-changed_at')
    flight_id = request.GET.get('flight_id')
    if flight_id:
        qs = qs.filter(flight_id=flight_id)

    serializer = DynamicFareLogSerializer(qs, many=True)
    return Response(serializer.data)


@api_view(['GET'])
@authentication_classes([JWTAuthentication])
@permission_classes([IsAdminUserType])
def revenue_analysis_list(request):
    """
    GET /api/admin/revenue/?route_id=1&from=2025-11-01&to=2025-11-30
    """
    qs = RevenueAnalysis.objects.all()
    route_id = request.GET.get('route_id')
    from_date = request.GET.get('from')
    to_date = request.GET.get('to')

    if route_id:
        qs = qs.filter(route_id=route_id)
    if from_date:
        qs = qs.filter(flight_date__gte=from_date)
    if to_date:
        qs = qs.filter(flight_date__lte=to_date)

    serializer = RevenueAnalysisSerializer(qs, many=True)
    return Response(serializer.data)


@api_view(['GET'])
@permission_classes([AllowAny])
def routes_path_distance(request):
    """
    GET /api/admin/routes/path?origin=ICN&destination=LAX&max_hops=6&max_results=3
    Returns top-N shortest paths by total distance using recursive CTE over Route table.
    - Avoids cycles by checking route_str containment
    - Supports limiting hops and number of returned paths
    """
    origin = request.GET.get('origin')
    destination = request.GET.get('destination')
    try:
        max_hops = int(request.GET.get('max_hops', '6'))
        # 요청이 크더라도 최대 경유 횟수(경유지 수)는 2로 제한
        if max_hops > 2:
            max_hops = 2
        # 내부 CTE의 hops는 '구간 수(엣지 수)'이므로 경유지 수 + 1로 변환
        effective_hops_limit = max_hops + 1
        max_results = int(request.GET.get('max_results', '3'))
    except ValueError:
        return Response({'detail': 'max_hops, max_results는 정수여야 합니다.'}, status=400)

    if not origin or not destination:
        return Response({'detail': 'origin, destination 파라미터가 필요합니다.'}, status=400)

    sql = f"""
        WITH RECURSIVE path AS (
            SELECT
                r.origin,
                r.destination,
                r.distance,
                CAST(r.origin AS CHAR(1000)) AS route_str,
                CAST(r.origin AS CHAR(10)) AS last_node,
                0 AS hops,
                CAST(r.origin AS CHAR(1000)) AS visited
            FROM Route r
            WHERE r.origin = %s

            UNION ALL
            SELECT
                p.origin,
                r2.destination,
                p.distance + r2.distance,
                CONCAT(p.route_str, ' -> ', r2.destination) AS route_str,
                r2.destination AS last_node,
                p.hops + 1 AS hops,
                CONCAT(p.visited, ',', r2.destination) AS visited
            FROM path p
            JOIN Route r2 ON r2.origin = p.last_node
            WHERE p.hops < {effective_hops_limit}
                AND FIND_IN_SET(r2.destination, p.visited) = 0
        )
        SELECT origin, destination, distance, route_str, hops
        FROM path
        WHERE destination = %s
        ORDER BY distance ASC, hops ASC;
    """

    paths = []
    with connection.cursor() as cur:
        cur.execute(sql, [origin, destination])
        rows = cur.fetchall()

    # 중복 경로 제거: 노드 시퀀스 기준 유니크 처리 (공백/대소문자 정규화)
    seen_keys = set()
    unique_rows = []
    for origin_res, dest_res, total_distance, route_str, hops in rows:
        nodes_norm = [n.strip().upper() for n in route_str.split('->')]
        if nodes_norm[-1] != dest_res:
            nodes_norm.append(str(dest_res).strip().upper())
        key = '->'.join(nodes_norm)
        if key in seen_keys:
            continue
        seen_keys.add(key)
        unique_rows.append((origin_res, dest_res, total_distance, ' -> '.join([n.strip() for n in route_str.split('->')]), hops))

    # 선택적 필터: 경유지 있는 경로만 반환 (직항 제외)
    only_layovers = request.GET.get('only_layovers', 'false').lower() in ('true', '1', 'yes')
    if only_layovers:
        unique_rows = [row for row in unique_rows if (row[4] or 0) > 0]

    if not rows:
        return Response({'detail': '경로가 없습니다.'}, status=404)

    # Build detailed steps for each path
    with connection.cursor() as cur:
        for origin_res, dest_res, total_distance, route_str, hops in unique_rows:
            nodes = route_str.split(' -> ')
            if nodes[-1] != dest_res:
                nodes.append(dest_res)
            steps = []
            total_distance_sum = 0.0
            for i in range(len(nodes) - 1):
                frm = nodes[i]
                to = nodes[i+1]
                cur.execute("SELECT distance FROM Route WHERE origin=%s AND destination=%s LIMIT 1", [frm, to])
                drow = cur.fetchone()
                seg_distance = float(drow[0]) if drow and drow[0] is not None else None
                steps.append({'origin': frm, 'destination': to, 'distance': seg_distance})
                if seg_distance is not None:
                    total_distance_sum += seg_distance
            # Layovers and hops normalization
            layovers = nodes[1:-1] if len(nodes) > 2 else []
            norm_hops = len(nodes) - 2
            # Prefer recomputed total when available
            total_out = float(total_distance_sum) if total_distance_sum > 0 else (float(total_distance) if total_distance is not None else None)
            paths.append({
                'origin': origin_res,
                'destination': dest_res,
                'total_distance': total_out,
                'hops': norm_hops,
                'nodes': nodes,
                'layovers': layovers,
                'steps': steps,
            })
    # 결과를 정렬하고 요청된 max_results로 자르기
    paths.sort(key=lambda x: (x['total_distance'] if x['total_distance'] is not None else float('inf'), x['hops']))
    paths = paths[:max_results]
    return Response({'count': len(paths), 'paths': paths})


@api_view(['GET'])
# TEMP: Allow public access during development to avoid JWT expiry issues
@permission_classes([AllowAny])
@authentication_classes([])
def revenue_rollup(request):
    """
    GET /api/admin/revenue/rollup?from=2025-11-01&to=2025-11-30

    Returns revenue aggregated with ROLLUP across
    (origin, destination, month), (origin, destination), (origin), ()
    """
    from_date = request.GET.get('from')
    to_date = request.GET.get('to')

    # SQL 쿼리: ROLLUP 사용
    sql = """
        SELECT
          o.airport_code AS origin,
          d.airport_code AS destination,
          DATE_FORMAT(f.departure_time, '%%Y-%%m') AS month,
          SUM(p.amount) AS revenue
        FROM Payment p
        JOIN Reservation r ON r.resv_id = p.resv_id          -- <<< 컬럼 이름(resv_id) 반영
        JOIN Flight f ON f.flight_id = r.flight_id
        JOIN Route rt ON rt.route_id = f.route_id
        JOIN Airport o ON o.airport_code = rt.origin         -- <<< 컬럼 이름(rt.origin) 반영
        JOIN Airport d ON d.airport_code = rt.destination    -- <<< 컬럼 이름(rt.destination) 반영
        WHERE p.status = 'SUCCESS'
          {from_clause}
          {to_clause}
        GROUP BY origin, destination, month WITH ROLLUP;
    """

    params = []
    from_clause = ''
    to_clause = ''
    if from_date:
        from_clause = 'AND DATE(f.departure_time) >= %s'
        params.append(from_date)
    if to_date:
        to_clause = 'AND DATE(f.departure_time) <= %s'
        params.append(to_date)

    sql = sql.format(from_clause=from_clause, to_clause=to_clause)

    with connection.cursor() as cur:
        try:
            cur.execute(sql, params)
            rows = cur.fetchall()
        except Exception as e:
            # 오류 발생 시 디버깅을 위한 응답을 반환
            return Response({'detail': 'revenue_rollup 쿼리 오류', 'error': str(e), 'sql': sql, 'params': params}, status=500)

    # ROLLUP의 NULL 값을 'ALL'로 변환
    data = []
    for origin, destination, month, revenue in rows:
        data.append({
            'origin': origin if origin is not None else 'ALL',
            'destination': destination if destination is not None else ('ALL' if origin is not None else None),
            'month': month if month is not None else 'ALL',
            'revenue': float(revenue) if revenue is not None else 0.0,
        })

    return Response(data)


@api_view(['GET'])
# TEMP: Allow public access during development to avoid JWT expiry issues
@permission_classes([AllowAny])
@authentication_classes([])
def revenue_cube(request):
    """
    GET /api/admin/revenue/cube?from=2025-11-01&to=2025-11-30

    Emulates cube via UNION ALL across origin, destination, month.
    """
    from_date = request.GET.get('from')
    to_date = request.GET.get('to')

    params = []
    from_clause = ''
    to_clause = ''
    if from_date:
        from_clause = 'AND DATE(f.departure_time) >= %s'
        params.append(from_date)
    if to_date:
        to_clause = 'AND DATE(f.departure_time) <= %s'
        params.append(to_date)

    # 큐브를 위한 UNION ALL 쿼리 (8개의 집계 레벨)
    base_select = """
        SELECT
            {origin_expr} AS origin,
            {dest_expr} AS destination,
            {month_expr} AS month,
            SUM(p.amount) AS revenue
        FROM Payment p
        JOIN Reservation r ON r.resv_id = p.resv_id
        JOIN Flight f ON f.flight_id = r.flight_id
        JOIN Route rt ON rt.route_id = f.route_id
        JOIN Airport o ON o.airport_code = rt.origin
        JOIN Airport d ON d.airport_code = rt.destination
        WHERE p.status = 'SUCCESS'
            {{from_clause}}
            {{to_clause}}
        GROUP BY {group_by}
    """

    queries = [
        # 1. (origin, destination, month)
        base_select.format(
            origin_expr='o.airport_code', dest_expr='d.airport_code', month_expr="DATE_FORMAT(f.departure_time, '%%Y-%%m')",
            group_by='origin, destination, month'
        ),
        # 2. (origin, destination)
        base_select.format(
            origin_expr='o.airport_code', dest_expr='d.airport_code', month_expr='NULL',
            group_by='origin, destination'
        ),
        # 3. (origin, month)
        base_select.format(
            origin_expr='o.airport_code', dest_expr='NULL', month_expr="DATE_FORMAT(f.departure_time, '%%Y-%%m')",
            group_by='origin, month'
        ),
        # 4. (destination, month)
        base_select.format(
            origin_expr='NULL', dest_expr='d.airport_code', month_expr="DATE_FORMAT(f.departure_time, '%%Y-%%m')",
            group_by='destination, month'
        ),
        # 5. (origin)
        base_select.format(
            origin_expr='o.airport_code', dest_expr='NULL', month_expr='NULL',
            group_by='origin'
        ),
        # 6. (destination)
        base_select.format(
            origin_expr='NULL', dest_expr='d.airport_code', month_expr='NULL',
            group_by='destination'
        ),
        # 7. (month)
        base_select.format(
            origin_expr='NULL', dest_expr='NULL', month_expr="DATE_FORMAT(f.departure_time, '%%Y-%%m')",
            group_by='month'
        ),
        # 8. () - Grand Total
        base_select.format(
            origin_expr='NULL', dest_expr='NULL', month_expr='NULL',
            group_by=''
        ).replace('GROUP BY ', '') # 마지막 쿼리는 GROUP BY 절을 제거해야 함
    ]

    # 모든 쿼리를 UNION ALL로 연결
    sql = ('\nUNION ALL\n').join(queries)

    # 날짜 필터링 변수를 SQL에 포맷팅
    sql = sql.format(from_clause=from_clause, to_clause=to_clause)

    with connection.cursor() as cur:
        try:
            cur.execute(sql, params)
            rows = cur.fetchall()
        except Exception as e:
            # 오류 발생 시 디버깅을 위한 응답을 반환
            return Response({'detail': 'revenue_cube 쿼리 오류', 'error': str(e), 'sql': sql, 'params': params}, status=500)

    # NULL 값을 'ALL'로 변환
    data = []
    for origin, destination, month, revenue in rows:
        data.append({
            'origin': origin if origin is not None else 'ALL',
            'destination': destination if destination is not None else 'ALL',
            'month': month if month is not None else 'ALL',
            'revenue': float(revenue) if revenue is not None else 0.0,
        })

    return Response(data)