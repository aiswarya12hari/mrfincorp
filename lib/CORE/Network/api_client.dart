import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mr_fincorp/FEATURES/Navigation/presentation/pages/bottom_nav_page.dart';
import '../Config/api_config.dart';
import '../Storage/shared_preference.dart';
import '../../main.dart';
import '../../FEATURES/Login/presentation/pages/login_page.dart';

enum SessionStatus { valid, invalid, networkError }

class ApiClient {
  // Prevents multiple simultaneous refresh calls if several
  // requests get a 401 at the same time.
  static Completer<bool>? _refreshCompleter;

  static Future<http.Response> get(String url) {
    return _sendWithRefresh(() => _getRequest(url));
  }

  static Future<http.Response> post(String url, Map<String, dynamic> body) {
    return _sendWithRefresh(() => _postRequest(url, body));
  }

  static Future<http.Response> _getRequest(String url) {
    final token = AppPreferences.getAccessToken();
    return http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
  }

  static Future<http.Response> _postRequest(
    String url,
    Map<String, dynamic> body,
  ) {
    final token = AppPreferences.getAccessToken();
    return http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );
  }

  static Future<http.Response> patch(String url, Map<String, dynamic> body) {
    return _sendWithRefresh(() => _patchRequest(url, body));
  }

  static Future<http.Response> _patchRequest(
    String url,
    Map<String, dynamic> body,
  ) {
    final token = AppPreferences.getAccessToken();
    return http.patch(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );
  }

  static Future<http.Response> _sendWithRefresh(
    Future<http.Response> Function() request,
  ) async {
    http.Response response = await request();

    if (response.statusCode == 401) {
      debugPrint('ApiClient: 401 received, attempting token refresh');

      final refreshed = await _refreshToken();

      if (refreshed) {
        debugPrint('ApiClient: refresh succeeded, retrying request');
        response = await request();
      } else {
        debugPrint('ApiClient: refresh failed, forcing logout');
        await _forceLogout();
      }
    }

    return response;
  }

  static Future<bool> _refreshToken() async {
    // If a refresh is already in progress, wait for that one
    // instead of firing a second refresh call.
    if (_refreshCompleter != null) {
      return _refreshCompleter!.future;
    }

    _refreshCompleter = Completer<bool>();

    try {
      final refreshToken = AppPreferences.getRefreshToken();

      if (refreshToken == null || refreshToken.isEmpty) {
        _refreshCompleter!.complete(false);
        return false;
      }

      final response = await http.post(
        Uri.parse(ApiConfig.refreshToken),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refresh': refreshToken}),
      );

      debugPrint('ApiClient: refresh status => ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final newAccessToken = data['access'];

        if (newAccessToken != null) {
          await AppPreferences.updateActiveAccessToken(newAccessToken);
          _refreshCompleter!.complete(true);
          return true;
        }
      }

      _refreshCompleter!.complete(false);
      return false;
    } catch (e) {
      debugPrint('ApiClient: refresh token error => $e');
      _refreshCompleter!.complete(false);
      return false;
    } finally {
      _refreshCompleter = null;
    }
  }

  static Future<void> _forceLogout() async {
    final activeId = AppPreferences.getActiveUserId();

    final nextAccount = activeId != null
        ? await AppPreferences.removeAccount(activeId)
        : null;

    if (activeId == null) {
      await AppPreferences.clearAll();
    }

    if (nextAccount != null) {
      // Another saved account took over — go straight to the app
      // instead of kicking the user all the way out.
      navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const BottomNavPage()),
        (route) => false,
      );
    } else {
      navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
    }
  }

  static Future<SessionStatus> validateSession() async {
    final token = AppPreferences.getAccessToken();
    if (token == null || token.isEmpty) {
      debugPrint('SessionCheck: no access token stored => invalid');
      return SessionStatus.invalid;
    }

    try {
      final response = await _getRequest(ApiConfig.profile);
      debugPrint('SessionCheck: profile ping status => ${response.statusCode}');

      if (response.statusCode == 200) {
        debugPrint('SessionCheck: token valid');
        return SessionStatus.valid;
      }

      if (response.statusCode == 401) {
        debugPrint('SessionCheck: token expired, attempting silent refresh');
        final refreshed = await _refreshToken();
        debugPrint('SessionCheck: refresh result => $refreshed');
        return refreshed ? SessionStatus.valid : SessionStatus.invalid;
      }

      debugPrint('SessionCheck: unexpected status, treating as invalid');
      return SessionStatus.invalid;
    } on SocketException catch (e) {
      debugPrint('SessionCheck: no network => $e');
      return SessionStatus.networkError;
    } on TimeoutException catch (e) {
      debugPrint('SessionCheck: request timed out => $e');
      return SessionStatus.networkError;
    } catch (e) {
      debugPrint('SessionCheck: unexpected error => $e');
      return SessionStatus.invalid;
    }
  }
}
