import 'package:flutter/material.dart';
import '../mongo_service.dart';
import '../cart/cart_item.dart';
import '../orders/payment_page.dart';

class ResourceDetailsPage extends StatelessWidget {
  final Map<String, dynamic> resource;
  final String userId;
  final Map<String, dynamic> user;

  const ResourceDetailsPage({
    super.key,
    required this.resource,
    required this.userId,
    required this.user,
  });

  void addToCart(BuildContext context) async {
    // Log userId before adding to the cart
    print('Checking userId in addToCart method: $userId');

    try {
      // Log userId and resource info before proceeding
      print('User ID in addToCart: $userId');
      String pId = resource['_id']
          .toString()
          .replaceAll('ObjectId("', '')
          .replaceAll('")', '');

      print('Resource ID: ${pId}');
      print('Resource Name: ${resource['name']}');

      if (userId.isEmpty || userId.length != 24) {
        print('Error: Invalid userId format.');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid userId format.')),
        );
        return;
      }

      final itemData = CartItem(
          productId: pId,
          name: resource['name'],
          price: (resource['price_per_day'] as num).toDouble(),
          quantity: 1,
          imageUrl: resource['image_url']);

      // Log the CartItem details
      print('Adding item to cart: ${itemData.toMap()}');

      String result = await MongoDatabase.addToCart(userId, itemData);
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
    // Log the userId and resource details before navigating
    print('Checking userId in buyNow method: $userId');
    print(
        'Navigating to PaymentPage with userId: $userId and resourceId: ${resource['_id']}');

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
          resource: resource, // Pass the whole resource map
          resourceId: resource['_id'].toString(),
          resourceName: resource['name'],
          resourcePrice: (resource['price_per_day'] as num).toDouble(),
          userId: userId, // Pass the userId to PaymentPage
          user: user,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Log the userId when building the page
    print(
        'Building ResourceDetailsPage for resource ID: ${resource['_id']} with userId: $userId');

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
            Hero(
              tag: resource['_id'],
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  resource['image_url'] ?? '',
                  fit: BoxFit.cover,
                  height: 250,
                  width: double.infinity,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              resource['name'] ?? 'No name available',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Price per Day: ₹${(resource['price_per_day'] ?? 0).toString()}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              resource['description'] ?? 'No description available',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () => addToCart(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: const Text('Add to Cart'),
                ),
                ElevatedButton(
                  onPressed: () => buyNow(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 46, 196, 51),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
