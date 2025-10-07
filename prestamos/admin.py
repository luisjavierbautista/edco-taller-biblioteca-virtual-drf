from django.contrib import admin
from .models import Prestamo

# Register your models here.

@admin.register(Prestamo)
class PrestamoAdmin(admin.ModelAdmin):
    list_display = ['libro', 'usuario', 'fecha_prestamo', 'fecha_devolucion', 'devuelto']
    list_filter = ['devuelto', 'fecha_prestamo']
    search_fields = ['libro__titulo', 'usuario__username']
