import 'package:flutter/material.dart';
import '../mongo_service.dart';
import '../orders/cart_page.dart';
import '../account/profile_page.dart';
import '../home/home_page.dart';

class OrderHistoryPage extends StatefulWidget {
  final String userId;

  const OrderHistoryPage({super.key, required this.userId});

  @override
  _OrderHistoryPageState createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  final int _selectedIndex = 2;
  List<Map<String, dynamic>> _bookings = [];
  bool _isLoading = true; // Loading state

  @override
  void initState() {
    super.initState();
    _fetchBookingHistory(); // Fetch user-specific booking history on page load
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;

    // Pass the userId in a Map<String, dynamic>
    final user = {'userId': widget.userId};

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                HomePage(user: user), // Corrected constructor call
          ),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                CartPage(userId: widget.userId), // CartPage remains the same
          ),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ProfilePage(user: user), // Corrected constructor call
          ),
        );
        break;
    }
  }

  Future<void> _fetchBookingHistory() async {
    try {
      List<Map<String, dynamic>> bookings =
          await MongoDatabase.getBookingHistory(widget.userId);
      setState(() {
        _bookings = bookings;
        _isLoading = false; // Set loading to false after data is fetched
      });
    } catch (e) {
      setState(() {
        _isLoading = false; // Stop loading even if there's an error
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch bookings: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order History'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(
              child:
                  CircularProgressIndicator()) // Show a loader while fetching data
          : _bookings.isEmpty
              ? const Center(child: Text('No bookings found.'))
              : ListView.builder(
                  itemCount: _bookings.length,
                  itemBuilder: (context, index) {
                    var booking = _bookings[index];
                    return ListTile(
                      title: Text('Booking ID: ${booking['_id']}'),
                      subtitle:
                          Text('Total Amount: ₹${booking['total_amount']}'),
                      trailing: Text('Status: ${booking['status']}'),
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
    );
  }
}
