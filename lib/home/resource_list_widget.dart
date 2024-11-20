import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/resource_provider.dart';
import 'resource_card.dart';

class ResourceListWidget extends StatelessWidget {
  final String searchQuery;
  final String userId;
  final Map<String, dynamic> user;
  final double? minPrice;
  final double? maxPrice;

  const ResourceListWidget({
    super.key,
    required this.searchQuery,
    required this.userId,
    required this.user,
    this.minPrice,
    this.maxPrice,
  });

  @override
  Widget build(BuildContext context) {
    print(
        'ResourceListWidget received data: searchQuery=$searchQuery, minPrice=$minPrice, maxPrice=$maxPrice');

    return Consumer<ResourceProvider>(
      builder: (context, resourceProvider, child) {
        if (resourceProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (resourceProvider.resources.isEmpty) {
          return const Center(child: Text('Failed to load resources.'));
        }

        print('Total resources loaded: ${resourceProvider.resources.length}');

        // Filter the resources based on search query and price range
        final filteredResources = resourceProvider.resources.where((resource) {
          final resourceName = resource['name']?.toString().toLowerCase() ?? '';
          final resourceLocation =
              resource['location']?.toString().toLowerCase() ?? '';
          final instituteName =
              resource['institute']?.toString().toLowerCase() ?? '';
          final departmentName =
              resource['department']?.toString().toLowerCase() ?? '';
          final price = resource['price_per_day'] ??
              0.0; // Ensure the price field is retrieved

          print('Checking resource: $resourceName, Price: $price');

          // Check if any of these fields match the search query
          bool matchesSearchQuery = resourceName.contains(searchQuery) ||
              resourceLocation.contains(searchQuery) ||
              instituteName.contains(searchQuery) ||
              departmentName.contains(searchQuery);
          print('matchesSearchQuery: $matchesSearchQuery');

          // Check if the price is within the selected range
          bool matchesPriceRange = (minPrice == null || price >= minPrice!) &&
              (maxPrice == null || price <= maxPrice!);
          print(
              'Price filter: minPrice=$minPrice, maxPrice=$maxPrice, matchesPriceRange=$matchesPriceRange');

          return matchesSearchQuery &&
              resource['availability'] == true &&
              matchesPriceRange;
        }).toList();

        print('Filtered resources count: ${filteredResources.length}');

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
          child: Column(
            children: [
              Expanded(
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
              ),
            ],
          ),
        );
      },
    );
  }
}
