import 'package:flutter/material.dart';

import '../data/model/collected_collection_model.dart';
import '../data/services/collected_list_service.dart';

class CollectedListProvider extends ChangeNotifier {
  final CollectedListService _service = CollectedListService();

  bool isLoading = false;
  String? errorMessage;

  List<CollectedCollectionModel> collectedItems = [];

  String? selectedStatus;
  String? selectedLoanType;
  String? selectedLoanMethod;
  String searchLoanId = '';
  String searchCustomer = '';
  String? selectedDateFrom;
  String? selectedDateTo;

  Future<void> fetchCollected() async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final response = await _service.getCollected(
        status: selectedStatus,
        loanType: selectedLoanType,
        loanMethod: selectedLoanMethod,
        loanId: searchLoanId,
        customerName: searchCustomer,
        dateFrom: selectedDateFrom,
        dateTo: selectedDateTo,
      );
      collectedItems = response.results;
    } catch (e) {
      errorMessage = e.toString();
      debugPrint('COLLECTED LIST ERROR => $errorMessage');
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

    await fetchCollected();
  }

  Future<void> resetFilter() async {
    selectedStatus = null;
    selectedLoanType = null;
    selectedLoanMethod = null;
    searchLoanId = '';
    searchCustomer = '';
    selectedDateFrom = null;
    selectedDateTo = null;

    await fetchCollected();
  }
}
