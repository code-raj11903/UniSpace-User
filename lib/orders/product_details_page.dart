import 'package:flutter/material.dart';
import '../mongo_service.dart';
import '../cart/cart_item.dart';
import '../orders/payment_page.dart';

class ProductDetailsPage extends StatelessWidget {
  final String productId;
  final String name;
  final double price;
  final String userId; // Expecting the userId to be a string

  ProductDetailsPage({
    required this.productId,
    required this.name,
    required this.price,
    required this.userId,
  });

  Future<void> addToCart(BuildContext context) async {
    try {
      // Extract the actual userId from ObjectId format
      String actualUserId =
          userId.replaceAll('ObjectId("', '').replaceAll('")', '');

      print("Actual User ID: $actualUserId"); // Debugging statement

      if (actualUserId.isEmpty || actualUserId.length != 24) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Invalid userId format.')));
        return;
      }

      final cartItem = CartItem(
        productId: productId,
        name: name,
        price: price.toDouble(), // Ensure price is a double
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
    // Navigate to payment page with resource details
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentPage(
          resourceId: productId, // Pass resourceId
          resourceName: name, // Pass resourceName
          resourcePrice: price, // Pass resourcePrice
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
            Text(name, style: TextStyle(fontSize: 24)),
            Text('\$${price.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 20)),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () => addToCart(context),
                    child: Text('Add to Cart')),
                ElevatedButton(
                    onPressed: () => buyNow(context), child: Text('Buy Now')),
              ],
            )
          ],
        ),
      ),
    );
  }
}
