import 'package:flutter/material.dart';
import 'dart:async'; // Importing Timer
import '../mongo_service.dart';

class ResourceProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _resources = [];
  bool _isLoading = false;
  Timer? _timer; // Timer to fetch resources every 20 seconds

  List<Map<String, dynamic>> get resources => _resources;
  bool get isLoading => _isLoading;

  ResourceProvider() {
    fetchResources(); // Initial fetch when the provider is created
    _startAutoRefresh(); // Start auto-refresh when the provider is created
  }

  // Method to start the auto-refresh every 20 seconds
  void _startAutoRefresh() {
    _timer = Timer.periodic(Duration(seconds: 40), (timer) {
      fetchResources(forceRefresh: true); // Force refresh every 20 seconds
    });
  }

  // Fetch resources method (always fetch from DB, no skipping)
  Future<void> fetchResources({bool forceRefresh = false}) async {
    _isLoading = true;
    notifyListeners(); // Notify listeners that loading is in progress

    try {
      print('Fetching resources from MongoDB...');
      _resources =
          await MongoDatabase.fetchResources(); // Fetch fresh data from MongoDB
      print('Resources fetched successfully: ${_resources.length} items.');
    } catch (e) {
      print('Failed to load resources: $e');
    } finally {
      _isLoading = false;
      notifyListeners(); // Notify listeners that loading is complete
    }
  }

  // Method to manually refresh the resources
  void refreshResources() {
    print('Forcing resource refresh...');
    fetchResources(forceRefresh: true);
  }

  // Cancel the timer when the provider is disposed
  @override
  void dispose() {
    _timer?.cancel(); // Prevent memory leaks by canceling the timer
    super.dispose();
  }
}
