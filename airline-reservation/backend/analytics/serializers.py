from rest_framework import serializers
from .models import DynamicFareLog, RevenueAnalysis


class DynamicFareLogSerializer(serializers.ModelSerializer):
    class Meta:
        model = DynamicFareLog
        fields = '__all__'


class RevenueAnalysisSerializer(serializers.ModelSerializer):
    class Meta:
        model = RevenueAnalysis
        fields = '__all__'
