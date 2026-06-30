import 'package:flutter/material.dart';
import '../data/models/loan_model.dart';
import '../data/services/loan_service.dart';

class LoanProvider extends ChangeNotifier {
  final LoanService _service = LoanService();

  bool isLoading = false;
  bool isLoadingMore = false;

  List<LoanModel> loans = [];

  int currentPage = 1;
  bool hasMore = true;

  String? selectedStatus;
  String? selectedLoanType;
  String? selectedLoanMethod;

  String searchLoanId = '';
  String searchCustomer = '';
  String? selectedDateFrom;
  String? selectedDateTo;

  Future<void> fetchLoans() async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await _service.getLoans(
        page: 1,
        status: selectedStatus,
        loanType: selectedLoanType,
        loanId: searchLoanId,
        customerName: searchCustomer,
        loanMethod: selectedLoanMethod,
        dateFrom: selectedDateFrom,
        dateTo: selectedDateTo,
      );

      loans = response.results;

      currentPage = 1;
      hasMore = response.next != null;
    } catch (e) {
      debugPrint('LOAN ERROR => $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMoreLoans() async {
    if (!hasMore || isLoadingMore) return;

    try {
      isLoadingMore = true;
      notifyListeners();

      final response = await _service.getLoans(
        page: currentPage + 1,
        status: selectedStatus,
        loanType: selectedLoanType,
        loanId: searchLoanId,
        customerName: searchCustomer,
        loanMethod: selectedLoanMethod,
        dateFrom: selectedDateFrom,
        dateTo: selectedDateTo,
      );

      loans.addAll(response.results);

      currentPage++;

      hasMore = response.next != null;
    } finally {
      isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<void> applyFilter({
    String? status,
    String? loanType,
    String? loanId,
    String? customerName,
    String? loanMethod,
    String? dateFrom,
    String? dateTo,
  }) async {
    selectedStatus = status;
    selectedLoanType = loanType;
    selectedLoanMethod = loanMethod;

    selectedDateFrom = dateFrom;
    selectedDateTo = dateTo;
    searchLoanId = loanId ?? '';
    searchCustomer = customerName ?? '';

    currentPage = 1;
    loans.clear();

    await fetchLoans();
  }

  Future<void> resetFilter() async {
    selectedStatus = null;
    selectedLoanType = null;
    selectedLoanMethod = null;
    selectedDateFrom = null;
    selectedDateTo = null;
    searchLoanId = '';
    searchCustomer = '';

    await fetchLoans();
  }

  Future<void> changeStatusTab(String? status) async {
    selectedStatus = status;

    currentPage = 1;

    loans.clear();

    await fetchLoans();
  }
}
