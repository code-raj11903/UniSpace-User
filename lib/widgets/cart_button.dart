import 'package:flutter/material.dart';
import '../orders/cart_page.dart';

class CartButton extends StatelessWidget {
  final String userId;
  final Map<String, dynamic> user;
  final Map<String, dynamic> resource;

  const CartButton(
      {super.key,
      required this.userId,
      required this.user,
      required this.resource});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.shopping_cart, color: Colors.deepPurple),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CartPage(
                    userId: userId,
                    user: user,
                  )),
        );
      },
    );
  }
}
