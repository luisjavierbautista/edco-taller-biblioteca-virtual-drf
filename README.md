# Taller - Biblioteca Virtual con Django REST Framework

Sistema de gestión de biblioteca virtual implementado con Django REST Framework que permite gestionar usuarios, libros y préstamos.

## Características

- ✅ CRUD completo de Libros
- ✅ CRUD completo de Préstamos
- ✅ Modelo de Usuario personalizado con campos adicionales (rol, ciudad)
- ✅ Autenticación JWT (JSON Web Tokens)
- ✅ Autenticación por sesión
- ✅ Panel de administración Django
- ✅ API REST navegable

## Estructura del Proyecto

```
biblioteca_virtual/
│── manage.py
│── biblioteca_virtual/
│   │── settings.py
│   │── urls.py
│   └── ...
│── usuarios/
│   │── models.py
│   │── admin.py
│   └── ...
│── libros/
│   │── models.py
│   │── serializers.py
│   │── views.py
│   └── urls.py
│── prestamos/
│   │── models.py
│   │── serializers.py
│   │── views.py
│   └── urls.py
└── .venv/
```

## Instalación y Configuración

### 1. Activar el entorno virtual

```bash
source .venv/bin/activate
```

### 2. Las dependencias ya están instaladas:
- Django 5.2.7
- Django REST Framework 3.16.1
- djangorestframework-simplejwt 5.5.1

### 3. Las migraciones ya están aplicadas

### 4. Crear superusuario

```bash
python manage.py createsuperuser
```

Ingresa los siguientes datos cuando se te soliciten:
- Username
- Email
- Password
- Rol (ej: Administrador)
- Ciudad (ej: Bogotá)

### 5. Iniciar el servidor

```bash
python manage.py runserver
```

### 6. Ejecutar ejemplo práctico (Punto 7)

En otra terminal, ejecuta el script de ejemplo práctico:

```bash
./ejemplo_practico.sh
```

Este script automáticamente:
1. Registra 3 libros a través de la API
2. Crea 2 préstamos asociados a usuarios autenticados
3. Lista todos los préstamos mostrando el libro y usuario
4. Actualiza la información de un libro
5. Elimina un préstamo y confirma que ya no aparece

Todos los resultados se guardan en el directorio `resultados_api/`

## Endpoints de la API

### Autenticación

- **Obtener token JWT:**
  ```
  POST /api/token/
  {
    "username": "admin",
    "password": "tu_password"
  }
  ```

- **Refrescar token:**
  ```
  POST /api/token/refresh/
  {
    "refresh": "tu_refresh_token"
  }
  ```

### Libros

- `GET /api/libros/` - Listar todos los libros
- `POST /api/libros/` - Crear un nuevo libro
- `GET /api/libros/{id}/` - Obtener detalles de un libro
- `PUT /api/libros/{id}/` - Actualizar un libro completo
- `PATCH /api/libros/{id}/` - Actualizar parcialmente un libro
- `DELETE /api/libros/{id}/` - Eliminar un libro

### Préstamos

- `GET /api/prestamos/` - Listar todos los préstamos
- `POST /api/prestamos/` - Crear un nuevo préstamo
- `GET /api/prestamos/{id}/` - Obtener detalles de un préstamo
- `PUT /api/prestamos/{id}/` - Actualizar un préstamo completo
- `PATCH /api/prestamos/{id}/` - Actualizar parcialmente un préstamo
- `DELETE /api/prestamos/{id}/` - Eliminar un préstamo

### Admin Panel

- `http://127.0.0.1:8000/admin/` - Panel de administración Django

## Uso de la API

### 1. Obtener token de autenticación

```bash
curl -X POST http://127.0.0.1:8000/api/token/ \
  -H "Content-Type: application/json" \
  -d '{"username": "admin", "password": "tu_password"}'
```

### 2. Listar libros (requiere autenticación)

```bash
curl http://127.0.0.1:8000/api/libros/ \
  -H "Authorization: Bearer tu_access_token"
```

### 3. Crear un libro

```bash
curl -X POST http://127.0.0.1:8000/api/libros/ \
  -H "Authorization: Bearer tu_access_token" \
  -H "Content-Type: application/json" \
  -d '{
    "titulo": "Don Quijote de la Mancha",
    "autor": "Miguel de Cervantes",
    "isbn": "9788424922689",
    "fecha_publicacion": "1605-01-16",
    "disponible": true
  }'
```

### 4. Crear un préstamo

```bash
curl -X POST http://127.0.0.1:8000/api/prestamos/ \
  -H "Authorization: Bearer tu_access_token" \
  -H "Content-Type: application/json" \
  -d '{
    "usuario": 1,
    "libro": 1,
    "fecha_devolucion": "2025-10-20",
    "devuelto": false
  }'
```

## Modelos

### Usuario (usuarios.Usuario)
- username
- email
- first_name
- last_name
- **rol** (personalizado)
- **ciudad** (personalizado)

### Libro (libros.Libro)
- titulo
- autor
- isbn (único)
- fecha_publicacion
- disponible
- created_at
- updated_at

### Préstamo (prestamos.Prestamo)
- usuario (ForeignKey)
- libro (ForeignKey)
- fecha_prestamo (auto)
- fecha_devolucion
- devuelto

## Navegador API (DRF Browsable API)

Puedes acceder a la interfaz navegable de DRF directamente desde tu navegador:

1. Asegúrate de estar autenticado en el admin panel
2. Visita: http://127.0.0.1:8000/api/libros/ o http://127.0.0.1:8000/api/prestamos/
3. Podrás ver y probar los endpoints directamente desde el navegador

## Tecnologías Utilizadas

- Python 3.x
- Django 5.2.7
- Django REST Framework 3.16.1
- djangorestframework-simplejwt 5.5.1
- SQLite (base de datos)

## Autor

Taller de Django REST Framework - Universidad de los Andes
