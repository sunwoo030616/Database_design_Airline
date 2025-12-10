from django.contrib import admin
from .models import DynamicFareLog, RevenueAnalysis


@admin.register(DynamicFareLog)
class DynamicFareLogAdmin(admin.ModelAdmin):
	list_display = ('log_id', 'flight', 'old_fare', 'new_fare', 'changed_at', 'event_type')
	list_filter = ('flight', 'changed_at', 'event_type')
	search_fields = ('flight__flight_id',)


@admin.register(RevenueAnalysis)
class RevenueAnalysisAdmin(admin.ModelAdmin):
	list_display = ('analysis_id', 'route', 'aircraft', 'month', 'seat_class', 'total_revenue')
	list_filter = ('route', 'aircraft', 'month', 'seat_class')
	search_fields = ('route__route_id', 'aircraft__aircraft_id')
