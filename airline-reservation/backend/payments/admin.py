from django.contrib import admin
from .models import Payment


@admin.register(Payment)
class PaymentAdmin(admin.ModelAdmin):
	list_display = ('payment_id', 'reservation', 'amount', 'method', 'status', 'paid_at')
	list_filter = ('status', 'method')
	search_fields = ('payment_id', 'reservation__resv_id')
