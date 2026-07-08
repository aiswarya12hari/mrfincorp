import 'dart:convert';

import '../../../../CORE/Config/api_config.dart';
import '../../../../CORE/Network/api_client.dart';

import '../model/collection_model.dart';

class CollectionService {
  Future<CollectionListResponseModel> getCollections() async {
    final response = await ApiClient.get(ApiConfig.collections);

    if (response.statusCode == 200) {
      return CollectionListResponseModel.fromJson(jsonDecode(response.body));
    }

    throw Exception(response.body);
  }
}