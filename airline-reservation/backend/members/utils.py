# members/utils.py
import datetime
import jwt
from django.conf import settings


def create_jwt_for_member(member):
    """
    member_id를 payload에 넣고 HS256으로 서명한 JWT 생성
    """
    payload = {
        'member_id': member.user_id,
        'email': member.email,
        'exp': datetime.datetime.utcnow() + datetime.timedelta(hours=6),  # 6시간 유효
        'iat': datetime.datetime.utcnow(),
    }

    token = jwt.encode(payload, settings.SECRET_KEY, algorithm='HS256')
    # PyJWT 2.x 기준 str 반환
    return token
