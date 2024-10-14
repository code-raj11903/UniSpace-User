import 'package:flutter/material.dart';
import '../cart/cart_item.dart';

class OrderSummaryPage extends StatelessWidget {
  final List<CartItem> cartItems;
  final double totalAmount;
  final String paymentMethod;

  const OrderSummaryPage({
    super.key,
    required this.cartItems,
    required this.totalAmount,
    required this.paymentMethod,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Summary'),
        centerTitle: true,
        backgroundColor:
            const Color(0xFF7C4DFF), // Purple theme for standard feel
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Order Summary',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF7C4DFF), // Purple color for accent
              ),
            ),
            const SizedBox(height: 20),

            // Divider for a cleaner separation of sections
            const Divider(thickness: 1, color: Colors.grey),

            // Displaying each cart item in a card-style format for better visibility
            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    elevation: 3.0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: item.imageUrl != null
                            ? Image.network(item.imageUrl!,
                                width: 50, height: 50)
                            : const Icon(Icons.image_not_supported, size: 50),
                        title: Text(
                          item.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Text(
                          'Quantity: ${item.quantity}\nPrice: ₹${item.price.toStringAsFixed(2)}',
                          style:
                              const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        trailing: Text(
                          '₹${(item.price * item.quantity).toStringAsFixed(2)}',
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // Divider to separate total summary from the list of items
            const Divider(thickness: 1, color: Colors.grey),

            // Total amount display in bold
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Amount:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '₹${totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Payment method display
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Payment Method:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  paymentMethod,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Thank you message
            const Center(
              child: Text(
                'Thank you for your payment!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF7C4DFF), // Purple for accent
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Return to home button
            ElevatedButton.icon(
              onPressed: () {
                Navigator.popUntil(
                    context, (route) => route.isFirst); // Return to home
              },
              icon: const Icon(Icons.home, size: 24),
              label: const Text(
                'Return to Home',
                style: TextStyle(fontSize: 18),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(0xFF7C4DFF), // Purple color for consistency
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
