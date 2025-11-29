from django.db import models
from members.models import Member
from flights.models import Flight, Seat


class Reservation(models.Model):
    resv_id = models.AutoField(primary_key=True)   # ★ PK명 변경
    flight = models.ForeignKey('flights.Flight', on_delete=models.CASCADE)
    seat_no = models.CharField(max_length=10)
    user = models.ForeignKey('members.Member', on_delete=models.CASCADE)
    status = models.CharField(max_length=20)
    reserved_at = models.DateTimeField(db_column='resv_time')
    
    class Meta:
        managed = False
        db_table = 'Reservation'
        # (aircraft, seat_no, flight) 조합 unique라면 unique_together 추가 가능
