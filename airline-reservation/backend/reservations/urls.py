from django.urls import path
from . import views

urlpatterns = [
    path('', views.create_reservation, name='create_reservation'),
    path('my/', views.my_reservations, name='my_reservations'),
    path('<int:reservation_id>/cancel/', views.cancel_reservation, name='cancel_reservation'),
]
