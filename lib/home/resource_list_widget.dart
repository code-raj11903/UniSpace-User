import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/resource_provider.dart';
import 'resource_card.dart';

class ResourceListWidget extends StatelessWidget {
  final String searchQuery;
  final String userId;
  final Map<String, dynamic> user;

  const ResourceListWidget({
    super.key,
    required this.searchQuery,
    required this.userId,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ResourceProvider>(
      builder: (context, resourceProvider, child) {
        if (resourceProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (resourceProvider.resources.isEmpty) {
          return const Center(child: Text('Failed to load resources.'));
        }

        final filteredResources = resourceProvider.resources.where((resource) {
          final resourceName = resource['name']?.toString().toLowerCase() ?? '';
          return resource['availability'] == true &&
              resourceName.contains(searchQuery.toLowerCase());
        }).toList();

        if (filteredResources.isEmpty) {
          return const Center(
            child: Text(
              'No resources found. Try broadening your search.',
              style: TextStyle(fontSize: 16),
            ),
          );
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
                resource: filteredResources[index],
                userId: userId,
                user: user,
              );
            },
          ),
        );
      },
    );
  }
}
