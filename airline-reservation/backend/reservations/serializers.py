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
    flight_id = serializers.IntegerField()
    seat_no = serializers.CharField(max_length=10)
    payment_method = serializers.CharField(max_length=20, required=False, allow_blank=True)
    member_id = serializers.IntegerField(required=True)

    def validate(self, attrs):
        # payment_method 기본값 설정
        if not attrs.get('payment_method'):
            attrs['payment_method'] = 'CARD'
        return attrs
