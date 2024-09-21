import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_1/home/home_page.dart' as home;
import 'package:flutter_application_1/orders/cart_page.dart' as cart;
import 'package:flutter_application_1/account/profile_page.dart' as profile;
import 'package:flutter_application_1/orders/order_history_page.dart' as orderHistory;
import '../checkout/checkout_page.dart'; // For Buy Now functionality

class FilterSortPage extends StatefulWidget {
  final String resource;

  const FilterSortPage({super.key, required this.resource});

  @override
  _FilterSortPageState createState() => _FilterSortPageState();
}

class _FilterSortPageState extends State<FilterSortPage> {
  DateTime? _startDate;
  DateTime? _endDate;
  int _selectedIndex = 0; // For bottom navigation bar

  final List<Map<String, dynamic>> resources = [
    {
      'name': 'Resource 1',
      'description': 'Description of Resource 1',
      'availability': 'Available',
      'rating': 4.5,
    },
    {
      'name': 'Resource 2',
      'description': 'Description of Resource 2',
      'availability': 'Not Available',
      'rating': 3.8,
    },
    // Add more resources as needed
  ];

  // Method for navigating between different bottom nav bar items
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => home.HomePage()), // Use prefix for HomePage
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => cart.CartPage()), // Use prefix for CartPage
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => orderHistory.OrderHistoryPage()), // Use prefix for OrderHistoryPage
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => profile.ProfilePage()), // Use prefix for ProfilePage
        );
        break;
    }
  }

  // Date Picker logic for selecting start and end dates
  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        if (isStartDate) {
          _startDate = pickedDate;
        } else {
          _endDate = pickedDate;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('MM/dd/yyyy');

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.resource} Resources'),
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
          children: [
            const SizedBox(height: 80),
            // Start Date and End Date Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () => _selectDate(context, true),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _startDate == null
                          ? 'Start Date'
                          : 'Start: ${formatter.format(_startDate!)}',
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => _selectDate(context, false),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _endDate == null
                          ? 'End Date'
                          : 'End: ${formatter.format(_endDate!)}',
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Displaying available resources with Buy Now and Add to Cart buttons
            Expanded(
              child: ListView.builder(
                itemCount: resources.length,
                itemBuilder: (context, index) {
                  final resource = resources[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    elevation: 5,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(20),
                      title: Text(resource['name'], style: const TextStyle(fontSize: 20)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(resource['description'], style: const TextStyle(fontSize: 16)),
                          const SizedBox(height: 5),
                          Text('Availability: ${resource['availability']}',
                              style: TextStyle(
                                  color: resource['availability'] == 'Available'
                                      ? Colors.green
                                      : Colors.red)),
                          const SizedBox(height: 5),
                          Text('Rating: ${resource['rating']}'),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CheckoutPage(), // Navigate to CheckoutPage for Buy Now
                                ),
                              );
                            },
                            child: const Text('Buy Now'),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => cart.CartPage(), // Navigate to CartPage for Add to Cart
                                ),
                              );
                            },
                            child: const Text('Add to Cart'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
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
