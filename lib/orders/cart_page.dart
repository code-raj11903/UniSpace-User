import 'package:flutter/material.dart';
import '../mongo_service.dart';
import '../cart/cart_item.dart';
import '../orders/order_summary_page.dart';

class CartPage extends StatefulWidget {
  final String userId;

  const CartPage({super.key, required this.userId});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<CartItem> cartItems = [];

  @override
  void initState() {
    super.initState();
    loadCart();
  }

  Future<void> loadCart() async {
    try {
      print("Loading cart for user ID: ${widget.userId}");
      if (widget.userId.length != 24) {
        throw Exception('Invalid userId format.');
      }

      // Fetch items from the MongoDB cart
      final items = await MongoDatabase.getCartItems(widget.userId);
      print("Fetched items: $items"); // Debugging: log fetched items

      // Convert fetched items to CartItem instances
      setState(() {
        cartItems = items.map((item) => CartItem.fromMap(item)).toList();
      });
    } catch (e) {
      print("Failed to load cart: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to load cart: $e')));
    }
  }

  void removeFromCart(String productId) async {
    try {
      await MongoDatabase.removeFromCart(widget.userId, productId);
      loadCart(); // Refresh the cart after removing an item
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to remove item from cart: $e')));
    }
  }

  void checkout() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => OrderSummaryPage(cartItems: cartItems)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
      ),
      body: cartItems.isEmpty
          ? const Center(child: Text('No items in cart'))
          : ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return ListTile(
                  title: Text(item.name),
                  subtitle: Text('Quantity: ${item.quantity}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_circle),
                    onPressed: () => removeFromCart(item.productId),
                  ),
                );
              },
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: cartItems.isNotEmpty ? checkout : null,
          child: const Text('Proceed to Checkout'),
        ),
      ),
    );
  }
}
