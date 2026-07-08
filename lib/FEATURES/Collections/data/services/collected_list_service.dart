import 'dart:convert';

import '../../../../CORE/Config/api_config.dart';
import '../../../../CORE/Network/api_client.dart';

import '../model/collected_collection_model.dart';

class CollectedListService {
  Future<CollectedListResponseModel> getCollected() async {
    final response = await ApiClient.get(ApiConfig.collectedCollections);

    if (response.statusCode == 200) {
      return CollectedListResponseModel.fromJson(jsonDecode(response.body));
    }

    throw Exception(response.body);
  }
}