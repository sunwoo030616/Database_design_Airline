from django.contrib import admin
from .models import Flight


@admin.register(Flight)
class FlightAdmin(admin.ModelAdmin):
	list_display = ('flight_id', 'route', 'aircraft', 'base_fare', 'current_fare', 'departure_time', 'arrival_time', 'status')
	list_filter = ('status', 'route', 'aircraft')
	search_fields = ('flight_id', 'route__route_id', 'aircraft__aircraft_id')
