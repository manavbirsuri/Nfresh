import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  final String _auth = "auth_code";

  /// ------------------------------------------------------------
  /// Method that returns the user authCode to hit web service
  /// ------------------------------------------------------------
  Future<String> getAuthCode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_auth) ?? "no";
  }

  /// ------------------------------------------------------------
  /// Method that save the user Auth
  /// ------------------------------------------------------------
  Future<bool> setAuthCode(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_auth, value);
  }
}
