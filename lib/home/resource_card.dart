import 'package:flutter/material.dart';
import 'resource_details_page.dart';

class ResourceCard extends StatelessWidget {
  final Map<String, dynamic> resource;
  final String userId;

  const ResourceCard({super.key, required this.resource, required this.userId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResourceDetailsPage(
              resource: resource,
              userId: userId,
            ),
          ),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Hero(
                tag: resource['_id'],
                child: ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(15)),
                  child: Image.network(
                    resource['image_url'],
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    resource['name'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Location: ${resource['location'] ?? 'Not available'}',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    resource['price'] != null
                        ? 'Price: ₹${resource['price'].toStringAsFixed(2)}'
                        : 'Price: Not available', // Fallback if price is null
                    style: const TextStyle(fontSize: 16, color: Colors.green),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    resource['availability'] ? 'Available' : 'Not Available',
                    style: TextStyle(
                      fontSize: 14,
                      color:
                          resource['availability'] ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
