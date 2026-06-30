import 'package:flutter/material.dart';

import '../data/models/login_model.dart';
import '../data/services/login_service.dart';

import '../../../CORE/Storage/shared_preference.dart';

class LoginProvider extends ChangeNotifier {
  final LoginService _service = LoginService();

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  LoginResponseModel? loginData;

  String? errorMessage;

  Future<bool> login({required String email, required String password}) async {
    try {
      _isLoading = true;
      errorMessage = null;

      notifyListeners();

      loginData = await _service.login(email: email, password: password);

      await AppPreferences.saveLoginData(
        accessToken: loginData!.access,
        refreshToken: loginData!.refresh,
        userData: {
          "id": loginData!.user.id,
          "role": loginData!.user.role,
          "email": loginData!.user.email,
          "phone": loginData!.user.phone,
          "field_staff_id": loginData!.user.fieldStaffId,
          "field_staff_name": loginData!.user.fieldStaffName,
          "branch_id": loginData!.user.branchId,
          "branch_name": loginData!.user.branchName,
          "branch_code": loginData!.user.branchCode,
        },
      );

      debugPrint('LOGIN SUCCESS');
      debugPrint('SAVED ACCESS => ${AppPreferences.getAccessToken()}');

      debugPrint('SAVED REFRESH => ${AppPreferences.getRefreshToken()}');

      return true;
    } catch (e) {
      errorMessage = e.toString();

      debugPrint('LOGIN PROVIDER ERROR => $errorMessage');

      return false;
    } finally {
      _isLoading = false;

      notifyListeners();
    }
  }
}
