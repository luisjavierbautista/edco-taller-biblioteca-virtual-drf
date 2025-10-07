#!/bin/bash

# Script de ejemplo práctico - Punto 7
# Prueba la API usando curl y almacena los resultados

echo "======================================================================"
echo "EJEMPLO PRÁCTICO - PUNTO 7"
echo "Probando la API con curl"
echo "======================================================================"
echo ""

# Crear directorio para resultados
mkdir -p resultados_api
echo "✓ Directorio 'resultados_api' creado para almacenar respuestas"
echo ""

# Variables
BASE_URL="http://127.0.0.1:8000"
RESULTADOS_DIR="resultados_api"

# Paso 0: Crear usuarios adicionales mediante Django shell
echo "======================================================================"
echo "Paso 0: Creando usuarios adicionales..."
echo "======================================================================"

python manage.py shell <<EOF
from django.contrib.auth import get_user_model
User = get_user_model()

usuario1, created1 = User.objects.get_or_create(
    username='juan_perez',
    defaults={
        'email': 'juan@example.com',
        'first_name': 'Juan',
        'last_name': 'Pérez',
        'rol': 'Estudiante',
        'ciudad': 'Medellín'
    }
)
if created1:
    usuario1.set_password('password123')
    usuario1.save()
    print(f"✓ Usuario creado: {usuario1.username} (ID: {usuario1.id})")
else:
    print(f"✓ Usuario ya existe: {usuario1.username} (ID: {usuario1.id})")

usuario2, created2 = User.objects.get_or_create(
    username='maria_garcia',
    defaults={
        'email': 'maria@example.com',
        'first_name': 'María',
        'last_name': 'García',
        'rol': 'Docente',
        'ciudad': 'Cali'
    }
)
if created2:
    usuario2.set_password('password123')
    usuario2.save()
    print(f"✓ Usuario creado: {usuario2.username} (ID: {usuario2.id})")
else:
    print(f"✓ Usuario ya existe: {usuario2.username} (ID: {usuario2.id})")

print(f"ID usuario juan_perez: {User.objects.get(username='juan_perez').id}")
print(f"ID usuario maria_garcia: {User.objects.get(username='maria_garcia').id}")
EOF

echo ""

# Obtener IDs de usuarios
USUARIO1_ID=$(python manage.py shell -c "from django.contrib.auth import get_user_model; User = get_user_model(); print(User.objects.get(username='juan_perez').id)" 2>/dev/null | tail -1)
USUARIO2_ID=$(python manage.py shell -c "from django.contrib.auth import get_user_model; User = get_user_model(); print(User.objects.get(username='maria_garcia').id)" 2>/dev/null | tail -1)

echo "IDs obtenidos: usuario1=$USUARIO1_ID, usuario2=$USUARIO2_ID"
echo ""

# Paso previo: Obtener token de autenticación
echo "======================================================================"
echo "Obteniendo token de autenticación JWT..."
echo "======================================================================"

# Nota: Cambia 'admin' y 'admin123' por las credenciales de tu superusuario
echo "IMPORTANTE: Asegúrate de haber creado el superusuario con:"
echo "  python manage.py createsuperuser"
echo ""
echo "Usando username='admin' y password='admin123' (cambiar si es necesario)"
echo ""

TOKEN_RESPONSE=$(curl -s -X POST "$BASE_URL/api/token/" \
  -H "Content-Type: application/json" \
  -d '{
    "username": "admin",
    "password": "admin123"
  }')

echo "$TOKEN_RESPONSE" | python -m json.tool > "$RESULTADOS_DIR/00_token.json"

ACCESS_TOKEN=$(echo "$TOKEN_RESPONSE" | python -c "import sys, json; print(json.load(sys.stdin)['access'])" 2>/dev/null)

if [ -z "$ACCESS_TOKEN" ]; then
    echo "❌ ERROR: No se pudo obtener el token de autenticación"
    echo "Respuesta del servidor guardada en: $RESULTADOS_DIR/00_token.json"
    echo ""
    echo "Posibles soluciones:"
    echo "  1. Verifica que el servidor esté corriendo: python manage.py runserver"
    echo "  2. Crea el superusuario: python manage.py createsuperuser"
    echo "  3. Verifica las credenciales en este script"
    exit 1
fi

echo "✓ Token obtenido exitosamente"
echo "✓ Resultado guardado en: $RESULTADOS_DIR/00_token.json"
echo ""

# 1. Registrar al menos 3 libros a través de la API
echo "======================================================================"
echo "1. Registrando 3 libros a través de la API..."
echo "======================================================================"

