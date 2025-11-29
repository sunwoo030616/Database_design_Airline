from django.urls import path
from . import views

urlpatterns = [
    path('fare-log/', views.fare_log_list, name='fare_log_list'),
    path('revenue/', views.revenue_analysis_list, name='revenue_analysis_list'),
]
