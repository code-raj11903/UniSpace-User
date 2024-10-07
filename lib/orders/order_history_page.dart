import 'package:flutter/material.dart';
import '../home/home_page.dart' as home; // Alias for HomePage
import 'cart_page.dart'; // Ensure you import your Cart page
import '../account/profile_page.dart' as account; // Alias for ProfilePage

class OrderHistoryPage extends StatefulWidget {
  final String userId; // Add userId as a required parameter

  const OrderHistoryPage({Key? key, required this.userId}) : super(key: key);

  @override
  _OrderHistoryPageState createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  int _selectedIndex =
      2; // Set this to 2 because Order History is the active page

  // Navigation based on the selected bottom navigation bar item
  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                home.HomePage(user: {'userId': widget.userId}), // Pass userId
          ),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                CartPage(userId: widget.userId), // Pass userId to CartPage
          ),
        );
        break;
      case 2:
        // Already on Order History page
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => account.ProfilePage(
              user: {'_id': widget.userId}, // Pass user object
            ),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order History'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'Order History for User ID: ${widget.userId}', // Example usage
          style: const TextStyle(fontSize: 18),
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
    );
  }
}
