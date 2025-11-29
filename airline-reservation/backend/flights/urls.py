from django.urls import path
from . import views

urlpatterns = [
    path('', views.flight_list, name='flight_list'),
    path('routes/min-distance/', views.min_distance_route, name='min_distance_route'),
    path('<int:flight_id>/seats/', views.flight_seat_info),
]
