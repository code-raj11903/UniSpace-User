import 'package:flutter/material.dart';
import 'resource_card.dart';
import '../mongo_service.dart';

class ResourceListWidget extends StatelessWidget {
  final String searchQuery;
  final String userId;

  const ResourceListWidget(
      {super.key, required this.searchQuery, required this.userId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      // Fetch available resources
      future: MongoDatabase.fetchResources(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Error loading resources.'));
        }

        final resources = snapshot.data ?? [];
        final filteredResources = resources.where((resource) {
          final resourceName = resource['name'].toString().toLowerCase();
          return resource['availability'] == true && // Check for availability
              resourceName.contains(searchQuery.toLowerCase());
        }).toList();

        if (filteredResources.isEmpty) {
          return const Center(child: Text('No resources found.'));
        }

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.75,
            ),
            itemCount: filteredResources.length,
            itemBuilder: (context, index) {
              return ResourceCard(
                  resource: filteredResources[index], userId: userId);
            },
          ),
        );
      },
    );
  }
}
