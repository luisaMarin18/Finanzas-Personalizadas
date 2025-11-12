// lib/services/biometric_service.dart
import 'package:local_auth/local_auth.dart';

class BiometricService {
  static final LocalAuthentication _auth = LocalAuthentication();

  /// Comprueba si el dispositivo soporta biometría (o autenticación local).
  static Future<bool> isBiometricAvailable() async {
    try {
      final bool canCheck = await _auth.isDeviceSupported();
      // También se puede usar canCheckBiometrics para chequear sensores concretos
      return canCheck;
    } catch (_) {
      return false;
    }
  }

  /// Devuelve la lista de tipos de biometría disponibles (fingerprint, face, etc.)
  static Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    } catch (_) {
      return <BiometricType>[];
    }
  }

  /// Lanza la ventana nativa de autenticación biométrica.
  /// Si succeed -> true, si falla o cancela -> false.
  static Future<bool> authenticate({
    String reason = 'Autentíquese para continuar',
    bool biometricOnly = true,
  }) async {
    try {
      final bool didAuthenticate = await _auth.authenticate(
        localizedReason: reason,
        options: AuthenticationOptions(
          biometricOnly: biometricOnly,
          stickyAuth: false,
        ),
      );
      return didAuthenticate;
    } catch (_) {
      return false;
    }
  }
}
