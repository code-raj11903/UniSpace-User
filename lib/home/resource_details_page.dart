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
      String extractedUserId =
          userId.replaceAll('ObjectId("', '').replaceAll('")', '');

      if (extractedUserId.isEmpty || extractedUserId.length != 24) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid userId format.')),
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
            // Displaying resource image
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
            // Resource Name
            Text(
              resource['name'] ?? 'No name available',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            // Price Details
            Text(
              'Price per Day: ₹${(resource['price_per_day'] ?? 0).toString()}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 10),
            // Resource Description
            Text(
              resource['description'] ?? 'No description available',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 20),
            // Additional Resource Information
            _buildInfoRow(
              icon: Icons.location_on,
              label: 'Location',
              value: resource['location'] ?? 'Not specified',
            ),
            _buildInfoRow(
              icon: Icons.check_circle,
              label: 'Availability',
              value: resource['availability'] ? 'Available' : 'Booked',
            ),
            _buildInfoRow(
              icon: Icons.date_range,
              label: 'Available from',
              value: resource['available_from'] ?? 'Not specified',
            ),
            const SizedBox(height: 20),
            // Actions: Add to Cart and Buy Now
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () => addToCart(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
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
                    backgroundColor: Colors.green,
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

  // Helper function to build information row
  Widget _buildInfoRow(
      {required IconData icon, required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.deepPurple),
          const SizedBox(width: 10),
          Text(
            '$label: ',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
