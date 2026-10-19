import 'package:flutter/material.dart';

import '../data/models/loan_model.dart';
import '../data/services/loan_service.dart';

class LoanProvider extends ChangeNotifier {
  final LoanService _service = LoanService();

  bool isLoading = false;
  String? errorMessage;

  List<LoanModel> loans = [];

  /// Current selected page
  int currentPage = 1;

  /// Total number of records from API
  int totalCount = 0;

  /// Number of records returned per page
  int pageSize = 10;

  /// Whether API has next page
  bool hasMore = false;

  /// Whether API has previous page
  bool hasPrevious = false;

  String? selectedStatus;
  String? selectedLoanType;
  String? selectedLoanMethod;

  String searchLoanId = '';
  String searchCustomer = '';

  String? selectedDateFrom;
  String? selectedDateTo;

  int _currentRequestId = 0;

  /// Total pages calculated from count and page size
  int get totalPages {
    if (totalCount == 0) {
      return 1;
    }

    return (totalCount / pageSize).ceil();
  }

  /// Initial fetch / refresh
  Future<void> fetchLoans() async {
    currentPage = 1;
    loans.clear();
    await fetchLoansPage(1, showLoader: true);
  }

  /// Fetch a specific page
  Future<void> fetchLoansPage(int page, {bool showLoader = true}) async {
    final requestId = ++_currentRequestId;

    try {
      if (showLoader) {
        isLoading = true;
        errorMessage = null;
        notifyListeners();
      }

      final response = await _service.getLoans(
        page: page,
        status: selectedStatus,
        loanType: selectedLoanType,
        loanId: searchLoanId,
        customerName: searchCustomer,
        loanMethod: selectedLoanMethod,
        dateFrom: selectedDateFrom,
        dateTo: selectedDateTo,
      );

      // Check if this response belongs to the latest initiated request
      if (requestId != _currentRequestId) return;

      /// Replace current page data
      loans = response.results;

      /// Update pagination information
      currentPage = page;
      totalCount = response.count;
      hasMore = response.next != null;
      hasPrevious = response.previous != null;
      errorMessage = null;
    } catch (e) {
      if (requestId != _currentRequestId) return;
      errorMessage = e.toString();
      debugPrint('LOAN PAGINATION ERROR => $e');
    } finally {
      if (requestId == _currentRequestId) {
        if (showLoader) {
          isLoading = false;
        }
        notifyListeners();
      }
    }
  }

  /// Go to next page
  Future<void> nextPage() async {
    if (isLoading) return;
    if (!hasMore) return;
    if (currentPage >= totalPages) return;

    await fetchLoansPage(currentPage + 1, showLoader: true);
  }

  /// Go to previous page
  Future<void> previousPage() async {
    if (isLoading) return;
    if (!hasPrevious) return;
    if (currentPage <= 1) return;

    await fetchLoansPage(currentPage - 1, showLoader: true);
  }

  /// Go directly to a page
  Future<void> goToPage(int page) async {
    if (isLoading) return;
    if (page < 1 || page > totalPages) return;
    if (page == currentPage) return;

    await fetchLoansPage(page, showLoader: true);
  }

  /// Apply filters
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
    await fetchLoans();
  }

  /// Reset all filters
  Future<void> resetFilter() async {
    selectedStatus = null;
    selectedLoanType = null;
    selectedLoanMethod = null;

    selectedDateFrom = null;
    selectedDateTo = null;

    searchLoanId = '';
    searchCustomer = '';

    currentPage = 1;
    await fetchLoans();
  }

  /// Change status tab (All, Pending, Verified)
  Future<void> changeStatusTab(String? status) async {
    selectedStatus = (status != null && status.isNotEmpty) ? status : null;

    /// Reset search when changing status tab
    searchLoanId = '';
    searchCustomer = '';

    /// Always go back to first page and fetch fresh data
    currentPage = 1;
    await fetchLoans();
  }

  /// Synchronize state immediately after a loan verification
  void onLoanVerified({
    required String loanId,
    String? status,
    LoanModel? updatedLoan,
  }) {
    final newStatus = status ?? 'FIELDSTAFF_VERIFIED';

    // 1. If currently showing Pending list, remove immediately
    if (selectedStatus == 'VERIFICATION_PENDING') {
      loans.removeWhere((l) => l.loanId == loanId);
      if (totalCount > 0) totalCount--;
      notifyListeners();
    }
    // 2. If currently showing Verified list, add or update immediately
    else if (selectedStatus == 'FIELDSTAFF_VERIFIED') {
      final index = loans.indexWhere((l) => l.loanId == loanId);
      if (index != -1) {
        loans[index] = loans[index].copyWith(status: newStatus);
      } else if (updatedLoan != null) {
        loans.insert(0, updatedLoan);
        totalCount++;
      }
      notifyListeners();
    }
    // 3. If currently showing All list, update status chip
    else {
      final index = loans.indexWhere((l) => l.loanId == loanId);
      if (index != -1) {
        loans[index] = loans[index].copyWith(status: newStatus);
        notifyListeners();
      }
    }

    // 4. Trigger background fetch to ensure server state is 100% synced
    fetchLoansPage(1, showLoader: false);
  }
}
