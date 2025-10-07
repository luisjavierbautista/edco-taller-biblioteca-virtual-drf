from django.db import models

# Create your models here.

class Libro(models.Model):
    titulo = models.CharField(max_length=200)
    autor = models.CharField(max_length=100)
    isbn = models.CharField(max_length=13, unique=True)
    fecha_publicacion = models.DateField()
    disponible = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return self.titulo

    class Meta:
        verbose_name = "Libro"
        verbose_name_plural = "Libros"
        ordering = ['-created_at']
