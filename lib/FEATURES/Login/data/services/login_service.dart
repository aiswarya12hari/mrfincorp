import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:mr_fincorp/FEATURES/Login/data/models/login_model.dart';
import '../../../../CORE/Config/api_config.dart';

class LoginService {
  Future<LoginResponseModel> login({
    required String email,
    required String password,
  }) async {
    try {
      debugPrint('========== LOGIN API ==========');
      debugPrint('URL => ${ApiConfig.login}');
      debugPrint('EMAIL => $email');

      final response = await http
          .post(
            Uri.parse(ApiConfig.login),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({"email": email, "password": password}),
          )
          .timeout(const Duration(seconds: 15));

      debugPrint('STATUS CODE => ${response.statusCode}');
      debugPrint('BODY => ${response.body}');

      if (response.statusCode == 200) {
        return LoginResponseModel.fromJson(jsonDecode(response.body));
      }

      if (response.statusCode == 401) {
        throw Exception('Invalid credentials');
      }

      throw Exception('Login Failed : ${response.statusCode}');
    } on TimeoutException {
      throw Exception(
        'Connection timeout. Please check your internet connection.',
      );
    } on SocketException {
      throw Exception('Network error. Please check your internet connection.');
    } catch (e) {
      debugPrint('SERVICE ERROR => $e');
      rethrow;
    }
  }
}
