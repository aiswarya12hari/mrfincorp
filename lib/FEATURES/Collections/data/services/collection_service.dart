// import 'dart:convert';

// import '../../../../CORE/Config/api_config.dart';
// import '../../../../CORE/Network/api_client.dart';

// import '../model/collection_model.dart';

// class CollectionService {
//   Future<CollectionListResponseModel> getCollections() async {
//     final response = await ApiClient.get(ApiConfig.collections);

//     if (response.statusCode == 200) {
//       return CollectionListResponseModel.fromJson(jsonDecode(response.body));
//     }

//     throw Exception(response.body);
//   }
// }


import 'dart:convert';
import 'package:flutter/material.dart';

import '../../../../CORE/Config/api_config.dart';
import '../../../../CORE/Network/api_client.dart';

import '../model/collection_model.dart';

class CollectionService {
  Future<CollectionListResponseModel> getCollections({
    String? status,
    String? loanType,
    String? loanMethod,
    String? loanId,
    String? customerName,
    String? dateFrom,
    String? dateTo,
  }) async {
    final query = <String, String>{};

    if (status != null && status.isNotEmpty) query['status'] = status;
    if (loanType != null && loanType.isNotEmpty) query['loan_type'] = loanType;
    if (loanMethod != null && loanMethod.isNotEmpty) query['loan_method'] = loanMethod;
    if (loanId != null && loanId.isNotEmpty) query['loan_id'] = loanId;
    if (customerName != null && customerName.isNotEmpty) query['customer_name'] = customerName;
    if (dateFrom != null && dateFrom.isNotEmpty) query['date_from'] = dateFrom;
    if (dateTo != null && dateTo.isNotEmpty) query['date_to'] = dateTo;

    final uri = Uri.parse(ApiConfig.collections)
        .replace(queryParameters: query.isEmpty ? null : query);
    debugPrint('COLLECTION FILTER URL => $uri');

    final response = await ApiClient.get(uri.toString());

    if (response.statusCode == 200) {
      return CollectionListResponseModel.fromJson(jsonDecode(response.body));
    }

    throw Exception(response.body);
  }
}