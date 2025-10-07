from django.contrib import admin
from django.contrib.auth.admin import UserAdmin
from .models import Usuario

# Register your models here.

@admin.register(Usuario)
class UsuarioAdmin(UserAdmin):
    list_display = ['username', 'email', 'first_name', 'last_name', 'rol', 'ciudad', 'is_staff']
    fieldsets = UserAdmin.fieldsets + (
        ('Información Adicional', {'fields': ('rol', 'ciudad')}),
    )
    add_fieldsets = UserAdmin.add_fieldsets + (
        ('Información Adicional', {'fields': ('rol', 'ciudad')}),
    )

