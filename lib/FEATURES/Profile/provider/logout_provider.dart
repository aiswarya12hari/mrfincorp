import 'package:flutter/material.dart';

import '../../../CORE/Storage/shared_preference.dart';
import '../data/services/logout_service.dart';

class LogoutProvider extends ChangeNotifier {
  final LogoutService _service =
      LogoutService();

  bool isLoading = false;

  Future<bool> logout() async {
    try {
      isLoading = true;
      notifyListeners();

      await _service.logout();

      await AppPreferences.logout();

      return true;
    } catch (e) {
      debugPrint(
        'Logout Error => $e',
      );

      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}