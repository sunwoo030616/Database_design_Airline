from rest_framework import serializers
from .models import Flight, Airport, Route


class AirportSerializer(serializers.ModelSerializer):
    class Meta:
        model = Airport
        fields = ['airport_code', 'airport_name', 'city', 'country']


class RouteSerializer(serializers.ModelSerializer):
    origin = AirportSerializer()
    destination = AirportSerializer()

    class Meta:
        model = Route
        fields = ['route_id', 'origin', 'destination', 'distance', 'base_duration']


class FlightSerializer(serializers.ModelSerializer):
    route = RouteSerializer()

    class Meta:
        model = Flight
        fields = [
            'flight_id', 'route', 'aircraft',
            'departure_time', 'arrival_time',
            'base_fare', 'current_fare', 'status'
        ]
