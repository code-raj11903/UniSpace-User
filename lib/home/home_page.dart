import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers/cart_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../orders/cart_page.dart';
import '../account/profile_page.dart';
import '../orders/order_history_page.dart';
import '../providers/resource_provider.dart';
import 'resource_list_widget.dart';
import 'dart:async'; // Import for Timer

class HomePage extends StatefulWidget {
  final Map<String, dynamic> user;
  final bool refresh; // Add a refresh parameter

  const HomePage({super.key, required this.user, this.refresh = false});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? userId;
  String searchQuery = '';
  int _selectedIndex = 0;
  Timer? _timer; // Timer to refresh resources every 20 seconds

  // Add these two variables for price range filter
  double? _minPrice;
  double? _maxPrice;
  bool _isLoading = false; // Track loading state

  @override
  void initState() {
    super.initState();
    _persistLogin();
    final dynamic objectId = widget.user['id'];
    userId =
        objectId.toString().replaceAll('ObjectId("', '').replaceAll('")', '');
    print('HomePage initialized with user: ${widget.user}');
    if (userId!.isNotEmpty) {
      Provider.of<CartProvider>(context, listen: false).loadCartItems(userId!);
    }

    if (widget.refresh) {
      _fetchResources(); // Refresh the homepage if the refresh flag is true
    }
    _startAutoRefresh();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // _fetchResources();
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the Timer when the page is disposed
    super.dispose();
  }

  // Method to start auto-refresh every 20 seconds
  void _startAutoRefresh() {
    _timer = Timer.periodic(Duration(seconds: 40), (Timer t) {
      _fetchResources(); // Automatically fetch resources every 20 seconds
    });
  }

  // Method to stop the timer when it's no longer needed

  Future<void> _fetchResources() async {
    if (_isLoading) return; // Prevent refreshing if already loading
    setState(() {
      _isLoading = true; // Indicate loading
    });

    try {
      print('Fetching resources...');
      await Provider.of<ResourceProvider>(context, listen: false)
          .fetchResources(forceRefresh: true);
      print('Resources fetched successfully.');
    } catch (e) {
      print('Error fetching resources: $e');
    } finally {
      setState(() {
        _isLoading = false; // Hide loading state
      });
    }
  }

  Future<void> _persistLogin() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      print('Login state persisted in SharedPreferences');
    } catch (e) {
      print('Error persisting login state: $e');
    }
  }

  Future<bool> _onWillPop() async {
    if (_selectedIndex == 0) {
      return true; // Exit app only if user is on Home tab
    } else {
      setState(() {
        _selectedIndex = 0; // Go back to Home tab
      });
      return false;
    }
  }

  void onSearchChanged(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      print('Search query updated: $searchQuery');
    });
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;

    setState(() {
      _selectedIndex = index;
    });
    Provider.of<ResourceProvider>(context, listen: false).fetchResources();
    final dynamic objectId = widget.user['id'];
    final userId =
        objectId.toString().replaceAll('ObjectId("', '').replaceAll('")', '');

    if (userId.isEmpty) {
      print('Error: userId is null or empty');
      return;
    }

    print('Navigating with userId: $userId');
    switch (index) {
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => CartPage(userId: userId, user: widget.user),
          ),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => OrderHistoryPage(userId: widget.user),
          ),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ProfilePage(user: widget.user),
          ),
        );
        break;
      default:
        print('Unknown navigation index: $index');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop, // Restrict back button functionality
      child: Scaffold(
        appBar: AppBar(
          title: TextField(
            onChanged: onSearchChanged,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Search Resources...',
              hintStyle: const TextStyle(color: Colors.white54),
              border: InputBorder.none,
              prefixIcon: const Icon(Icons.search, color: Colors.white),
              filled: true,
              fillColor: Colors.deepPurple.shade100,
            ),
          ),
          backgroundColor: const Color(0xFF7C4DFF),
        ),
        body: Column(
          children: [
            // Price filter section
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  // Min Price field
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Min Price',
                        hintText: 'Enter minimum price',
                        labelStyle: TextStyle(
                            color: Colors.blue
                                .shade700), // Match your theme color for label
                        hintStyle: TextStyle(
                            color: Colors.grey.shade600), // Soft grey hint text
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              20.0), // Rounded corners for consistency
                          borderSide: BorderSide(
                              color: Colors.blue.shade200,
                              width: 1.5), // Light blue border color
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(
                              color: Colors.blue.shade200, width: 1.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(
                              color: Colors.blue.shade700,
                              width: 2.0), // Focused border in theme color
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 14.0), // Spacing for comfort
                      ),
                      onChanged: (value) {
                        setState(() {
                          _minPrice =
                              value.isNotEmpty ? double.parse(value) : null;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Max Price field
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Max Price',
                        hintText: 'Enter maximum price',
                        labelStyle: TextStyle(
                            color: Colors
                                .blue.shade700), // Consistent with your theme
                        hintStyle: TextStyle(
                            color: Colors.grey.shade600), // Soft grey hint text
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(20.0), // Rounded corners
                          borderSide: BorderSide(
                              color: Colors.blue.shade200,
                              width: 1.5), // Light blue border
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(
                              color: Colors.blue.shade200, width: 1.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(
                              color: Colors.blue.shade700,
                              width: 2.0), // Focused border in theme color
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 14.0), // Padding for spacious feel
                      ),
                      onChanged: (value) {
                        setState(() {
                          _maxPrice =
                              value.isNotEmpty ? double.parse(value) : null;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            // Resource list section
            Expanded(
              child: Consumer<ResourceProvider>(
                builder: (context, resourceProvider, _) {
                  if (_isLoading || resourceProvider.isLoading) {
                    return const Center(
                        child:
                            CircularProgressIndicator()); // Show loading indicator while fetching
                  }

                  if (resourceProvider.resources.isEmpty) {
                    return const Center(child: Text('No resources available.'));
                  }
                  if (resourceProvider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (resourceProvider.resources.isEmpty) {
                    return const Center(child: Text('No resources available.'));
                  }

                  // Log the resources and the filter parameters
                  print('Resource count: ${resourceProvider.resources.length}');
                  print(
                      'Applying price filters: Min Price = $_minPrice, Max Price = $_maxPrice');

                  // Log the price of each resource
                  for (var resource in resourceProvider.resources) {
                    var price = resource['price']; // Assuming resource is a Map
                    print('Resource Price: $price');
                  }

                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ResourceListWidget(
                      searchQuery: searchQuery,
                      userId: userId ?? '',
                      user: widget.user, // Pass the extracted userId here
                      minPrice: _minPrice,
                      maxPrice: _maxPrice,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Stack(
                children: [
                  Icon(Icons.shopping_cart),
                  if (Provider.of<CartProvider>(context).cartItems.isNotEmpty)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: CircleAvatar(
                        radius: 8,
                        backgroundColor: Colors.red,
                        child: Text(
                          '${Provider.of<CartProvider>(context).cartItems.length}', // Display number of items in cart
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              label: 'Cart',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'Order History',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          selectedItemColor: const Color(0xFF7C4DFF),
          unselectedItemColor: Colors.grey,
        ),
      ),
    );
  }
}
