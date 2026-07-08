// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import '../../../../CORE/Config/api_config.dart';
// import '../../../../CORE/Storage/shared_preference.dart';
// import '../models/profile_model.dart';

// class ProfileService {
//   Future<ProfileModel> getProfile() async {
//     try {
//       final token = AppPreferences.getAccessToken();

//       debugPrint('TOKEN => $token');

//       debugPrint('URL => ${ApiConfig.profile}');

//       final response = await http.get(
//         Uri.parse(ApiConfig.profile),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//       );

//       debugPrint('STATUS => ${response.statusCode}');

//       debugPrint('BODY => ${response.body}');

//       if (response.statusCode == 200) {
//         return ProfileModel.fromJson(jsonDecode(response.body));
//       }

//       throw Exception(response.body);
//     } catch (e) {
//       debugPrint('PROFILE SERVICE ERROR => $e');

//       rethrow;
//     }
//   }
// }


import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../../CORE/Config/api_config.dart';
import '../../../../CORE/Network/api_client.dart';
import '../models/profile_model.dart';

class ProfileService {
  Future<ProfileModel> getProfile() async {
    try {
      final response = await ApiClient.get(ApiConfig.profile);

      debugPrint('STATUS => ${response.statusCode}');
      debugPrint('BODY => ${response.body}');

      if (response.statusCode == 200) {
        return ProfileModel.fromJson(jsonDecode(response.body));
      }

      throw Exception(response.body);
    } catch (e) {
      debugPrint('PROFILE SERVICE ERROR => $e');
      rethrow;
    }
  }
}