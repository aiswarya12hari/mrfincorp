import 'package:flutter/material.dart';

import '../../../CORE/Network/api_client.dart';
import '../../../CORE/Storage/shared_preference.dart';
import 'package:mr_fincorp/FEATURES/Account/data/models/account_model.dart';

enum SwitchResult { success, notFound, invalidSession, error }

class AccountSwitcherProvider extends ChangeNotifier {
  List<AccountModel> accounts = [];
  bool isSwitching = false;
  String? errorMessage;

  String? get activeUserId => AppPreferences.getActiveUserId();

  void loadAccounts() {
    accounts = AppPreferences.getSavedAccounts();
    notifyListeners();
  }

  /// Switches to [userId], then validates the session — if the stored
  /// access token has expired, ApiClient.validateSession() silently
  /// calls the Refresh Token API before we consider it ready.
  Future<SwitchResult> switchTo(String userId) async {
    isSwitching = true;
    errorMessage = null;
    notifyListeners();

    try {
      final account = await AppPreferences.switchAccount(userId);
      if (account == null) {
        errorMessage = 'Account not found';
        return SwitchResult.notFound;
      }

      final status = await ApiClient.validateSession();

      if (status == SessionStatus.invalid) {
        // Both the access AND refresh token are dead for this account.
        // No point keeping it around — drop it.
        await AppPreferences.removeAccount(userId);
        loadAccounts();
        errorMessage = 'This account\'s session has expired. Please log in again.';
        return SwitchResult.invalidSession;
      }

      // valid OR networkError (offline entry, same as splash screen) → proceed
      loadAccounts();
      return SwitchResult.success;
    } catch (e) {
      debugPrint('AccountSwitcherProvider: switch error => $e');
      errorMessage = 'Something went wrong. Please try again.';
      return SwitchResult.error;
    } finally {
      isSwitching = false;
      notifyListeners();
    }
  }
}