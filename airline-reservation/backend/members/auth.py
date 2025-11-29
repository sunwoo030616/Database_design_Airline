# members/auth.py
import jwt
from django.conf import settings
from rest_framework.authentication import BaseAuthentication
from rest_framework import exceptions
from .models import Member


class JWTAuthentication(BaseAuthentication):
    """
    Authorization: Bearer <token>
    형식의 헤더를 읽어서 JWT 검증 후 Member를 인증 유저로 리턴
    """
    keyword = 'Bearer'

    def authenticate(self, request):
        auth_header = request.META.get('HTTP_AUTHORIZATION', '')
        if not auth_header:
            return None

        parts = auth_header.split()
        if len(parts) != 2 or parts[0] != self.keyword:
            return None

        token = parts[1]
        try:
            payload = jwt.decode(
                token,
                settings.SECRET_KEY,
                algorithms=['HS256']
            )
        except jwt.ExpiredSignatureError:
            raise exceptions.AuthenticationFailed('토큰이 만료되었습니다.')
        except jwt.InvalidTokenError:
            raise exceptions.AuthenticationFailed('유효하지 않은 토큰입니다.')

        member_id = payload.get('member_id')
        if not member_id:
            raise exceptions.AuthenticationFailed('토큰에 member_id가 없습니다.')

        try:
            member = Member.objects.get(pk=member_id)
        except Member.DoesNotExist:
            raise exceptions.AuthenticationFailed('사용자를 찾을 수 없습니다.')

        # DRF 입장에서는 (user, auth) 튜플을 넘긴다
        return (member, None)
