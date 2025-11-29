from rest_framework.decorators import api_view
from rest_framework.response import Response
from .models import DynamicFareLog, RevenueAnalysis
from .serializers import DynamicFareLogSerializer, RevenueAnalysisSerializer


@api_view(['GET'])
def fare_log_list(request):
    """
    GET /api/admin/fare-log/?flight_id=123
    """
    qs = DynamicFareLog.objects.select_related('flight').order_by('-changed_at')
    flight_id = request.GET.get('flight_id')
    if flight_id:
        qs = qs.filter(flight_id=flight_id)

    serializer = DynamicFareLogSerializer(qs, many=True)
    return Response(serializer.data)


@api_view(['GET'])
def revenue_analysis_list(request):
    """
    GET /api/admin/revenue/?route_id=1&from=2025-11-01&to=2025-11-30
    """
    qs = RevenueAnalysis.objects.all()
    route_id = request.GET.get('route_id')
    from_date = request.GET.get('from')
    to_date = request.GET.get('to')

    if route_id:
        qs = qs.filter(route_id=route_id)
    if from_date:
        qs = qs.filter(flight_date__gte=from_date)
    if to_date:
        qs = qs.filter(flight_date__lte=to_date)

    serializer = RevenueAnalysisSerializer(qs, many=True)
    return Response(serializer.data)
