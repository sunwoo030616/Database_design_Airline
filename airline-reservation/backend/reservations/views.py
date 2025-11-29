from django.shortcuts import render

# Create your views here.
from django.db import connection, transaction
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework import status
from .serializers import ReservationCreateSerializer, ReservationSerializer
from .models import Reservation

@api_view(['POST'])
def create_reservation(request):
    serializer = ReservationCreateSerializer(data=request.data)
    serializer.is_valid(raise_exception=True)
    data = serializer.validated_data

    member_id = data["member_id"]
    flight_id = data['flight_id']
    seat_no = data['seat_no']
    payment_method = data['payment_method']

    # ★ (1) 금액 계산
    from flights.models import Flight
    flight = Flight.objects.get(pk=flight_id)
    amount = flight.current_fare

    # ★ (2) 좌석 중복 체크 — 여기 넣으면 됨!!
    if Reservation.objects.filter(
        flight_id=flight_id,
        seat_no=seat_no,
        status='BOOKED'
    ).exists():
        return Response(
            {'detail': '이미 예약된 좌석입니다.'},
            status=400
        )

    try:
        with transaction.atomic():
            with connection.cursor() as cursor:

                # ★ (3) SP 호출
                cursor.callproc(
                    'sp_create_reservation_with_payment_strict',
                    [flight_id, member_id, seat_no, amount, payment_method]
                )

                # ★ (4) 방금 생성된 예약 ID 가져오기
                cursor.execute("SELECT LAST_INSERT_ID()")
                reservation_id = cursor.fetchone()[0]

        reservation = Reservation.objects.select_related(
            'flight__route__origin',
            'flight__route__destination'
        ).get(resv_id=reservation_id)

        return Response(
            ReservationSerializer(reservation).data,
            status=201
        )

    except Exception as e:
        print("🔥 DB ERROR:", e)
        return Response({'detail': str(e)}, status=400)


from .serializers import ReservationSerializer
from .models import Reservation
from django.utils import timezone


@api_view(['GET'])
def my_reservations(request):
    member_id = request.query_params.get("member_id")
    if not member_id:
        return Response({"detail": "member_id 필요함"}, status=400)

    qs = (
        Reservation.objects
        .select_related('flight__route__origin', 'flight__route__destination')
        .filter(user__user_id=member_id)
        .order_by('-reserved_at')
    )

    serializer = ReservationSerializer(qs, many=True)
    return Response(serializer.data)



@api_view(['POST'])
def cancel_reservation(request, reservation_id):
    member_id = request.data.get("member_id")

    try:
        reservation = Reservation.objects.get(pk=reservation_id)
    except Reservation.DoesNotExist:
        return Response({'detail': '없는 예약입니다.'}, status=404)

    if reservation.user_id != int(member_id):
        return Response({'detail': '본인 예약만 취소 가능'}, status=403)

    if reservation.status == 'CANCELLED':
        return Response({'detail': '이미 취소됨'}, status=400)

    reservation.status = 'CANCELLED'
    reservation.save(update_fields=['status'])
    return Response({'detail': '예약 취소 완료'}, status=200)
