from django.contrib import admin
from .models import Libro

# Register your models here.

@admin.register(Libro)
class LibroAdmin(admin.ModelAdmin):
    list_display = ['titulo', 'autor', 'isbn', 'fecha_publicacion', 'disponible']
    list_filter = ['disponible', 'fecha_publicacion']
    search_fields = ['titulo', 'autor', 'isbn']
