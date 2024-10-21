import 'package:flutter/material.dart';
import '../mongo_service.dart';

class ResourceProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _resources = [];
  bool _isLoading = true;

  List<Map<String, dynamic>> get resources => _resources;
  bool get isLoading => _isLoading;

  ResourceProvider() {
    fetchResources();
  }

  Future<void> fetchResources({bool forceRefresh = false}) async {
    if (_resources.isNotEmpty && !forceRefresh) {
      print('Resources already loaded, skipping fetch.');
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      print('Fetching resources from MongoDB...');
      _resources = await MongoDatabase.fetchResources();
      print('Resources fetched successfully: ${_resources.length} items.');
    } catch (e) {
      print('Failed to load resources: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void refreshResources() {
    print('Forcing resource refresh...');
    fetchResources(forceRefresh: true);
  }
}
