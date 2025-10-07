from django.db import models
from django.conf import settings
from libros.models import Libro

# Create your models here.

class Prestamo(models.Model):
    usuario = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='prestamos')
    libro = models.ForeignKey(Libro, on_delete=models.CASCADE, related_name='prestamos')
    fecha_prestamo = models.DateTimeField(auto_now_add=True)
    fecha_devolucion = models.DateField(null=True, blank=True)
    devuelto = models.BooleanField(default=False)

    def __str__(self):
        return f"{self.libro.titulo} - {self.usuario.username}"

    class Meta:
        verbose_name = "Préstamo"
        verbose_name_plural = "Préstamos"
        ordering = ['-fecha_prestamo']
