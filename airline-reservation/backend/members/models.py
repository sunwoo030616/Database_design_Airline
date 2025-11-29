from django.db import models


class Member(models.Model):
    user_id = models.AutoField(primary_key=True)
    name = models.CharField(max_length=50)
    email = models.CharField(max_length=100, unique=True)
    password = models.CharField(max_length=255)
    phone_num = models.CharField(max_length=20, null=True, blank=True)
    user_type = models.CharField(max_length=20)  # 'customer' or 'admin'

    class Meta:
        managed = False      # 기존 MySQL 테이블 사용
        db_table = 'Member'  # 실제 테이블명에 맞춰 수정

    def __str__(self):
        return f'{self.name}({self.email})'


class Customer(models.Model):
    user = models.OneToOneField(Member, on_delete=models.CASCADE, primary_key=True)
    mileage = models.IntegerField(default=0)
    grade = models.CharField(max_length=20, default='Bronze')

    class Meta:
        managed = False
        db_table = 'Customer'


class Admin(models.Model):
    user = models.OneToOneField(Member, on_delete=models.CASCADE, primary_key=True)
    role = models.IntegerField()

    class Meta:
        managed = False
        db_table = 'Admin'
