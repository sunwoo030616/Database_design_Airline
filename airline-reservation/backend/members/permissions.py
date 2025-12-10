from rest_framework.permissions import BasePermission


class IsAdminUserType(BasePermission):
    """
    Allow access only to authenticated members with user_type == 'admin'.
    """
    def has_permission(self, request, view):
        user = getattr(request, 'user', None)
        if not user or not getattr(user, 'user_type', None):
            return False
        return user.user_type == 'admin'
