from rest_framework import serializers
from .models import Prestamo
from libros.serializers import LibroSerializer
from django.contrib.auth import get_user_model

User = get_user_model()

class UsuarioSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['id', 'username', 'email', 'first_name', 'last_name', 'rol', 'ciudad']

class PrestamoSerializer(serializers.ModelSerializer):
    libro_detalle = LibroSerializer(source='libro', read_only=True)
    usuario_detalle = UsuarioSerializer(source='usuario', read_only=True)

    class Meta:
        model = Prestamo
        fields = '__all__'
        read_only_fields = ['fecha_prestamo']
