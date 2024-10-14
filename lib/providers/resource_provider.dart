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

  Future<void> fetchResources() async {
    _isLoading = true;
    notifyListeners();

    try {
      _resources = await MongoDatabase.fetchResources();
    } catch (e) {
      print("Failed to load resources: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  void refreshResources() {
    fetchResources();
  }
}
