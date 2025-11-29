from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework import status

from .serializers import (
    RegisterSerializer,
    LoginSerializer,
    MemberMeSerializer,
)
from .utils import create_jwt_for_member


@api_view(['POST'])
def register(request):
    """
    POST /api/auth/register/
    { "name": "...", "email": "...", "password": "...", "phone_num": "..." }
    """
    serializer = RegisterSerializer(data=request.data)
    serializer.is_valid(raise_exception=True)
    member = serializer.save()
    token = create_jwt_for_member(member)

    return Response(
        {
            'token': token,
            'member': MemberMeSerializer(member).data,
        },
        status=status.HTTP_201_CREATED,
    )


@api_view(['POST'])
def login(request):
    """
    POST /api/auth/login/
    { "email": "...", "password": "..." }
    """
    serializer = LoginSerializer(data=request.data)
    serializer.is_valid(raise_exception=True)
    member = serializer.validated_data['member']
    token = create_jwt_for_member(member)

    return Response(
        {
            'token': token,
            'member': MemberMeSerializer(member).data,
        },
        status=status.HTTP_200_OK,
    )


@api_view(['GET'])
@permission_classes([IsAuthenticated])
def me(request):
    """
    GET /api/members/me/
    Authorization: Bearer <token>
    """
    member = request.user  # JWTAuthentication에서 돌려준 Member 객체
    data = MemberMeSerializer(member).data
    return Response(data, status=status.HTTP_200_OK)
