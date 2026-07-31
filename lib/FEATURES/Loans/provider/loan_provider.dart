// import 'package:flutter/material.dart';
// import '../data/models/loan_model.dart';
// import '../data/services/loan_service.dart';

// class LoanProvider extends ChangeNotifier {
//   final LoanService _service = LoanService();

//   bool isLoading = false;
//   bool isLoadingMore = false;

//   List<LoanModel> loans = [];

//   int currentPage = 1;
//   bool hasMore = true;

//   String? selectedStatus;
//   String? selectedLoanType;
//   String? selectedLoanMethod;

//   String searchLoanId = '';
//   String searchCustomer = '';
//   String? selectedDateFrom;
//   String? selectedDateTo;

//   Future<void> fetchLoans() async {
//     try {
//       isLoading = true;
//       notifyListeners();

//       final response = await _service.getLoans(
//         page: 1,
//         status: selectedStatus,
//         loanType: selectedLoanType,
//         loanId: searchLoanId,
//         customerName: searchCustomer,
//         loanMethod: selectedLoanMethod,
//         dateFrom: selectedDateFrom,
//         dateTo: selectedDateTo,
//       );

//       loans = response.results;

//       currentPage = 1;
//       hasMore = response.next != null;
//     } catch (e) {
//       debugPrint('LOAN ERROR => $e');
//     } finally {
//       isLoading = false;
//       notifyListeners();
//     }
//   }

//   Future<void> loadMoreLoans() async {
//     if (!hasMore || isLoadingMore) return;

//     try {
//       isLoadingMore = true;
//       notifyListeners();

//       final response = await _service.getLoans(
//         page: currentPage + 1,
//         status: selectedStatus,
//         loanType: selectedLoanType,
//         loanId: searchLoanId,
//         customerName: searchCustomer,
//         loanMethod: selectedLoanMethod,
//         dateFrom: selectedDateFrom,
//         dateTo: selectedDateTo,
//       );

//       loans.addAll(response.results);

//       currentPage++;

//       hasMore = response.next != null;
//     } finally {
//       isLoadingMore = false;
//       notifyListeners();
//     }
//   }

//   Future<void> applyFilter({
//     String? status,
//     String? loanType,
//     String? loanId,
//     String? customerName,
//     String? loanMethod,
//     String? dateFrom,
//     String? dateTo,
//   }) async {
//     selectedStatus = status;
//     selectedLoanType = loanType;
//     selectedLoanMethod = loanMethod;

//     selectedDateFrom = dateFrom;
//     selectedDateTo = dateTo;
//     searchLoanId = loanId ?? '';
//     searchCustomer = customerName ?? '';

//     currentPage = 1;
//     loans.clear();

//     await fetchLoans();
//   }

//   Future<void> resetFilter() async {
//     selectedStatus = null;
//     selectedLoanType = null;
//     selectedLoanMethod = null;
//     selectedDateFrom = null;
//     selectedDateTo = null;
//     searchLoanId = '';
//     searchCustomer = '';

//     await fetchLoans();
//   }

//   // Future<void> changeStatusTab(String? status) async {
//   //   selectedStatus = status;

//   //   currentPage = 1;

//   //   loans.clear();

//   //   await fetchLoans();
//   // }

//   Future<void> changeStatusTab(String? status) async {
//     selectedStatus = status;
//     searchLoanId = '';
//     searchCustomer = '';

//     currentPage = 1;

//     loans.clear();

//     await fetchLoans();
//   }
// }

import 'package:flutter/material.dart';

import '../data/models/loan_model.dart';
import '../data/services/loan_service.dart';

class LoanProvider extends ChangeNotifier {
  final LoanService _service = LoanService();

  bool isLoading = false;

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

  /// Total pages calculated from count and page size
  int get totalPages {
    if (totalCount == 0) {
      return 1;
    }

    return (totalCount / pageSize).ceil();
  }

  /// Initial fetch / refresh
  Future<void> fetchLoans() async {
    await fetchLoansPage(1);
  }

  /// Fetch a specific page
  Future<void> fetchLoansPage(
    int page, {
    bool showLoader = true,
  }) async {
    if (isLoading) return;

    try {
      if (showLoader) {
        isLoading = true;
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

      /// Replace current page data
      loans = response.results;

      /// Update pagination information
      currentPage = page;

      totalCount = response.count;

      hasMore = response.next != null;

      hasPrevious = response.previous != null;

      notifyListeners();
    } catch (e) {
      debugPrint(
        'LOAN PAGINATION ERROR => $e',
      );
    } finally {
      if (showLoader) {
        isLoading = false;
        notifyListeners();
      }
    }
  }

  /// Go to next page
  Future<void> nextPage() async {
    if (isLoading) return;

    if (!hasMore) return;

    if (currentPage >= totalPages) return;

    await fetchLoansPage(
      currentPage + 1,
    );
  }

  /// Go to previous page
  Future<void> previousPage() async {
    if (isLoading) return;

    if (!hasPrevious) return;

    if (currentPage <= 1) return;

    await fetchLoansPage(
      currentPage - 1,
    );
  }

  /// Go directly to a page
  Future<void> goToPage(
    int page,
  ) async {
    if (isLoading) return;

    if (page < 1) return;

    if (page > totalPages) return;

    if (page == currentPage) return;

    await fetchLoansPage(
      page,
    );
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

    /// Always reset to first page
    currentPage = 1;

    loans.clear();

    notifyListeners();

    await fetchLoansPage(1);
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

    loans.clear();

    notifyListeners();

    await fetchLoansPage(1);
  }

  /// Change status tab
  Future<void> changeStatusTab(
    String? status,
  ) async {
    selectedStatus = status;

    /// Reset search when changing status
    searchLoanId = '';
    searchCustomer = '';

    /// Always go back to first page
    currentPage = 1;

    loans.clear();

    notifyListeners();

    await fetchLoansPage(1);
  }
}