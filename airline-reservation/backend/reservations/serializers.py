from rest_framework import serializers
from .models import Reservation
from flights.serializers import FlightSerializer


class ReservationSerializer(serializers.ModelSerializer):
    flight = FlightSerializer()

    class Meta:
        model = Reservation
        fields = [
            'resv_id', 'flight',
            'seat_no', 'status', 'reserved_at'
]



class ReservationCreateSerializer(serializers.Serializer):
    member_id = serializers.IntegerField()
    flight_id = serializers.IntegerField()
    seat_no = serializers.CharField(max_length=10)
    payment_method = serializers.CharField(max_length=20)
    # 필요한 값 더 있으면 추가 (예: 사용 마일리지 등)
