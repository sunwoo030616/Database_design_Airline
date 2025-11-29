from django.db import models

# Create your models here.
from django.db import models


class Airport(models.Model):
    airport_code = models.CharField(primary_key=True, max_length=3)
    airport_name = models.CharField(max_length=100)
    city = models.CharField(max_length=50)
    country = models.CharField(max_length=50)

    class Meta:
        managed = False
        db_table = 'Airport'


class Route(models.Model):
    route_id = models.AutoField(primary_key=True, db_column='route_id')
    origin = models.ForeignKey(Airport, db_column='origin', on_delete=models.PROTECT, related_name='routes_origin')
    destination = models.ForeignKey(Airport, db_column='destination', on_delete=models.PROTECT, related_name='routes_destination')
    distance = models.IntegerField()
    base_duration = models.IntegerField()

    class Meta:
        managed = False
        db_table = 'Route'



class Aircraft(models.Model):
    aircraft_id = models.CharField(primary_key=True, max_length=10)
    model = models.CharField(max_length=50)
    manufacturer = models.CharField(max_length=50)
    capacity = models.IntegerField()

    class Meta:
        managed = False
        db_table = 'Aircraft'


class Seat(models.Model):
    aircraft = models.ForeignKey(Aircraft, on_delete=models.CASCADE)
    seat_no = models.CharField(max_length=10)
    seat_class = models.CharField(max_length=20)  # 'ECONOMY' / 'BUSINESS' 등
    status = models.CharField(max_length=20, default='AVAILABLE')

    class Meta:
        managed = False
        db_table = 'Seat'
        unique_together = ('aircraft', 'seat_no')


class Flight(models.Model):
    flight_id = models.AutoField(primary_key=True, db_column='flight_id')
    route = models.ForeignKey(Route, db_column='route_id', on_delete=models.PROTECT)
    aircraft = models.ForeignKey(Aircraft, db_column='aircraft_id', on_delete=models.PROTECT)
    departure_time = models.DateTimeField()
    arrival_time = models.DateTimeField()
    base_fare = models.DecimalField(max_digits=10, decimal_places=2)
    current_fare = models.DecimalField(max_digits=10, decimal_places=2)
    status = models.CharField(max_length=20)  # SCHEDULED / DEPARTED / ARRIVED ...

    class Meta:
        managed = False
        db_table = 'Flight'
