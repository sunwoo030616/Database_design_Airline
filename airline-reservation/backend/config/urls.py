from django.contrib import admin
from django.urls import path, include

urlpatterns = [
    path('admin/', admin.site.urls),

    path('api/flights/', include('flights.urls')),
    path('api/reserve/', include('reservations.urls')),
    path('api/admin/', include('analytics.urls')),
    path('api/members/', include('members.urls')),
]
