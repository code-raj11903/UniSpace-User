import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../orders/payment_page.dart'; // Import PaymentPage

class CartPage extends StatefulWidget {
  final String userId;

  const CartPage({super.key, required this.userId});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    // Log when loading cart items
    print("Loading cart items for user ID: ${widget.userId}");
    Provider.of<CartProvider>(context, listen: false)
        .loadCartItems(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Your Cart'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context); // Return to previous screen
              },
            ),
          ),
          body: cartProvider.cartItems.isEmpty
              ? const Center(
                  child: Text(
                    'Your cart is empty.',
                    style: TextStyle(fontSize: 18, color: Colors.black54),
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: cartProvider.cartItems.length,
                        itemBuilder: (context, index) {
                          final item = cartProvider.cartItems[index];
                          return Card(
                            margin: const EdgeInsets.all(8.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              children: [
                                // Product Image
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    bottomLeft: Radius.circular(15),
                                  ),
                                  child: Image.network(
                                    item.imageUrl ??
                                        'https://via.placeholder.com/150',
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(
                                        Icons.image_not_supported,
                                        size: 100,
                                        color: Colors.grey,
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10),
                                // Product Details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.name,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        'Price: ₹${item.price.toStringAsFixed(2)}',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        'Quantity: ${item.quantity}',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                                // Remove Button
                                IconButton(
                                  icon: const Icon(Icons.remove_circle,
                                      color: Colors.red),
                                  onPressed: () {
                                    cartProvider.removeFromCart(
                                        widget.userId, item.productId);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              '${item.name} removed from cart')),
                                    );
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    // Total Price Summary
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total:',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '₹${cartProvider.totalPrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: cartProvider.cartItems.isNotEmpty
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentPage(
                            userId: widget.userId,
                            cartItems: cartProvider.cartItems,
                            totalAmount: cartProvider.totalPrice,
                          ),
                        ),
                      );
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              child: const Text('Proceed to Payment'),
            ),
          ),
        );
      },
    );
  }
}
