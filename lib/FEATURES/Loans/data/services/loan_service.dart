// import 'dart:convert';
// import 'package:flutter/material.dart';

// import '../../../../CORE/Config/api_config.dart';
// import '../../../../CORE/Network/api_client.dart';

// import '../models/loan_response_model.dart';

// class LoanService {
//   Future<LoanResponseModel> getLoans({
//     int page = 1,
//     String? status,
//     String? loanType,
//     String? loanId,
//     String? customerName,
//     String? loanMethod,
//     String? dateFrom,
//     String? dateTo,
//   }) async {
//     final query = <String, String>{'page': page.toString()};

//     if (status != null && status.isNotEmpty) {
//       query['status'] = status;
//     }

//     if (loanType != null && loanType.isNotEmpty) {
//       query['loan_type'] = loanType;
//     }

//     if (loanId != null && loanId.isNotEmpty) {
//       query['loan_id'] = loanId;
//     }

//     if (customerName != null && customerName.isNotEmpty) {
//       query['customer_name'] = customerName;
//     }

//     if (loanMethod != null && loanMethod.isNotEmpty) {
//       query['loan_method'] = loanMethod;
//     }

//     if (dateFrom != null && dateFrom.isNotEmpty) {
//       query['date_from'] = dateFrom;
//     }

//     if (dateTo != null && dateTo.isNotEmpty) {
//       query['date_to'] = dateTo;
//     }

//     final uri = Uri.parse(ApiConfig.loans).replace(queryParameters: query);
//     debugPrint('FILTER URL => $uri');

//     final response = await ApiClient.get(uri.toString());

//     if (response.statusCode == 200) {
//       return LoanResponseModel.fromJson(jsonDecode(response.body));
//     }

//     throw Exception(response.body);
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';

import '../../../../CORE/Config/api_config.dart';
import '../../../../CORE/Network/api_client.dart';

import '../models/loan_response_model.dart';

class LoanService {
  Future<LoanResponseModel> getLoans({
    int page = 1,
    String? status,
    String? loanType,
    String? loanId,
    String? customerName,
    String? loanMethod,
    String? dateFrom,
    String? dateTo,
  }) async {
    final query = <String, String>{
      'page': page.toString(),
    };

    if (status != null && status.isNotEmpty) {
      query['status'] = status;
    }

    if (loanType != null && loanType.isNotEmpty) {
      query['loan_type'] = loanType;
    }

    if (loanId != null && loanId.isNotEmpty) {
      query['loan_id'] = loanId;
    }

    if (customerName != null && customerName.isNotEmpty) {
      query['customer_name'] = customerName;
    }

    if (loanMethod != null && loanMethod.isNotEmpty) {
      query['loan_method'] = loanMethod;
    }

    if (dateFrom != null && dateFrom.isNotEmpty) {
      query['date_from'] = dateFrom;
    }

    if (dateTo != null && dateTo.isNotEmpty) {
      query['date_to'] = dateTo;
    }

    final uri = Uri.parse(
      ApiConfig.loans,
    ).replace(
      queryParameters: query,
    );

    debugPrint('LOAN URL => $uri');

    final response = await ApiClient.get(
      uri.toString(),
    );

    debugPrint(
      'LOAN STATUS => ${response.statusCode}',
    );

    if (response.statusCode == 200) {
      return LoanResponseModel.fromJson(
        jsonDecode(response.body),
      );
    }

    throw Exception(
      'Failed to fetch loans: ${response.body}',
    );
  }
}