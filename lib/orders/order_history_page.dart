import 'package:flutter/material.dart';
import 'package:flutter_application_1/account/profile_page.dart' as profile;
import 'package:flutter_application_1/orders/cart_page.dart' as cart;
import 'package:flutter_application_1/home/home_page.dart' as home;

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  _OrderHistoryPageState createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  int _selectedIndex = 2; // Set this to 2 because Order History is the active page

  // Navigation based on the selected bottom navigation bar item
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => home.HomePage()), // Use prefix for HomePage
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => cart.CartPage()), // Use prefix for CartPage
        );
        break;
      case 2:
        // Already on Order History page
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => profile.ProfilePage()), // Use prefix for ProfilePage
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Order History',
          style: TextStyle(fontSize: 24),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFB388FF), Color(0xFF7C4DFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 80), // Adjust space for AppBar
            const Text(
              'Completed Orders',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Card(
              color: Colors.white.withOpacity(0.9),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 5,
              child: const ListTile(
                leading: Icon(Icons.check_circle, color: Colors.green),
                title: Text('Order #12345', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                subtitle: Text('Delivered on 12/09/2023'),
                trailing: Text('Total: \$100'),
              ),
            ),
            const Divider(color: Colors.white54),
            const SizedBox(height: 20),
            const Text(
              'Cancelled Orders',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Card(
              color: Colors.white.withOpacity(0.9),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 5,
              child: const ListTile(
                leading: Icon(Icons.cancel, color: Colors.red),
                title: Text('Order #54321', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                subtitle: Text('Cancelled on 10/09/2023'),
                trailing: Text('Total: \$150'),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex, // Set this to 2 because Order History is the active page
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Order History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        selectedItemColor: const Color(0xFF7C4DFF),
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}

