class CartItem {
  final String productId;
  final String name;
  final double price;
  final int quantity;
  final String? imageUrl; // New property for the item's image URL

  CartItem({
    required this.productId,
    required this.name,
    required this.price,
    required this.quantity,
    this.imageUrl,
  });

  // Create a CartItem instance from a map
  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      productId: map['productId'] as String,
      name: map['name'] as String,
      price: (map['price'] as num).toDouble(),
      quantity: map['quantity'] as int,
      imageUrl: map['imageUrl'] as String?, // Handle null case
    );
  }

  // Convert a CartItem instance to a map
  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'name': name,
      'price': price,
      'quantity': quantity,
      'imageUrl': imageUrl,
    };
  }
}
