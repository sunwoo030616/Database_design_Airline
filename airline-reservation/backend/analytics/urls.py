from django.urls import path
from . import views

urlpatterns = [
    path('fare-log/', views.fare_log_list, name='fare_log_list'),
    path('revenue/', views.revenue_analysis_list, name='revenue_analysis_list'),
    path('revenue/rollup', views.revenue_rollup, name='revenue_rollup'),
    path('revenue/cube', views.revenue_cube, name='revenue_cube'),
    path('routes/path', views.routes_path_distance, name='routes_path_distance'),
]