echo "Creando libro 1: Cien Años de Soledad..."
curl -s -X POST "$BASE_URL/api/libros/" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "titulo": "Cien Años de Soledad",
    "autor": "Gabriel García Márquez",
    "isbn": "9780060883287",
    "fecha_publicacion": "1967-05-30",
    "disponible": true
  }' | python -m json.tool > "$RESULTADOS_DIR/01_libro_cien_anos.json"
echo "✓ Resultado guardado en: $RESULTADOS_DIR/01_libro_cien_anos.json"

echo "Creando libro 2: El Principito..."
curl -s -X POST "$BASE_URL/api/libros/" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "titulo": "El Principito",
    "autor": "Antoine de Saint-Exupéry",
    "isbn": "9780156012195",
    "fecha_publicacion": "1943-04-06",
    "disponible": true
  }' | python -m json.tool > "$RESULTADOS_DIR/01_libro_principito.json"
echo "✓ Resultado guardado en: $RESULTADOS_DIR/01_libro_principito.json"

echo "Creando libro 3: 1984..."
curl -s -X POST "$BASE_URL/api/libros/" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "titulo": "1984",
    "autor": "George Orwell",
    "isbn": "9780451524935",
    "fecha_publicacion": "1949-06-08",
    "disponible": true
  }' | python -m json.tool > "$RESULTADOS_DIR/01_libro_1984.json"
echo "✓ Resultado guardado en: $RESULTADOS_DIR/01_libro_1984.json"

echo ""

# Obtener IDs de libros creados
LIBRO1_ID=$(cat "$RESULTADOS_DIR/01_libro_cien_anos.json" | python -c "import sys, json; print(json.load(sys.stdin)['id'])" 2>/dev/null || echo "1")
LIBRO2_ID=$(cat "$RESULTADOS_DIR/01_libro_principito.json" | python -c "import sys, json; print(json.load(sys.stdin)['id'])" 2>/dev/null || echo "2")
LIBRO3_ID=$(cat "$RESULTADOS_DIR/01_libro_1984.json" | python -c "import sys, json; print(json.load(sys.stdin)['id'])" 2>/dev/null || echo "3")

echo "IDs de libros creados: libro1=$LIBRO1_ID, libro2=$LIBRO2_ID, libro3=$LIBRO3_ID"
echo ""

# 2. Crear 2 préstamos asociados a usuarios autenticados
echo "======================================================================"
echo "2. Creando 2 préstamos asociados a usuarios autenticados..."
echo "======================================================================"

echo "Creando préstamo 1: Cien Años de Soledad para juan_perez..."
PRESTAMO1_DATA=$(python -c "import json; print(json.dumps({'usuario': $USUARIO1_ID, 'libro': $LIBRO1_ID, 'fecha_devolucion': '2025-10-21', 'devuelto': False}))")
curl -s -X POST "$BASE_URL/api/prestamos/" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d "$PRESTAMO1_DATA" | python -m json.tool > "$RESULTADOS_DIR/02_prestamo_1.json"
echo "✓ Resultado guardado en: $RESULTADOS_DIR/02_prestamo_1.json"

echo "Creando préstamo 2: El Principito para maria_garcia..."
PRESTAMO2_DATA=$(python -c "import json; print(json.dumps({'usuario': $USUARIO2_ID, 'libro': $LIBRO2_ID, 'fecha_devolucion': '2025-10-13', 'devuelto': False}))")
curl -s -X POST "$BASE_URL/api/prestamos/" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d "$PRESTAMO2_DATA" | python -m json.tool > "$RESULTADOS_DIR/02_prestamo_2.json"
echo "✓ Resultado guardado en: $RESULTADOS_DIR/02_prestamo_2.json"

echo ""

PRESTAMO2_ID=$(cat "$RESULTADOS_DIR/02_prestamo_2.json" | python -c "import sys, json; print(json.load(sys.stdin)['id'])" 2>/dev/null || echo "2")

# 3. Liste todos los préstamos mostrando el nombre del libro y el usuario que lo solicitó
echo "======================================================================"
echo "3. Listando todos los préstamos..."
echo "======================================================================"

curl -s -X GET "$BASE_URL/api/prestamos/" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  | python -m json.tool > "$RESULTADOS_DIR/03_lista_prestamos.json"

