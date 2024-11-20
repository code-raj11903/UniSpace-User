import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package
import '../home/home_page.dart';

class OrderSummaryPage extends StatelessWidget {
  final double totalAmount;
  final String paymentMethod;
  final Map<String, dynamic> user;
  final DateTime startDate;
  final DateTime endDate;
  final Map<String, dynamic>? resource;

  const OrderSummaryPage({
    super.key,
    required this.totalAmount,
    required this.paymentMethod,
    required this.user,
    required this.startDate,
    required this.endDate,
    this.resource,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    final duration = endDate.difference(startDate).inDays + 1;
    final totalPrice = duration * totalAmount;

    // Format start and end dates to dd/MM/yy
    final startDateFormatted = DateFormat('dd/MM/yy').format(startDate);
    final endDateFormatted = DateFormat('dd/MM/yy').format(endDate);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF7C4DFF),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Section
                  Center(
                    child: const Text(
                      'Order Summary',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF7C4DFF),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Divider(thickness: 1, color: Colors.grey),

                  // Main Card with all the details
                  Card(
                    elevation: 8.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          // Image on the left side (smaller)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              resource?['image_url'] ??
                                  'assets/images/placeholder.png',
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 16),

                          // Details on the right side (inside smaller card)
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Resource Name: ${resource?['name']}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Description: ${resource?['description']}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Start Date: $startDateFormatted',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'End Date: $endDateFormatted',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  const Divider(thickness: 1, color: Colors.grey),

                  // Total Amount
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Amount:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '₹${totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Payment Method
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Payment Method:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        paymentMethod,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Thank You message
                  const SizedBox(height: 30),
                  const Center(
                    child: Text(
                      'Thank you for your payment!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF7C4DFF),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),

          // Return to Home button at the bottom
          Container(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(
                      user: user,
                      refresh: true,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.home, size: 24),
              label: const Text(
                'Return to Home',
                style: TextStyle(fontSize: 18),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 235, 231, 247),
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
