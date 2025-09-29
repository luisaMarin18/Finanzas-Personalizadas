# Finanzas Personalizadas - Aplicación Flutter

## Descripción
Finanzas Personalizadas es una aplicación móvil desarrollada en Flutter para la gestión de finanzas personales. Permite a los usuarios:

- Registrar cuentas nuevas con usuario y contraseña.
- Recuperar contraseña si se olvida.
- Registrar ingresos, gastos diarios y gastos hormiga.
- Ver un dashboard con un resumen financiero personalizado.
- Visualizar una gráfica interactiva de ingresos y gastos.
- Guardar todos los datos localmente para persistencia entre sesiones.
- Dashboard individual por usuario.

## Funcionalidades
- Login / Registro de usuario.
- Recuperación de contraseña.
- Dashboard individualizado.
- Registro de gastos e ingresos diarios.
- Gráficas interactivas usando `fl_chart`.
- Persistencia de datos usando `shared_preferences`.

## 📂 Estructura
- `lib/screens/welcome_screen.dart` → Pantalla de inicio de sesión
- `lib/screens/register_screen.dart` → Pantalla de registro de usuario
- `lib/screens/dashboard_screen.dart` → Dashboard con ingresos, gastos y gráfica
- `lib/services/local_storage.dart` → Manejo de datos locales con SharedPreferences

## Instalación
1. Clonar el repositorio:
```bash
git clone https://github.com/luisaMarin18/Finanzas-Personalizadas.git