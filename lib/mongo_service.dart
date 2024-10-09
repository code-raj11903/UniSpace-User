import 'dart:developer';
import 'package:mongo_dart/mongo_dart.dart';
import 'cart/cart_item.dart';

class MongoDatabase {
  static late Db db;

  // MongoDB URI and collection names
  static const String uri =
      'mongodb+srv://tremortech15:database15@cluster0.crcga.mongodb.net/UniSpace?retryWrites=true&w=majority&appName=Cluster0';
  static const String userCollectionName = "users";
  static const String resourceCollectionName = "resources";
  static const String orderCollectionName = "orders";
  static const String cartCollectionName =
      "cart"; // Added for cart functionality

  // Method to connect to the MongoDB database
  static Future<String> connect() async {
    try {
      db = await Db.create(uri);
      await db.open();
      inspect(db);
      return 'Connection successful!';
    } catch (e) {
      return 'Connection failed: $e';
    }
  }

  // Ensure database connection before performing any operation
  static Future<void> _ensureConnection() async {
    if (db.state != State.OPEN) {
      await connect();
    }
  }

  // Method to insert a document into a collection
  static Future<String> insertDocument(
      String collectionName, Map<String, dynamic> document) async {
    try {
      await _ensureConnection();
      var collection = db.collection(collectionName);
      document.remove('_id'); // Ensure no _id is included
      await collection.insertOne(document);
      return 'Document inserted successfully!';
    } catch (e) {
      return 'Insertion failed: $e';
    }
  }

  // Method to find documents in a collection
  static Future<List<Map<String, dynamic>>> findDocuments(
      String collectionName) async {
    try {
      await _ensureConnection();
      var collection = db.collection(collectionName);
      return await collection.find().toList();
    } catch (e) {
      throw Exception('Failed to fetch documents: $e');
    }
  }

  // Method to authenticate a user
  static Future<Map<String, dynamic>?> authenticateUser(
      String email, String password) async {
    try {
      await _ensureConnection();
      var collection = db.collection(userCollectionName);
      var user = await collection
          .findOne(where.eq('email', email).eq('password', password));

      if (user != null) {
        return {
          'id': user['_id'].toString(), // Convert ObjectId to String
          'name': user['name'],
          'email': user['email'],
          'mobile': user['phone'],
          'address': user['address'],
          'creationDate': user['createdAt'],
        };
      }
      return null;
    } catch (e) {
      throw Exception('Authentication failed: $e');
    }
  }

  // Method to fetch resources
  static Future<List<Map<String, dynamic>>> fetchResources() async {
    try {
      await _ensureConnection();
      var collection = db.collection(resourceCollectionName);
      // Fetch only available resources
      return await collection.find(where.eq('availability', true)).toList();
    } catch (e) {
      throw Exception('Failed to fetch resources: $e');
    }
  }

  // Method to get user orders
  static Future<List<Map<String, dynamic>>> getUserOrders(String userId) async {
    try {
      await _ensureConnection();

      // Log the user ID for debugging
      print("User ID: $userId");

      // Check if userId is a valid ObjectId
      if (userId.length != 24) {
        throw Exception(
            'Invalid userId: Expected 24 characters, got ${userId.length}.');
      }

      var ordersCollection = db.collection(orderCollectionName);
      var orders = await ordersCollection
          .find(where.eq('user_id', ObjectId.fromHexString(userId)))
          .toList();

      return orders;
    } catch (e) {
      print("Error fetching user orders: $e"); // Log the error for debugging
      throw Exception('Failed to fetch user orders: $e');
    }
  }

