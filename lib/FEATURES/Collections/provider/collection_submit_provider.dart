import 'package:flutter/material.dart';

import '../data/model/collection_submit_model.dart';
import '../data/services/collection_submit_service.dart';

class CollectionSubmitProvider extends ChangeNotifier {
  final CollectionSubmitService _service = CollectionSubmitService();

  bool isLoading = false;
  String? errorMessage;

  Future<CollectionSubmitResponseModel?> submitCollection({
    required int assignmentId,
    required CollectionSubmitRequestModel data,
  }) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      return await _service.submitCollection(
        assignmentId: assignmentId,
        data: data,
      );
    } catch (e) {
      errorMessage = e.toString();
      debugPrint('COLLECTION SUBMIT ERROR => $errorMessage');
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}