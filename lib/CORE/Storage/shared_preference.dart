import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../FEATURES/Account/data/models/account_model.dart';

class AppPreferences {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userDataKey = 'user_data';

  // Multi-account storage
  static const String savedAccountsKey = 'saved_accounts';
  static const String activeUserIdKey = 'active_user_id';

  // ── Legacy single-account save (kept for compatibility, unused
  // by the new login flow but harmless if referenced elsewhere) ──
  static Future<void> saveLoginData({
    required String accessToken,
    required String refreshToken,
    required Map<String, dynamic> userData,
  }) async {
    await _prefs?.setString(accessTokenKey, accessToken);
    await _prefs?.setString(refreshTokenKey, refreshToken);
    await _prefs?.setString(userDataKey, jsonEncode(userData));
  }

  // ── Active-account mirror getters (unchanged signatures) ────
  static String? getAccessToken() => _prefs?.getString(accessTokenKey);

  static Future<void> saveAccessToken(String token) async {
    await _prefs?.setString(accessTokenKey, token);
  }

  static String? getRefreshToken() => _prefs?.getString(refreshTokenKey);

  static Map<String, dynamic>? getUserData() {
    final data = _prefs?.getString(userDataKey);
    if (data == null) return null;
    return jsonDecode(data);
  }

  static bool isLoggedIn() {
    final token = getAccessToken();
    return token != null && token.isNotEmpty;
  }

  // ── Full wipe (used when the last remaining account logs out,
  // or on unrecoverable session corruption) ──────────────────
  static Future<void> logout() async {
    await _prefs?.remove(accessTokenKey);
    await _prefs?.remove(refreshTokenKey);
    await _prefs?.remove(userDataKey);
  }

  static Future<void> clearAll() async {
    await _prefs?.clear();
  }

  // ══════════════════════════════════════════════════════════
  // MULTI-ACCOUNT API
  // ══════════════════════════════════════════════════════════

  static List<AccountModel> getSavedAccounts() {
    final raw = _prefs?.getString(savedAccountsKey);
    if (raw == null || raw.isEmpty) return [];
    final List decoded = jsonDecode(raw);
    return decoded
        .map((e) => AccountModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  static Future<void> _saveAccountsList(List<AccountModel> accounts) async {
    final raw = jsonEncode(accounts.map((a) => a.toJson()).toList());
    await _prefs?.setString(savedAccountsKey, raw);
  }

  static String? getActiveUserId() => _prefs?.getString(activeUserIdKey);

  static AccountModel? getActiveAccount() {
    final id = getActiveUserId();
    if (id == null) return null;
    final accounts = getSavedAccounts();
    final match = accounts.where((a) => a.userId == id);
    return match.isEmpty ? null : match.first;
  }

  /// Points the mirror keys (access/refresh/userData) + active_user_id
  /// at the given account. This is what ApiClient actually reads.
  static Future<void> _setActiveAccount(AccountModel account) async {
    await _prefs?.setString(accessTokenKey, account.accessToken);
    await _prefs?.setString(refreshTokenKey, account.refreshToken);
    await _prefs?.setString(userDataKey, jsonEncode(account.userData));
    await _prefs?.setString(activeUserIdKey, account.userId);
  }

  /// Used by BOTH a fresh login (no saved accounts yet) and "Add
  /// Account" (already have some) — identical operation either way.
  /// Matches an existing account by userId OR email so re-logging
  /// into the same account updates its tokens instead of duplicating.
  static Future<void> addOrUpdateAccount(AccountModel account) async {
    final accounts = getSavedAccounts();

    final index = accounts.indexWhere(
      (a) =>
          a.userId == account.userId ||
          a.email.toLowerCase() == account.email.toLowerCase(),
    );

    if (index >= 0) {
      accounts[index] = account;
    } else {
      accounts.add(account);
    }

    await _saveAccountsList(accounts);
    await _setActiveAccount(account);
  }

  /// Makes an already-saved account active. Caller should follow up
  /// with ApiClient.validateSession() to silently refresh an expired
  /// access token before using it.
  static Future<AccountModel?> switchAccount(String userId) async {
    final accounts = getSavedAccounts();
    final match = accounts.where((a) => a.userId == userId);
    if (match.isEmpty) return null;

    final account = match.first;
    await _setActiveAccount(account);
    return account;
  }

  /// Keeps saved_accounts in sync after ApiClient silently refreshes
  /// the active account's access token.
  static Future<void> updateActiveAccessToken(String newAccessToken) async {
    await _prefs?.setString(accessTokenKey, newAccessToken);

    final activeId = getActiveUserId();
    if (activeId == null) return;

    final accounts = getSavedAccounts();
    final index = accounts.indexWhere((a) => a.userId == activeId);
    if (index >= 0) {
      accounts[index] = accounts[index].copyWith(accessToken: newAccessToken);
      await _saveAccountsList(accounts);
    }
  }

  /// Removes ONE account. If it was the active one, another saved
  /// account (if any) automatically becomes active. Returns the new
  /// active account, or null if no accounts remain at all.
  static Future<AccountModel?> removeAccount(String userId) async {
    final accounts = getSavedAccounts();
    accounts.removeWhere((a) => a.userId == userId);
    await _saveAccountsList(accounts);

    final wasActive = getActiveUserId() == userId;
    if (!wasActive) {
      return getActiveAccount();
    }

    if (accounts.isNotEmpty) {
      final next = accounts.first;
      await _setActiveAccount(next);
      return next;
    }

    await clearAll();
    return null;
  }
}
