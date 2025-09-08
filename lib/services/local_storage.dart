import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  /// Guardar un usuario con su contraseña
  static Future<void> saveUser(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_$username', password);
  }

  /// Obtener contraseña de un usuario
  static Future<String?> getUserPassword(String username) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_$username');
  }

  /// Guardar transacciones por usuario
  static Future<void> saveTransaction(
      String username, String key, double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('${username}_$key', value);
  }

  /// Obtener transacciones por usuario
  static Future<double> getTransaction(String username, String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('${username}_$key') ?? 0.0;
  }
}
