import 'package:flutter/material.dart';
import '../orders/cart_page.dart';

class CartButton extends StatelessWidget {
  final String userId;

  const CartButton({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.shopping_cart),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CartPage(userId: userId)),
        );
      },
    );
  }
}
