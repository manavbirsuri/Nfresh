import 'dart:convert';

import 'package:nfresh/models/profile_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  final String _auth = "auth_code";
  final String _profile = "profile";

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

  /// ------------------------------------------------------------
  /// Method that save the user Profile
  /// ------------------------------------------------------------
  Future<bool> saveProfile(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_profile, value);
  }

  /// ------------------------------------------------------------
  /// Method that get user Profile
  /// ------------------------------------------------------------
  Future<ProfileModel> getProfile() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String profile = prefs.getString(_profile) ?? "{}";
    return ProfileModel(jsonDecode(profile));
  }
}
