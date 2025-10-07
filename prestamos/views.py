from rest_framework import viewsets
from rest_framework.permissions import IsAuthenticated
from .models import Prestamo
from .serializers import PrestamoSerializer

# Create your views here.

class PrestamoViewSet(viewsets.ModelViewSet):
    queryset = Prestamo.objects.all()
    serializer_class = PrestamoSerializer
    permission_classes = [IsAuthenticated]
