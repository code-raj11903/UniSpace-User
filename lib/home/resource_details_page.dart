import 'package:flutter/material.dart';
import '../mongo_service.dart';
import '../cart/cart_item.dart';
import '../orders/payment_page.dart';

class ResourceDetailsPage extends StatelessWidget {
  final Map<String, dynamic> resource;
  final String userId;

  const ResourceDetailsPage({
    Key? key,
    required this.resource,
    required this.userId,
  }) : super(key: key);

  void addToCart(BuildContext context) async {
    try {
      // Log the user ID being used
      print("Actual User ID: $userId");

      // If the userId is wrapped in ObjectId, extract the string value
      String extractedUserId =
          userId.replaceAll('ObjectId("', '').replaceAll('")', '');

      if (extractedUserId.isEmpty || extractedUserId.length != 24) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid userId format.')),
        );
        return;
      }

      final itemData = CartItem(
        productId: resource['_id'].toString(),
        name: resource['name'],
        price: (resource['price_per_day'] as num).toDouble(),
        quantity: 1,
      );

      String result = await MongoDatabase.addToCart(extractedUserId, itemData);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(result)));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to add to cart: $e')));
    }
  }

  void buyNow(BuildContext context) {
    // Navigate to the PaymentPage with the resource details
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentPage(
          resourceId: resource['_id'].toString(),
          resourceName: resource['name'],
          resourcePrice: (resource['price_per_day'] as num).toDouble(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(resource['name'] ?? 'Resource Details'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                resource['image_url'] ?? '',
                fit: BoxFit.cover,
                height: 250,
                width: double.infinity,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              resource['name'] ?? 'No name available',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              resource['description'] ?? 'No description available',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Text(
              'Price per Day: \$${(resource['price_per_day'] ?? 0).toString()}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () => addToCart(context),
                  child: const Text('Add to Cart'),
                ),
                ElevatedButton(
                  onPressed: () => buyNow(context), // Navigate to payment
                  child: const Text('Buy Now'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
