import 'package:flutter/material.dart';
import '../orders/cart_page.dart';

class CartButton extends StatelessWidget {
  final String userId;

  const CartButton({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.shopping_cart, color: Colors.deepPurple),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CartPage(userId: userId)),
        );
      },
    );
  }
}
