from rest_framework import serializers
from django.contrib.auth.hashers import make_password, check_password
from .models import Member, Customer


class RegisterSerializer(serializers.Serializer):
    name = serializers.CharField(max_length=50)
    email = serializers.EmailField()
    password = serializers.CharField(write_only=True, min_length=6)
    phone_num = serializers.CharField(max_length=20, required=False, allow_blank=True)

    def validate_email(self, value):
        if Member.objects.filter(email=value).exists():
            raise serializers.ValidationError('이미 사용 중인 이메일입니다.')
        return value

    def create(self, validated_data):
        raw_password = validated_data.pop('password')
        hashed = make_password(raw_password)

        member = Member.objects.create(
            password=hashed,
            user_type='customer',
            **validated_data,
        )
        # 회원 가입 시 Customer 프로필 자동 생성하여 이후 API에서 member_id 요구를 방지
        try:
            Customer.objects.get_or_create(user=member)
        except Exception:
            # 외부 스키마 제약으로 실패해도 회원 생성은 유지
            pass
        return member


class LoginSerializer(serializers.Serializer):
    email = serializers.EmailField()
    password = serializers.CharField(write_only=True)

    def validate(self, attrs):
        email = attrs.get('email')
        password = attrs.get('password')

        try:
            member = Member.objects.get(email=email)
        except Member.DoesNotExist:
            raise serializers.ValidationError('이메일 또는 비밀번호를 확인하세요.')

        if not check_password(password, member.password):
            raise serializers.ValidationError('이메일 또는 비밀번호를 확인하세요.')

        attrs['member'] = member
        return attrs


class MemberMeSerializer(serializers.ModelSerializer):
    class Meta:
        model = Member
        fields = ['user_id', 'name', 'email', 'phone_num', 'user_type']
