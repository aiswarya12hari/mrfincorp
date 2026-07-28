import 'package:flutter/material.dart';

import '../data/model/collection_model.dart';
import '../data/services/collection_service.dart';

class CollectionListProvider extends ChangeNotifier {
  final CollectionService _service = CollectionService();

  bool isLoading = false;
  String? errorMessage;

  List<CollectionModel> collections = [];

  String? selectedStatus;
  String? selectedLoanType;
  String? selectedLoanMethod;
  String searchLoanId = '';
  String searchCustomer = '';
  String? selectedDateFrom;
  String? selectedDateTo;

  Future<void> fetchCollections() async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final response = await _service.getCollections(
        status: selectedStatus,
        loanType: selectedLoanType,
        loanMethod: selectedLoanMethod,
        loanId: searchLoanId,
        customerName: searchCustomer,
        dateFrom: selectedDateFrom,
        dateTo: selectedDateTo,
      );
      collections = response.results;
    } catch (e) {
      errorMessage = e.toString();
      debugPrint('COLLECTION LIST ERROR => $errorMessage');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

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

    await fetchCollections();
  }

  Future<void> resetFilter() async {
    selectedStatus = null;
    selectedLoanType = null;
    selectedLoanMethod = null;
    searchLoanId = '';
    searchCustomer = '';
    selectedDateFrom = null;
    selectedDateTo = null;

    await fetchCollections();
  }
}
