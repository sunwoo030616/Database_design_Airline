from rest_framework import serializers
from .models import DynamicFareLog, RevenueAnalysis
from flights.models import Flight, Route, Airport


class FlightBriefSerializer(serializers.ModelSerializer):
    class Meta:
        model = Flight
        fields = ['flight_id']


class DynamicFareLogSerializer(serializers.ModelSerializer):
    # Nest minimal flight info so frontend can access log.flight.flight_id
    flight = FlightBriefSerializer(read_only=True)

    class Meta:
        model = DynamicFareLog
        fields = ['log_id', 'flight', 'resv', 'old_fare', 'new_fare', 'changed_at', 'event_type']


class RevenueAnalysisSerializer(serializers.ModelSerializer):
    class Meta:
        model = RevenueAnalysis
        fields = '__all__'
