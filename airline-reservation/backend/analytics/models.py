
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
    analysis_id = models.AutoField(primary_key=True, db_column='analysis_id')
    route = models.ForeignKey('flights.Route', db_column='route_id', on_delete=models.PROTECT)
    aircraft = models.ForeignKey('flights.Aircraft', db_column='aircraft_id', on_delete=models.PROTECT)
    month = models.DateField()
    seat_class = models.CharField(max_length=20)
    total_revenue = models.DecimalField(max_digits=12, decimal_places=2)

    class Meta:
        managed = False
        db_table = 'RevenueAnalysis'
