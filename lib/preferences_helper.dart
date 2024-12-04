import 'package:shared_preferences/shared_preferences.dart';

class PreferencesHelper {
  static Future<void> saveAuthToken(String authToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('authToken', authToken);
  }

  static Future<String?> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken');
  }

  static Future<void> removeAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken');
  }
}