  // Cart functionality
  static Future<String> addToCart(String userId, CartItem item) async {
    try {
      await _ensureConnection();

      // Check if userId is a valid ObjectId
      if (userId.length != 24) {
        throw Exception('Invalid userId: Expected 24 characters.');
      }

      var collection = db.collection(cartCollectionName);
      var existingCart = await collection
          .findOne(where.eq('user_id', ObjectId.fromHexString(userId)));

      if (existingCart == null) {
        // If the user doesn't have a cart, create a new one
        await collection.insertOne({
          'user_id': ObjectId.fromHexString(userId),
          'items': [item.toMap()],
        });
        return 'Cart created and item added successfully!';
      } else {
        // Check if the item already exists in the cart
        bool itemExists = existingCart['items']
            .any((cartItem) => cartItem['product_id'] == item.productId);
        if (itemExists) {
          // If item exists, increment the quantity
          await collection.update(
            where
                .eq('user_id', ObjectId.fromHexString(userId))
                .and(where.eq('items.product_id', item.productId)),
            modify.inc('items.\$.[].quantity', 1), // Corrected increment syntax
          );
          return 'Item quantity updated in cart successfully!';
        } else {
          // Add the item to the cart if it doesn't exist
          await collection.update(
            where.eq('user_id', ObjectId.fromHexString(userId)),
            modify.push('items', item.toMap()),
          );
          return 'Item added to cart successfully!';
        }
      }
    } catch (e) {
      return 'Failed to add item to cart: $e';
    }
  }

  static Future<List<Map<String, dynamic>>> getCartItems(String userId) async {
    try {
      await _ensureConnection();

      // Check if userId is a valid ObjectId
      if (userId.length != 24) {
        throw Exception(
            'Invalid userId: Expected 24 characters, got ${userId.length}.');
      }

      var collection = db.collection(cartCollectionName);
      var cart = await collection
          .findOne(where.eq('user_id', ObjectId.fromHexString(userId)));

      if (cart != null && cart.containsKey('items')) {
        // Ensure the 'items' key exists and is not null
        return List<Map<String, dynamic>>.from(cart['items'] ?? []);
      }
      return []; // Return an empty list if no cart or items are found
    } catch (e) {
      throw Exception('Failed to fetch cart items: $e');
    }
  }

  // Method to remove an item from the cart
  static Future<String> removeFromCart(String userId, String productId) async {
    try {
      await _ensureConnection();

      // Check if userId is a valid ObjectId
      if (userId.length != 24) {
        throw Exception(
            'Invalid userId: Expected 24 characters, got ${userId.length}.');
      }

      var collection = db.collection(cartCollectionName);

      await collection.update(
        where.eq('user_id', ObjectId.fromHexString(userId)),
        modify.pull('items', {'product_id': productId}),
      );

      return 'Item removed from cart successfully!';
    } catch (e) {
      return 'Failed to remove item from cart: $e';
    }
  }

  // Method to clear the cart (e.g., after a purchase)
  static Future<String> clearCart(String userId) async {
    try {
      await _ensureConnection();

      // Check if userId is a valid ObjectId
      if (userId.length != 24) {
        throw Exception(
            'Invalid userId: Expected 24 characters, got ${userId.length}.');
      }

      var collection = db.collection(cartCollectionName);

      await collection.update(
        where.eq('user_id', ObjectId.fromHexString(userId)),
        modify.set('items', []),
      );

      return 'Cart cleared successfully!';
    } catch (e) {
      return 'Failed to clear cart: $e';
    }
  }

  // Method to close the database connection
  static Future<void> close() async {
    if (db.state == State.OPEN) {
      await db.close();
      print("Database connection closed.");
    } else {
      print("No database connection to close.");
    }
  }

  // Method to book a resource and update its availability
  static Future<String> bookResource(String resourceId) async {
    try {
      await _ensureConnection();
      // Check if resourceId is a valid ObjectId
      if (resourceId.length != 24) {
        throw Exception('Invalid resourceId: Expected 24 characters.');
      }

      // Log the resourceId being passed
      print("Attempting to book Resource ID: $resourceId");

      // Set resource availability to false
      var collection = db.collection(resourceCollectionName);
      var result = await collection.updateOne(
        where.eq('_id', ObjectId.fromHexString(resourceId)),
        modify.set('availability', false),
      );

      // Log the result of the update operation
      print("Update result: ${result.toString()}");

      // Check if any document was modified
      if (result.isAcknowledged && result.nModified > 0) {
        return 'Resource booked successfully!';
      } else {
        return 'Failed to book resource: Resource may not exist or is already booked.';
      }
    } catch (e) {
      print("Error booking resource: $e"); // Log the error for debugging
      return 'Failed to book resource: $e';
    }
  }
}
