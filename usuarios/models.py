from django.db import models
from django.contrib.auth.models import AbstractUser

# Create your models here.

class Usuario(AbstractUser):
    rol = models.CharField(max_length=50, blank=True, null=True)
    ciudad = models.CharField(max_length=100, blank=True, null=True)

    def __str__(self):
        return self.username
