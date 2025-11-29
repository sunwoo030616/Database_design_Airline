
# Create your models here.
from django.db import models
from flights.models import Flight


class DynamicFareLog(models.Model):
    log_id = models.AutoField(primary_key=True)
    flight = models.ForeignKey(
        'flights.Flight',
        on_delete=models.CASCADE,
        db_column='flight_id'
    )
    resv = models.ForeignKey(
        'reservations.Reservation',
        on_delete=models.SET_NULL,
        null=True,
        db_column='resv_id'
    )
    old_fare = models.DecimalField(max_digits=10, decimal_places=2)
    new_fare = models.DecimalField(max_digits=10, decimal_places=2)
    
    # DB에는 changed_at이 없고 change_time이 있음
    changed_at = models.DateTimeField(db_column='change_time')

    # DB에는 event_type 대신 trigger_event가 있음
    event_type = models.CharField(max_length=100, db_column='trigger_event')

    class Meta:
        managed = False
        db_table = 'DynamicFareLog'


class RevenueAnalysis(models.Model):
    # 실제 스키마에 맞게 필드 수정
    id = models.AutoField(primary_key=True)
    route = models.ForeignKey('flights.Route', on_delete=models.PROTECT)
    flight_date = models.DateField()
    total_revenue = models.DecimalField(max_digits=12, decimal_places=2)
    total_seats = models.IntegerField()
    sold_seats = models.IntegerField()

    class Meta:
        managed = False
        db_table = 'RevenueAnalysis'
