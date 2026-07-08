import 'dart:convert';

import '../../../../CORE/Config/api_config.dart';
import '../../../../CORE/Network/api_client.dart';

import '../model/collection_submit_model.dart';

class CollectionSubmitService {
  Future<CollectionSubmitResponseModel> submitCollection({
    required int assignmentId,
    required CollectionSubmitRequestModel data,
  }) async {
    final response = await ApiClient.post(
      ApiConfig.submitCollection(assignmentId),
      data.toJson(),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return CollectionSubmitResponseModel.fromJson(jsonDecode(response.body));
    }

    throw Exception(response.body);
  }
}