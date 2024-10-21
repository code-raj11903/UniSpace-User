import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../orders/cart_page.dart';
import '../account/profile_page.dart';
import '../orders/order_history_page.dart';
import '../providers/resource_provider.dart';
import 'resource_list_widget.dart';

class HomePage extends StatefulWidget {
  final Map<String, dynamic> user;
  final bool refresh; // Add a refresh parameter

  const HomePage({super.key, required this.user, this.refresh = false});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? userId;
  String searchQuery = '';
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _persistLogin();
    final dynamic objectId = widget.user['id'];
    userId =
        objectId.toString().replaceAll('ObjectId("', '').replaceAll('")', '');
    print('HomePage initialized with user: ${widget.user}');

    if (widget.refresh) {
      _fetchResources(); // Refresh the homepage if the refresh flag is true
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchResources();
  }

  Future<void> _fetchResources() async {
    try {
      print('Fetching resources...');
      await Provider.of<ResourceProvider>(context, listen: false)
          .fetchResources(
              forceRefresh:
                  widget.refresh); // Fetch resources based on the refresh flag
      print('Resources fetched successfully.');
    } catch (e) {
      print('Error fetching resources: $e');
    }
  }

  Future<void> _persistLogin() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      print('Login state persisted in SharedPreferences');
    } catch (e) {
      print('Error persisting login state: $e');
    }
  }

  Future<bool> _onWillPop() async {
    if (_selectedIndex == 0) {
      return true; // Exit app only if user is on Home tab
    } else {
      setState(() {
        _selectedIndex = 0; // Go back to Home tab
      });
      return false;
    }
  }

  void onSearchChanged(String query) {
    setState(() {
      searchQuery = query;
      print('Search query updated: $query');
    });
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;

    setState(() {
      _selectedIndex = index;
    });
    final dynamic objectId = widget.user['id'];
    final userId =
        objectId.toString().replaceAll('ObjectId("', '').replaceAll('")', '');

    if (userId.isEmpty) {
      print('Error: userId is null or empty');
      return;
    }

    print('Navigating with userId: $userId');
    switch (index) {
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => CartPage(userId: userId, user: widget.user),
          ),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => OrderHistoryPage(userId: widget.user),
          ),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ProfilePage(user: widget.user),
          ),
        );
        break;
      default:
        print('Unknown navigation index: $index');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop, // Restrict back button functionality
      child: Scaffold(
        appBar: AppBar(
          title: TextField(
            onChanged: onSearchChanged,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Search Resources...',
              hintStyle: const TextStyle(color: Colors.white54),
              border: InputBorder.none,
              prefixIcon: const Icon(Icons.search, color: Colors.white),
              filled: true,
              fillColor: Colors.deepPurple.shade100,
            ),
          ),
          backgroundColor: const Color(0xFF7C4DFF),
        ),
        body: Consumer<ResourceProvider>(
          builder: (context, resourceProvider, _) {
            if (resourceProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (resourceProvider.resources.isEmpty) {
              return const Center(child: Text('No resources available.'));
            }
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ResourceListWidget(
                searchQuery: searchQuery,
                userId: userId ?? '',
                user: widget.user, // Pass the extracted userId here
              ),
            );
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart), label: 'Cart'),
            BottomNavigationBarItem(
                icon: Icon(Icons.history), label: 'Order History'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
          selectedItemColor: const Color(0xFF7C4DFF),
          unselectedItemColor: Colors.grey,
        ),
      ),
    );
  }
}
