import 'package:flutter/material.dart';
import 'package:flutter_application_1/account/profile_page.dart';
import 'package:flutter_application_1/home/home_page.dart';
import 'package:flutter_application_1/orders/order_history_page.dart';
import '../providers/cart_provider.dart';
import 'package:provider/provider.dart';
import '../orders/payment_page.dart';

class CartPage extends StatefulWidget {
  final String userId;
  final Map<String, dynamic> user;

  const CartPage({super.key, required this.userId, required this.user});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  int _selectedIndex = 1; // Start at cart page index

  @override
  void initState() {
    super.initState();
    print("Loading cart items for user ID: ${widget.userId}");
    final dynamic objectId = widget.user['id'];
    final userId =
        objectId.toString().replaceAll('ObjectId("', '').replaceAll('")', '');

    if (userId!.isNotEmpty) {
      Provider.of<CartProvider>(context, listen: false).loadCartItems(userId!);
    }
    Provider.of<CartProvider>(context, listen: false)
        .loadCartItems(widget.userId);
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;

    setState(() {
      _selectedIndex = index;
    });
    final dynamic objectId = widget.user['id'];
    final userId =
        objectId.toString().replaceAll('ObjectId("', '').replaceAll('")', '');

    if (userId.isEmpty) {
      print('Error: userId is null or empty');
      return;
    }

    print('Navigating with userId: $userId');
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(user: widget.user),
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
    return Consumer<CartProvider>(builder: (context, cartProvider, child) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Your Cart'),
          centerTitle: true,
        ),
        body: cartProvider.cartItems.isEmpty
            ? const Center(
                child: Text(
                  'Your cart is empty.',
                  style: TextStyle(fontSize: 18, color: Colors.black54),
                ),
              )
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: cartProvider.cartItems.length,
                      itemBuilder: (context, index) {
                        final item = cartProvider.cartItems[index];
                        return Card(
                          margin: const EdgeInsets.all(12.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 4,
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  bottomLeft: Radius.circular(15),
                                ),
                                child: Image.network(
                                  item.imageUrl ??
                                      'https://via.placeholder.com/150',
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.image_not_supported,
                                      size: 100,
                                      color: Colors.grey,
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.name,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        'Price: ₹${item.price.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.green,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        'Quantity: ${item.quantity}',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.remove_circle,
                                    color: Colors.red),
                                onPressed: () {
                                  cartProvider.removeFromCart(
                                      widget.userId, item.productId);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          '${item.name} removed from cart'),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  // Price Container
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 24.0),
                    child: Container(
                      padding: const EdgeInsets.all(12.0), // Reduced padding
                      decoration: BoxDecoration(
                        color: Colors.blueAccent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total:',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '₹${cartProvider.totalPrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Spacer to add space for Buy Now button
                  const SizedBox(height: 8), // Reduced height
                  // Centered "Buy Now" Button
                  if (cartProvider.cartItems.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Container(
                        width:
                            double.infinity, // Make the button take full width
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PaymentPage(
                                  userId: widget.userId,
                                  cartItems: cartProvider.cartItems,
                                  totalAmount: cartProvider.totalPrice,
                                  user: widget.user,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Proceed to Payment',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
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
                          '${Provider.of<CartProvider>(context).cartItems.length}',
                          style: TextStyle(fontSize: 12, color: Colors.white),
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
      );
    });
  }
}
