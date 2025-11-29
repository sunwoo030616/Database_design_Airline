from django.db import models

# Create your models here.
from django.db import models
from reservations.models import Reservation


class Payment(models.Model):
    payment_id = models.AutoField(primary_key=True)
    reservation = models.OneToOneField(Reservation, on_delete=models.CASCADE)
    amount = models.DecimalField(max_digits=10, decimal_places=2)
    method = models.CharField(max_length=20)  # CARD / POINT / MIXED 등
    status = models.CharField(max_length=20)  # PAID / FAILED / REFUNDED
    paid_at = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'Payment'
