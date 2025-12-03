import 'package:shared_preferences/shared_preferences.dart';

class RememberMeService {
  static const String keyEmail = "saved_email";
  static const String keyPassword = "saved_password";
  static const String keyRemember = "remember_me";

  // simpan data
  Future<void> saveLoginData(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyEmail, email);
    await prefs.setString(keyPassword, password);
    await prefs.setBool(keyRemember, true);
  }

  // hapus data
  Future<void> clearLoginData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(keyEmail);
    await prefs.remove(keyPassword);
    await prefs.setBool(keyRemember, false);
  }

  // ambil data
  Future<Map<String, dynamic>> getLoginData() async {
    final prefs = await SharedPreferences.getInstance();

    return {
      'remember': prefs.getBool(keyRemember) ?? false,
      'email': prefs.getString(keyEmail) ?? '',
      'password': prefs.getString(keyPassword) ?? '',
    };
  }
}
