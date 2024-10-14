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

  const HomePage({super.key, required this.user});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String searchQuery = '';
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    Provider.of<ResourceProvider>(context, listen: false).fetchResources();
    _persistLogin();
  }

  Future<void> _persistLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
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
    });
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;
    setState(() {
      _selectedIndex = index;
    });

    final userId = widget.user['_id'] as String? ?? '';

    switch (index) {
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => CartPage(userId: userId),
          ),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => OrderHistoryPage(userId: userId),
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
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ResourceListWidget(
            searchQuery: searchQuery,
            userId: widget.user['_id'] as String? ?? '',
          ),
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
