import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../../CORE/Config/api_config.dart';
import '../../../../CORE/Storage/shared_preference.dart';

class LogoutService {
  Future<void> logout() async {
    try {
      final accessToken = AppPreferences.getAccessToken();
      final refreshToken = AppPreferences.getRefreshToken();

      debugPrint('ACCESS TOKEN => $accessToken');
      debugPrint('REFRESH TOKEN => $refreshToken');

      final response = await http.post(
        Uri.parse(ApiConfig.logout),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({"refresh": refreshToken}),
      );

      debugPrint('LOGOUT STATUS => ${response.statusCode}');
      debugPrint('LOGOUT RESPONSE => ${response.body}');

      if (response.statusCode == 200) {
        return;
      }

      if (response.body.contains('token_blacklisted')) {
        return;
      }

      // Even if the server call fails (e.g. access token already
      // expired), we still want the local logout to proceed —
      // don't block the user from logging out on the client side.
      debugPrint(
        'Logout server call failed, proceeding with local logout anyway',
      );
    } catch (e) {
      debugPrint('Logout Service Error => $e');
      // Same reasoning — don't rethrow and block local logout
      // just because the network call failed.
    }
  }
}
