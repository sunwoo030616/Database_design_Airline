from django.contrib import admin
from .models import Reservation


@admin.register(Reservation)
class ReservationAdmin(admin.ModelAdmin):
	list_display = ('resv_id', 'flight', 'user', 'seat_no', 'reserved_at', 'status')
	list_filter = ('status', 'flight')
	search_fields = ('resv_id', 'user__email', 'seat_no', 'flight__flight_id')
