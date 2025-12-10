from django.contrib import admin
from .models import Member, Customer, Admin as AdminModel


@admin.register(Member)
class MemberAdmin(admin.ModelAdmin):
	list_display = ('user_id', 'name', 'email', 'user_type', 'phone_num')
	list_filter = ('user_type',)
	search_fields = ('name', 'email')


@admin.register(Customer)
class CustomerAdmin(admin.ModelAdmin):
	list_display = ('user_id', 'mileage', 'grade')
	list_filter = ('grade',)
	search_fields = ('user__email',)


@admin.register(AdminModel)
class AdminRoleAdmin(admin.ModelAdmin):
	list_display = ('user_id', 'role')
	search_fields = ('user__email',)
