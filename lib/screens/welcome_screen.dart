import 'package:app_demo/services/local_storage.dart';
import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'register_screen.dart';
import 'package:app_demo/services/biometric_service.dart';


class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  uture<void> _loginUser() async {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

   if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Debes llenar ambos campos")),
      );
     return;
    }

    String? savedPassword = await LocalStorageService.getUserPassword(username);

  if (savedPassword == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Usuario no encontrado")),
      );
      return;
    }

    if (savedPassword != password) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Contraseña incorrecta")),
      );
      return;
    }

    // --- NUEVO: Antes de navegar, intentar autenticación biométrica ---
    try {
      final bool biometricAvailable = await BiometricService.isBiometricAvailable();
      bool authenticated = true; // por defecto true si no hay biometría

      if (biometricAvailable) {
        // mostrar dialogo biometría (si está disponible)
        authenticated = await BiometricService.authenticate(
          reason: 'Verifica tu identidad con huella/Face ID para iniciar sesión',
        );
      }

      if (!authenticated) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Autenticación biométrica fallida o cancelada")),
        );
        return;
      }
    } catch (_) {
      // En caso de error en biometría, mostramos mensaje y no permitimos acceso
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error al autenticar biométricamente")),
      );
      return;
    }

    // Si todo está bien (contraseña + biometría si aplica), navegar:
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => DashboardScreen(username: username),
      ),
    );
  }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => DashboardScreen(username: username),
      ),
    );
  }

  Future<void> _recoverPassword() async {
    String username = _usernameController.text.trim();
    if (username.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Ingresa el usuario para recuperar la contraseña")),
      );
      return;
    }

    String? savedPassword = await LocalStorageService.getUserPassword(username);

    if (savedPassword == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Usuario no encontrado")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("La contraseña es: $savedPassword")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[100],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "FINANZAS PERSONALES",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  hintText: "Usuario",
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: "Contraseña",
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _recoverPassword,
                  child: const Text("Recuperar contraseña"),
                ),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: _loginUser,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text("Iniciar Sesión"),
              ),
              const SizedBox(height: 15),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RegisterScreen()),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    "REGISTRO NUEVO",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
