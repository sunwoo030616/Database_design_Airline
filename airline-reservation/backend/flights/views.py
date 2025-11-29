from django.shortcuts import render

# Create your views here.
from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status
from django.utils import timezone
from .models import Flight, Seat
from .serializers import FlightSerializer


@api_view(['GET'])
def flight_list(request):
    """
    GET /api/flights/?origin=ICN&destination=LAX&date=2025-12-01
    """
    qs = Flight.objects.select_related('route__origin', 'route__destination')

    origin = request.GET.get('origin')
    dest = request.GET.get('destination')
    date = request.GET.get('date')  # YYYY-MM-DD

    if origin:
        qs = qs.filter(route__origin__airport_code=origin)
    if dest:
        qs = qs.filter(route__destination__airport_code=dest)
    if date:
        qs = qs.filter(departure_time__date=date)

    serializer = FlightSerializer(qs, many=True)
    return Response(serializer.data, status=status.HTTP_200_OK)

from django.db import connection

@api_view(['GET'])
def flight_seat_info(request, flight_id):
    """
    특정 항공편의 좌석 리스트 + 항공편 정보 반환
    GET /api/flights/<flight_id>/seats/
    """
    try:
        flight = Flight.objects.select_related(
            'route__origin',
            'route__destination',
            'aircraft'
        ).get(flight_id=flight_id)
    except Flight.DoesNotExist:
        return Response({"detail": "존재하지 않는 항공편"}, status=404)

    # 이 항공편의 항공기
    aircraft_id = flight.aircraft.aircraft_id

    # 좌석 불러오기
    seats = Seat.objects.filter(aircraft_id=aircraft_id).values('seat_no', 'status')

    flight_data = FlightSerializer(flight).data

    return Response({
        "flight": flight_data,
        "seats": list(seats)
    })

@api_view(['GET'])
def min_distance_route(request):
    origin = request.GET.get("origin")
    destination = request.GET.get("destination")

    if not origin or not destination:
        return Response({"detail": "origin, destination 필요함"}, status=400)

    with connection.cursor() as cursor:
        cursor.execute("""
            WITH RECURSIVE min_dist_path AS (
                SELECT
                    route_id,
                    origin,
                    destination,
                    distance,
                    base_duration,
                    CAST(CONCAT(origin,' -> ',destination) AS CHAR(1000)) AS route_path_str,
                    1 AS depth,
                    distance AS total_dist,
                    CAST(CONCAT(origin,',',destination) AS CHAR(1000)) AS visited
                FROM Route
                WHERE origin = %s

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
            SELECT route_path_str, total_dist, depth
            FROM min_dist_path
            WHERE destination = %s
            ORDER BY total_dist ASC
            LIMIT 1;
        """, [origin, destination])

        row = cursor.fetchone()

    if row is None:
        return Response({"detail": "경로 없음"})

    return Response({
        "path": row[0],
        "total_distance": row[1],
        "stops": row[2]
    })
