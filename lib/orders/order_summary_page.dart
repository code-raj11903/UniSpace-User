import 'package:flutter/material.dart';
import '../cart/cart_item.dart';

class OrderSummaryPage extends StatelessWidget {
  final List<CartItem> cartItems;

  OrderSummaryPage({required this.cartItems});

  @override
  Widget build(BuildContext context) {
    // Set the initial value to 0.0 to avoid type errors
    final double totalPrice = cartItems.fold(
        0.0, (total, item) => total + (item.price * item.quantity));

    return Scaffold(
      appBar: AppBar(
        title: Text('Order Summary'),
      ),
      body: ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          final item = cartItems[index];
          return ListTile(
            title: Text(item.name),
            subtitle:
                Text('Quantity: ${item.quantity}, Price: \$${item.price}'),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'Total: \$${totalPrice.toStringAsFixed(2)}', // Fixed decimal format for total price
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
