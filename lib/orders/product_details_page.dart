import 'package:flutter/material.dart';
import '../mongo_service.dart';
import '../cart/cart_item.dart';
import '../orders/payment_page.dart';

class ProductDetailsPage extends StatelessWidget {
  final String productId;
  final String name;
  final double price;
  final String userId;
  final Map<String, dynamic> user;
  final Map<String, dynamic> resource;

  const ProductDetailsPage({
    super.key,
    required this.productId,
    required this.name,
    required this.price,
    required this.userId,
    required this.user,
    required this.resource,
  });

  Future<void> addToCart(BuildContext context) async {
    try {
      // Log userId and product details
      print('User ID in addToCart: $userId');
      print('Product ID: $productId');
      print('Product Name: $name');

      if (userId.isEmpty || userId.length != 24) {
        print('Error: Invalid userId format.');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid userId format.')),
        );
        return;
      }

      final cartItem = CartItem(
        productId: productId,
        name: name,
        price: price,
        quantity: 1,
      );

      // Log CartItem details before adding to cart
      print('Adding item to cart: ${cartItem.toMap()}');

      String result = await MongoDatabase.addToCart(userId, cartItem);
      print('Cart addition result: $result');

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(result)));
    } catch (e) {
      print('Failed to add to cart: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to add to cart: $e')));
    }
  }

  void buyNow(BuildContext context) {
    // Log navigation details
    print(
        'Navigating to PaymentPage with userId: $userId and productId: $productId');

    if (userId.isEmpty || userId.length != 24) {
      print('Error: Invalid userId format.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid userId format.')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentPage(
          resource: resource,
          resourceId: productId,
          resourceName: name,
          resourcePrice: price,
          userId: userId, // Pass the userId to PaymentPage
          user: user,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text('₹${price.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 20, color: Colors.green)),
            const SizedBox(height: 20),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => addToCart(context),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                  child: const Text('Add to Cart'),
                ),
                ElevatedButton(
                  onPressed: () => buyNow(context),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    backgroundColor: Colors.green,
                  ),
                  child: const Text('Buy Now'),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
