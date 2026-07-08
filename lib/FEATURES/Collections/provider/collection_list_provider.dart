import 'package:flutter/material.dart';

import '../data/model/collection_model.dart';
import '../data/services/collection_service.dart';

class CollectionListProvider extends ChangeNotifier {
  final CollectionService _service = CollectionService();

  bool isLoading = false;
  String? errorMessage;

  List<CollectionModel> collections = [];

  Future<void> fetchCollections() async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final response = await _service.getCollections();
      collections = response.results;
    } catch (e) {
      errorMessage = e.toString();
      debugPrint('COLLECTION LIST ERROR => $errorMessage');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}