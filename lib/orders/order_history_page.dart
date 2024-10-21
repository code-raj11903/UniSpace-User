import 'package:flutter/material.dart';
import '../mongo_service.dart'; // Assume this handles the MongoDB connection
import '../orders/cart_page.dart';
import '../account/profile_page.dart';
import '../home/home_page.dart';
import 'package:intl/intl.dart';

class OrderHistoryPage extends StatefulWidget {
  final Map<String, dynamic> userId;
  const OrderHistoryPage({super.key, required this.userId});

  @override
  _OrderHistoryPageState createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  late String user;
  final int _selectedIndex = 2;
  List<Map<String, dynamic>> _orders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    final dynamic objectId = widget.userId['id'];
    user =
        objectId.toString().replaceAll('ObjectId("', '').replaceAll('")', '');
    _fetchOrderHistory();
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(user: widget.userId),
          ),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => CartPage(
              userId: widget.userId['id'],
              user: widget.userId,
            ),
          ),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ProfilePage(user: widget.userId),
          ),
        );
        break;
    }
  }

  Future<void> _fetchOrderHistory() async {
    try {
      print('Fetching order history for userId: $user');
      List<Map<String, dynamic>> orders =
          await MongoDatabase.getOrderHistory(user);

      if (orders == null || orders.isEmpty) {
        setState(() {
          _orders = []; // Ensure the orders list is empty
          _isLoading = false;
        });
        return;
      }

      for (var order in orders) {
        var resourceIds = order['resource_ids'] as List<dynamic>?;

        if (resourceIds != null && resourceIds.isNotEmpty) {
          for (var resourceId in resourceIds) {
            String cleanedResourceId = resourceId
                .toString()
                .replaceAll('ObjectId("', '')
                .replaceAll('")', '');
            var resourceDetails =
                await MongoDatabase.getResourceDetailsById(cleanedResourceId);

            if (resourceDetails != null) {
              order['resource_info'] = {
                'name': resourceDetails['name'] ?? 'Unknown Resource',
                'image_url': resourceDetails['image_url'] ?? '',
                'location': resourceDetails['location'] ?? 'Unknown',
                'description': resourceDetails['description'] ??
                    'No description available',
              };
            }
          }
        }
      }

      setState(() {
        _orders = orders;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching orders: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to fetch orders: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order History'),
        centerTitle: true,
        backgroundColor: const Color(0xFF7C4DFF),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _orders.isEmpty
              ? const Center(child: Text('No orders found.'))
              : ListView.builder(
                  itemCount: _orders.length,
                  itemBuilder: (context, index) {
                    var order = _orders[index];
                    var resourceInfo = order['resource_info'] ?? {};
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 15.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Order ID and Date
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    'Order ID: ${order['_id']}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                Text(
                                  order['date'] is DateTime
                                      ? DateFormat('dd MMM yyyy')
                                          .format(order['date'])
                                      : 'Unknown',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),

                            // Status and Total Amount
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Status: ${order['status']}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: order['status'] == 'Delivered'
                                        ? Colors.green
                                        : Colors.orange,
                                  ),
                                ),
                                Text(
                                  '₹${order['total_amount']}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Resource Info
                            if (resourceInfo.isNotEmpty) ...[
                              Row(
                                children: [
                                  Container(
                                    height: 80,
                                    width: 80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            resourceInfo['image_url'] ?? ''),
                                        fit: BoxFit.cover,
                                        onError: (error, stackTrace) =>
                                            Container(
                                          color: Colors.grey[300],
                                          child: const Center(
                                            child: Icon(Icons.broken_image,
                                                color: Colors.grey, size: 50),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          resourceInfo['name'] ??
                                              'Unknown Resource',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          resourceInfo['location'] ?? 'Unknown',
                                          style: const TextStyle(
                                              fontSize: 14, color: Colors.grey),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          resourceInfo['description'] ??
                                              'No description available',
                                          style: const TextStyle(
                                              fontSize: 14, color: Colors.grey),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            const SizedBox(height: 16),

                            // Action Buttons
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    // Implement order details or repeat order action
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(
                                        255, 255, 255, 255),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text('View Details'),
                                ),
                                const SizedBox(width: 10),
                                ElevatedButton(
                                  onPressed: () {
                                    // Implement reorder functionality
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(
                                        255, 255, 255, 255),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text('Repeat Order'),
                                ),
                              ],
                            ),
                          ],
                        ),
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
    );
  }
}