echo "✓ Resultado guardado en: $RESULTADOS_DIR/03_lista_prestamos.json"
echo ""
echo "Préstamos encontrados:"
cat "$RESULTADOS_DIR/03_lista_prestamos.json" | python -c "
import sys, json
data = json.load(sys.stdin)
for p in data:
    libro = p.get('libro_detalle', {}).get('titulo', 'N/A')
    usuario = p.get('usuario_detalle', {}).get('username', 'N/A')
    print(f\"  • {libro} → Usuario: {usuario}\")
" 2>/dev/null || echo "  Ver detalles en el archivo JSON"

echo ""

# 4. Actualice la información de un libro y confirme el cambio en el listado
echo "======================================================================"
echo "4. Actualizando información del libro 1984..."
echo "======================================================================"

echo "Estado antes de actualizar:"
curl -s -X GET "$BASE_URL/api/libros/$LIBRO3_ID/" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  | python -m json.tool > "$RESULTADOS_DIR/04_libro_antes.json"
echo "✓ Estado anterior guardado en: $RESULTADOS_DIR/04_libro_antes.json"

cat "$RESULTADOS_DIR/04_libro_antes.json" | python -c "
import sys, json
data = json.load(sys.stdin)
print(f\"  Título: {data.get('titulo')}\"  )
print(f\"  Disponible: {data.get('disponible')}\")
" 2>/dev/null || echo "  Ver detalles en el archivo JSON"

echo ""
echo "Actualizando disponibilidad a false..."
curl -s -X PATCH "$BASE_URL/api/libros/$LIBRO3_ID/" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "disponible": false
  }' | python -m json.tool > "$RESULTADOS_DIR/04_libro_despues.json"
echo "✓ Estado actualizado guardado en: $RESULTADOS_DIR/04_libro_despues.json"

echo ""
echo "Estado después de actualizar:"
cat "$RESULTADOS_DIR/04_libro_despues.json" | python -c "
import sys, json
data = json.load(sys.stdin)
print(f\"  Título: {data.get('titulo')}\")
print(f\"  Disponible: {data.get('disponible')}\")
" 2>/dev/null || echo "  Ver detalles en el archivo JSON"

echo ""

# 5. Elimine un préstamo y confirme que ya no aparece en el listado
echo "======================================================================"
echo "5. Eliminando un préstamo..."
echo "======================================================================"

echo "Total de préstamos antes de eliminar:"
TOTAL_ANTES=$(cat "$RESULTADOS_DIR/03_lista_prestamos.json" | python -c "import sys, json; print(len(json.load(sys.stdin)))" 2>/dev/null || echo "N/A")
echo "  Total: $TOTAL_ANTES"

echo ""
echo "Eliminando préstamo 2..."
curl -s -X DELETE "$BASE_URL/api/prestamos/$PRESTAMO2_ID/" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -w "\nHTTP Status: %{http_code}\n" > "$RESULTADOS_DIR/05_eliminar_prestamo.txt"
echo "✓ Resultado guardado en: $RESULTADOS_DIR/05_eliminar_prestamo.txt"

echo ""
echo "Listando préstamos después de eliminar..."
curl -s -X GET "$BASE_URL/api/prestamos/" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  | python -m json.tool > "$RESULTADOS_DIR/05_lista_prestamos_final.json"
echo "✓ Resultado guardado en: $RESULTADOS_DIR/05_lista_prestamos_final.json"

echo ""
echo "Total de préstamos después de eliminar:"
TOTAL_DESPUES=$(cat "$RESULTADOS_DIR/05_lista_prestamos_final.json" | python -c "import sys, json; print(len(json.load(sys.stdin)))" 2>/dev/null || echo "N/A")
echo "  Total: $TOTAL_DESPUES"

echo ""
echo "Préstamos restantes:"
cat "$RESULTADOS_DIR/05_lista_prestamos_final.json" | python -c "
import sys, json
data = json.load(sys.stdin)
for p in data:
    libro = p.get('libro_detalle', {}).get('titulo', 'N/A')
    usuario = p.get('usuario_detalle', {}).get('username', 'N/A')
    print(f\"  • {libro} → Usuario: {usuario}\")
" 2>/dev/null || echo "  Ver detalles en el archivo JSON"

echo ""
echo "======================================================================"
echo "✓ EJEMPLO PRÁCTICO COMPLETADO EXITOSAMENTE"
echo "======================================================================"
echo ""
echo "Todos los resultados se han guardado en el directorio: $RESULTADOS_DIR/"
echo ""
echo "Archivos generados:"
ls -1 "$RESULTADOS_DIR/"
echo ""
echo "Puedes verificar los datos en:"
echo "  - Admin: http://127.0.0.1:8000/admin/"
echo "  - API Libros: http://127.0.0.1:8000/api/libros/"
echo "  - API Préstamos: http://127.0.0.1:8000/api/prestamos/"
