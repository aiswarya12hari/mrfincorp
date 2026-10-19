import 'dart:convert';
import 'package:flutter/material.dart';

import '../../../../CORE/Config/api_config.dart';
import '../../../../CORE/Network/api_client.dart';

import '../model/collected_collection_model.dart';

class CollectedListService {
  Future<CollectedListResponseModel> getCollected({
    int page = 1,
    String? status,
    String? loanType,
    String? loanMethod,
    String? loanId,
    String? customerName,
    String? dateFrom,
    String? dateTo,
  }) async {
    final query = <String, String>{'page': page.toString()};

    if (status != null && status.isNotEmpty) {
      query['status'] = status;
    }

    if (loanType != null && loanType.isNotEmpty) {
      query['loan_type'] = loanType;
    }

    if (loanMethod != null && loanMethod.isNotEmpty) {
      query['loan_method'] = loanMethod;
    }

    if (loanId != null && loanId.isNotEmpty) {
      query['loan_id'] = loanId;
    }

    if (customerName != null && customerName.isNotEmpty) {
      query['customer_name'] = customerName;
    }

    if (dateFrom != null && dateFrom.isNotEmpty) {
      query['date_from'] = dateFrom;
    }

    if (dateTo != null && dateTo.isNotEmpty) {
      query['date_to'] = dateTo;
    }

    final uri = Uri.parse(
      ApiConfig.collectedCollections,
    ).replace(queryParameters: query);

    debugPrint('COLLECTED URL => $uri');

    final response = await ApiClient.get(uri.toString());

    debugPrint('COLLECTED STATUS => ${response.statusCode}');

    if (response.statusCode == 200) {
      return CollectedListResponseModel.fromJson(jsonDecode(response.body));
    }

    throw Exception(response.body);
  }
}
