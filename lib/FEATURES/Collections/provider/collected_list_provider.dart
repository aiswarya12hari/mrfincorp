import 'package:flutter/material.dart';

import '../data/model/collected_collection_model.dart';
import '../data/services/collected_list_service.dart';

class CollectedListProvider extends ChangeNotifier {
  final CollectedListService _service = CollectedListService();

  bool isLoading = false;
  String? errorMessage;

  List<CollectedCollectionModel> collectedItems = [];

  Future<void> fetchCollected() async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final response = await _service.getCollected();
      collectedItems = response.results;
    } catch (e) {
      errorMessage = e.toString();
      debugPrint('COLLECTED LIST ERROR => $errorMessage');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}