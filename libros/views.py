from rest_framework import viewsets
from rest_framework.permissions import IsAuthenticated
from .models import Libro
from .serializers import LibroSerializer

# Create your views here.

class LibroViewSet(viewsets.ModelViewSet):
    queryset = Libro.objects.all()
    serializer_class = LibroSerializer
    permission_classes = [IsAuthenticated]
