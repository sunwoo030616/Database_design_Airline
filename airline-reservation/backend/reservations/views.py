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

    # ★ (2) 좌석 중복 체크는 엄격 프로시저에서 좌석 상태(Seat.status)로 판별
    # 프리체크를 제거하여 Seat가 AVAILABLE인 케이스에서 잘못된 차단을 방지합니다.

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
        # Surface meaningful DB error details to the client
        err_detail = None
        try:
            # Django wraps DB exceptions; for MySQLdb, e.args may contain (code, msg)
            if hasattr(e, 'args') and e.args:
                if isinstance(e.args[0], tuple):
                    err_detail = e.args[0][1]
                elif isinstance(e.args[0], int) and len(e.args) > 1:
                    err_detail = e.args[1]
        except Exception:
            pass

        msg = err_detail or str(e) or '예약 또는 결제 처리 중 오류'
        print("🔥 DB ERROR:", msg)
        return Response({'detail': msg}, status=400)


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

    # 취소 처리와 함께 좌석 복구 및 운임 재계산 수행
    try:
        with transaction.atomic():
            # 1) 예약 상태 취소
            reservation.status = 'CANCELLED'
            reservation.save(update_fields=['status'])

            # 2) 좌석 상태 AVAILABLE로 복구 (트리거가 없다면 안전하게 복구)
            from flights.models import Flight
            flight_id = reservation.flight_id
            seat_no = reservation.seat_no

            with connection.cursor() as cursor:
                cursor.execute(
                    "UPDATE Seat SET status='AVAILABLE' WHERE seat_no=%s AND aircraft_id=(SELECT aircraft_id FROM Flight WHERE flight_id=%s)",
                    [seat_no, flight_id]
                )

                # 3) 운임 재계산 프로시저 호출
                try:
                    cursor.callproc('sp_recalculate_fare', [flight_id])
                except Exception:
                    # 일부 환경에서 프로시저가 없을 수 있으므로 조용히 통과
                    pass

        return Response({'detail': '예약 취소 완료'}, status=200)
    except Exception as e:
        print("🔥 CANCEL ERROR:", e)
        return Response({'detail': '취소 중 오류: ' + str(e)}, status=400)
