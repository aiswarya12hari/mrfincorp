// import 'package:flutter/material.dart';

// import '../data/model/collected_collection_model.dart';
// import '../data/services/collected_list_service.dart';

// class CollectedListProvider extends ChangeNotifier {
//   final CollectedListService _service = CollectedListService();

//   bool isLoading = false;
//   String? errorMessage;

//   List<CollectedCollectionModel> collectedItems = [];

//   String? selectedStatus;
//   String? selectedLoanType;
//   String? selectedLoanMethod;
//   String searchLoanId = '';
//   String searchCustomer = '';
//   String? selectedDateFrom;
//   String? selectedDateTo;

//   Future<void> fetchCollected() async {
//     try {
//       isLoading = true;
//       errorMessage = null;
//       notifyListeners();

//       final response = await _service.getCollected(
//         status: selectedStatus,
//         loanType: selectedLoanType,
//         loanMethod: selectedLoanMethod,
//         loanId: searchLoanId,
//         customerName: searchCustomer,
//         dateFrom: selectedDateFrom,
//         dateTo: selectedDateTo,
//       );
//       collectedItems = response.results;
//     } catch (e) {
//       errorMessage = e.toString();
//       debugPrint('COLLECTED LIST ERROR => $errorMessage');
//     } finally {
//       isLoading = false;
//       notifyListeners();
//     }
//   }

//   Future<void> applyFilter({
//     String? status,
//     String? loanType,
//     String? loanMethod,
//     String? loanId,
//     String? customerName,
//     String? dateFrom,
//     String? dateTo,
//   }) async {
//     selectedStatus = status;
//     selectedLoanType = loanType;
//     selectedLoanMethod = loanMethod;
//     searchLoanId = loanId ?? '';
//     searchCustomer = customerName ?? '';
//     selectedDateFrom = dateFrom;
//     selectedDateTo = dateTo;

//     await fetchCollected();
//   }

//   Future<void> resetFilter() async {
//     selectedStatus = null;
//     selectedLoanType = null;
//     selectedLoanMethod = null;
//     searchLoanId = '';
//     searchCustomer = '';
//     selectedDateFrom = null;
//     selectedDateTo = null;

//     await fetchCollected();
//   }
// }

import 'package:flutter/material.dart';

import '../data/model/collected_collection_model.dart';
import '../data/services/collected_list_service.dart';

class CollectedListProvider
    extends ChangeNotifier {
  final CollectedListService _service =
      CollectedListService();

  bool isLoading = false;

  String? errorMessage;

  List<CollectedCollectionModel>
      collectedItems = [];

  /// Pagination
  int currentPage = 1;

  int totalCount = 0;

  int pageSize = 10;

  bool hasMore = false;

  bool hasPrevious = false;

  /// Filters
  String? selectedStatus;

  String? selectedLoanType;

  String? selectedLoanMethod;

  String searchLoanId = '';

  String searchCustomer = '';

  String? selectedDateFrom;

  String? selectedDateTo;

  /// Total pages
  int get totalPages {
    if (totalCount == 0) {
      return 1;
    }

    return (totalCount / pageSize).ceil();
  }

  /// Initial fetch
  Future<void> fetchCollected() async {
    await fetchCollectedPage(1);
  }

  /// Fetch specific page
  Future<void> fetchCollectedPage(
    int page, {
    bool showLoader = true,
  }) async {
    if (isLoading) return;

    try {
      if (showLoader) {
        isLoading = true;
        errorMessage = null;
        notifyListeners();
      }

      final response =
          await _service.getCollected(
        page: page,
        status: selectedStatus,
        loanType: selectedLoanType,
        loanMethod: selectedLoanMethod,
        loanId: searchLoanId,
        customerName: searchCustomer,
        dateFrom: selectedDateFrom,
        dateTo: selectedDateTo,
      );

      /// Replace current page
      collectedItems =
          response.results;

      /// Update pagination
      currentPage = page;

      totalCount =
          response.count;

      hasMore =
          response.next != null;

      hasPrevious =
          response.previous != null;

      notifyListeners();
    } catch (e) {
      errorMessage =
          e.toString();

      debugPrint(
        'COLLECTED LIST ERROR => $errorMessage',
      );
    } finally {
      if (showLoader) {
        isLoading = false;
        notifyListeners();
      }
    }
  }

  /// Go to specific page
  Future<void> goToPage(
    int page,
  ) async {
    if (isLoading) return;

    if (page < 1 ||
        page > totalPages) {
      return;
    }

    if (page == currentPage) {
      return;
    }

    await fetchCollectedPage(
      page,
    );
  }

  /// Next page
  Future<void> nextPage() async {
    if (isLoading) return;

    if (!hasMore) return;

    if (currentPage >= totalPages) {
      return;
    }

    await fetchCollectedPage(
      currentPage + 1,
    );
  }

  /// Previous page
  Future<void> previousPage() async {
    if (isLoading) return;

    if (!hasPrevious) return;

    if (currentPage <= 1) {
      return;
    }

    await fetchCollectedPage(
      currentPage - 1,
    );
  }

  /// Apply filter
  Future<void> applyFilter({
    String? status,
    String? loanType,
    String? loanMethod,
    String? loanId,
    String? customerName,
    String? dateFrom,
    String? dateTo,
  }) async {
    selectedStatus = status;

    selectedLoanType =
        loanType;

    selectedLoanMethod =
        loanMethod;

    searchLoanId =
        loanId ?? '';

    searchCustomer =
        customerName ?? '';

    selectedDateFrom =
        dateFrom;

    selectedDateTo =
        dateTo;

    /// Reset to first page
    currentPage = 1;

    collectedItems.clear();

    notifyListeners();

    await fetchCollectedPage(
      1,
    );
  }

  /// Reset filters
  Future<void> resetFilter() async {
    selectedStatus = null;

    selectedLoanType = null;

    selectedLoanMethod = null;

    searchLoanId = '';

    searchCustomer = '';

    selectedDateFrom = null;

    selectedDateTo = null;

    currentPage = 1;

    collectedItems.clear();

    notifyListeners();

    await fetchCollectedPage(
      1,
    );
  }
}