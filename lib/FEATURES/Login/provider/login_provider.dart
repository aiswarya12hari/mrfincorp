import 'package:flutter/material.dart';
import 'package:mr_fincorp/FEATURES/Account/data/models/account_model.dart';

import 'package:mr_fincorp/FEATURES/Login/data/models/login_model.dart';
import 'package:mr_fincorp/FEATURES/Login/data/services/login_service.dart';

import '../../../CORE/Storage/shared_preference.dart';

class LoginProvider extends ChangeNotifier {
  final LoginService _service;

  LoginProvider({LoginService? service}) : _service = service ?? LoginService();

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

      final userData = {
        "id": loginData!.user.id,
        "role": loginData!.user.role,
        "email": loginData!.user.email,
        "phone": loginData!.user.phone,
        "field_staff_id": loginData!.user.fieldStaffId,
        "field_staff_name": loginData!.user.fieldStaffName,
        "branch_id": loginData!.user.branchId,
        "branch_name": loginData!.user.branchName,
        "branch_code": loginData!.user.branchCode,
      };

      await AppPreferences.addOrUpdateAccount(
        AccountModel(
          userId: loginData!.user.id.toString(),
          name: loginData!.user.fieldStaffName,
          email: loginData!.user.email,
          accessToken: loginData!.access,
          refreshToken: loginData!.refresh,
          userData: userData,
        ),
      );

      debugPrint('LOGIN SUCCESS');
      debugPrint('SAVED ACCESS => ${AppPreferences.getAccessToken()}');

      debugPrint('SAVED REFRESH => ${AppPreferences.getRefreshToken()}');

      return true;
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');

      debugPrint('LOGIN PROVIDER ERROR => $errorMessage');

      return false;
    } finally {
      _isLoading = false;

      notifyListeners();
    }
  }
}
