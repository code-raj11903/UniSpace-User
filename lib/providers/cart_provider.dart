import 'package:flutter/material.dart';
import '../mongo_service.dart';
import '../cart/cart_item.dart';

class CartProvider extends ChangeNotifier {
  List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;

  double get totalPrice {
    return _cartItems.fold(
        0.0, (total, item) => total + (item.price * item.quantity));
  }

  Future<void> loadCartItems(String userId) async {
    try {
      final items = await MongoDatabase.getCartItems(userId);
      _cartItems = items.map((item) => CartItem.fromMap(item)).toList();
      notifyListeners();
    } catch (e) {
      print("Failed to load cart items: $e");
    }
  }

  Future<void> addToCart(String userId, CartItem item) async {
    try {
      await MongoDatabase.addToCart(userId, item);
      await loadCartItems(userId); // Refresh the cart items after adding
    } catch (e) {
      print("Failed to add item to cart: $e");
    }
  }

  Future<void> removeFromCart(String userId, String productId) async {
    try {
      await MongoDatabase.removeFromCart(userId, productId);
      await loadCartItems(userId); // Refresh the cart items after removal
    } catch (e) {
      print("Failed to remove item from cart: $e");
    }
  }
}
