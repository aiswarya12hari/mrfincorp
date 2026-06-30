import 'package:flutter/material.dart';

import '../data/models/profile_model.dart';
import '../data/services/profile_service.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileService _service = ProfileService();

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  ProfileModel? profile;

  String? errorMessage;

  Future<void> getProfile() async {
    try {
      _isLoading = true;
      errorMessage = null;

      notifyListeners();

      profile = await _service.getProfile();

      debugPrint(
        'PROFILE LOADED => ${profile?.fieldStaffName}',
      );
    } catch (e) {
      errorMessage = e.toString();

      debugPrint(
        'PROFILE ERROR => $errorMessage',
      );
    } finally {
      _isLoading = false;

      notifyListeners();
    }
  }
}