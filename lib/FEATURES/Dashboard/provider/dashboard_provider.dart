import 'package:flutter/material.dart';
import 'package:mr_fincorp/FEATURES/Dashboard/data/models/dashboard_model.dart';

import '../../Loans/data/models/loan_model.dart';
import '../../Loans/data/services/loan_service.dart';

class DashboardProvider extends ChangeNotifier {
  final LoanService _service = LoanService();

  bool isLoading = false;
  String? errorMessage;
  DashboardModel? dashboard;

  List<LoanModel> recentLoans = [];

  Future<void> fetchDashboard() async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final response = await _service.getLoans(page: 1);

      dashboard = response.dashboard;

      recentLoans = response.recentLoans;
    } catch (e) {
      debugPrint('DASHBOARD ERROR => $e');
      errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;

      notifyListeners();
    }
  }
}
