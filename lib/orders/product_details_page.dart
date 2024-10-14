import 'package:flutter/material.dart';
import '../mongo_service.dart';
import '../cart/cart_item.dart';
import '../orders/payment_page.dart';

class ProductDetailsPage extends StatelessWidget {
  final String productId;
  final String name;
  final double price;
  final String userId;

  const ProductDetailsPage({
    super.key,
    required this.productId,
    required this.name,
    required this.price,
    required this.userId,
  });

  Future<void> addToCart(BuildContext context) async {
    try {
      String actualUserId =
          userId.replaceAll('ObjectId("', '').replaceAll('")', '');

      final cartItem = CartItem(
        productId: productId,
        name: name,
        price: price,
        quantity: 1,
      );

      String result = await MongoDatabase.addToCart(actualUserId, cartItem);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(result)));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to add to cart: $e')));
    }
  }

  void buyNow(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentPage(
          resourceId: productId,
          resourceName: name,
          resourcePrice: price,
          userId: userId, // Pass the userId to PaymentPage
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
            Text(name, style: const TextStyle(fontSize: 24)),
            Text('₹${price.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 20)),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () => addToCart(context),
                    child: const Text('Add to Cart')),
                ElevatedButton(
                    onPressed: () => buyNow(context),
                    child: const Text('Buy Now')),
              ],
            )
          ],
        ),
      ),
    );
  }
}
