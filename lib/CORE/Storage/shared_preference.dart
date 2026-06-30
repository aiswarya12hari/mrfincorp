import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userDataKey = 'user_data';

  // Save Login Data
  static Future<void> saveLoginData({
    required String accessToken,
    required String refreshToken,
    required Map<String, dynamic> userData,
  }) async {
    await _prefs?.setString(
      accessTokenKey,
      accessToken,
    );

    await _prefs?.setString(
      refreshTokenKey,
      refreshToken,
    );

    await _prefs?.setString(
      userDataKey,
      jsonEncode(userData),
    );
  }

  // Access Token
  static String? getAccessToken() {
    return _prefs?.getString(accessTokenKey);
  }

  // Refresh Token
  static String? getRefreshToken() {
    return _prefs?.getString(refreshTokenKey);
  }

  // User Data
  static Map<String, dynamic>? getUserData() {
    final data = _prefs?.getString(userDataKey);

    if (data == null) return null;

    return jsonDecode(data);
  }

  // Login Check
  static bool isLoggedIn() {
    final token = getAccessToken();

    return token != null && token.isNotEmpty;
  }

  // Logout
  static Future<void> logout() async {
    await _prefs?.remove(accessTokenKey);
    await _prefs?.remove(refreshTokenKey);
    await _prefs?.remove(userDataKey);
  }

  // Clear All
  static Future<void> clearAll() async {
    await _prefs?.clear();
  }
}