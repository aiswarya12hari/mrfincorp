import 'package:flutter/material.dart';

import '../../../CORE/Storage/shared_preference.dart';
import '../data/services/logout_service.dart';

class LogoutProvider extends ChangeNotifier {
  final LogoutService _service = LogoutService();

  bool isLoading = false;

  /// Returns:
  ///  - true  → another saved account is now active (go to Home)
  ///  - false → no accounts remain (go to Login)
  ///  - null  → logout failed
  Future<bool?> logout() async {
    try {
      isLoading = true;
      notifyListeners();

      await _service.logout();

      final activeId = AppPreferences.getActiveUserId();

      if (activeId == null) {
        // No multi-account state present — plain full wipe.
        await AppPreferences.clearAll();
        return false;
      }

      // Removes ONLY the active account. Other saved accounts are
      // untouched; if one exists it automatically becomes active.
      final nextAccount = await AppPreferences.removeAccount(activeId);
      return nextAccount != null;
    } catch (e) {
      debugPrint('Logout Error => $e');
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
