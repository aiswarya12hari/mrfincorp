import 'package:flutter/material.dart';

class LoanFilterProvider extends ChangeNotifier {
  String? status;
  String? loanType;

  String loanId = '';
  String customerName = '';

  DateTime? fromDate;
  DateTime? toDate;

  void reset() {
    status = null;
    loanType = null;

    loanId = '';
    customerName = '';

    fromDate = null;
    toDate = null;

    notifyListeners();
  }
}