import 'package:flutter/material.dart';

import '../data/model/collection_model.dart';
import '../data/services/collection_service.dart';

class CollectionListProvider extends ChangeNotifier {
  final CollectionService _service = CollectionService();

  bool isLoading = false;
  String? errorMessage;

  List<CollectionModel> collections = [];

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

  int _currentRequestId = 0;

  /// Total pages
  int get totalPages {
    if (totalCount == 0) {
      return 1;
    }

    return (totalCount / pageSize).ceil();
  }

  /// Initial fetch / refresh
  Future<void> fetchCollections() async {
    currentPage = 1;
    collections.clear();
    await fetchCollectionsPage(1, showLoader: true);
  }

  /// Fetch specific page
  Future<void> fetchCollectionsPage(int page, {bool showLoader = true}) async {
    final requestId = ++_currentRequestId;

    try {
      if (showLoader) {
        isLoading = true;
        errorMessage = null;
        notifyListeners();
      }

      final response = await _service.getCollections(
        page: page,
        status: selectedStatus,
        loanType: selectedLoanType,
        loanMethod: selectedLoanMethod,
        loanId: searchLoanId,
        customerName: searchCustomer,
        dateFrom: selectedDateFrom,
        dateTo: selectedDateTo,
      );

      // Check if this response belongs to the latest initiated request
      if (requestId != _currentRequestId) return;

      /// Replace current page
      collections = response.results;

      /// Update pagination
      currentPage = page;
      totalCount = response.count;
      hasMore = response.next != null;
      hasPrevious = response.previous != null;
      errorMessage = null;
    } catch (e) {
      if (requestId != _currentRequestId) return;
      errorMessage = e.toString();
      debugPrint('COLLECTION LIST ERROR => $errorMessage');
    } finally {
      if (requestId == _currentRequestId) {
        if (showLoader) {
          isLoading = false;
        }
        notifyListeners();
      }
    }
  }

  /// Go to specific page
  Future<void> goToPage(int page) async {
    if (isLoading) return;
    if (page < 1 || page > totalPages) return;
    if (page == currentPage) return;

    await fetchCollectionsPage(page, showLoader: true);
  }

  /// Next page
  Future<void> nextPage() async {
    if (isLoading) return;
    if (!hasMore) return;
    if (currentPage >= totalPages) return;

    await fetchCollectionsPage(currentPage + 1, showLoader: true);
  }

  /// Previous page
  Future<void> previousPage() async {
    if (isLoading) return;
    if (!hasPrevious) return;
    if (currentPage <= 1) return;

    await fetchCollectionsPage(currentPage - 1, showLoader: true);
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
    selectedLoanType = loanType;
    selectedLoanMethod = loanMethod;
    searchLoanId = loanId ?? '';
    searchCustomer = customerName ?? '';
    selectedDateFrom = dateFrom;
    selectedDateTo = dateTo;

    currentPage = 1;
    await fetchCollections();
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
    await fetchCollections();
  }

  /// Immediately remove collected item from outstanding list and refresh in background
  void onCollectionSubmitted(int assignmentId) {
    collections.removeWhere((item) => item.assignmentId == assignmentId);
    if (totalCount > 0) totalCount--;
    notifyListeners();

    // Trigger fresh fetch in background
    fetchCollectionsPage(1, showLoader: false);
  }
}
