import 'dart:developer';
import 'package:mongo_dart/mongo_dart.dart';
import 'cart/cart_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MongoDatabase {
  static late Db db;

  static const String uri =
      'mongodb+srv://tremortech15:database15@cluster0.crcga.mongodb.net/UniSpace?retryWrites=true&w=majority&appName=Cluster0';
  static const String userCollectionName = "users";
  static const String resourceCollectionName = "resources";
  static const String orderCollectionName = "orders";
  static const String cartCollectionName = "cart";
  static const String bookingCollectionName = "bookings";

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

  // Helper to validate ObjectId
  static bool _validateObjectId(String id) {
    return id.length == 24;
  }

  // User Login Persistence (Shared Preferences)
  static Future<void> saveUserLogin(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', true);
    prefs.setString('userId', userId);
  }

  static Future<void> clearUserLogin() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('isLoggedIn');
    prefs.remove('userId');
  }

  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  // Method to insert a document into a collection
  static Future<String> insertDocument(
      String collectionName, Map<String, dynamic> document) async {
    try {
      await _ensureConnection();
      var collection = db.collection(collectionName);
      document.remove('_id'); // Ensure no _id is included
      await collection.insertOne(document);
      return 'Account Created successfully!';
    } catch (e) {
      return 'Try Again: $e';
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
      throw Exception('Failed to find user: $e');
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
        await saveUserLogin(user['_id'].toString()); // Save user ID
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
      return await collection.find(where.eq('availability', true)).toList();
    } catch (e) {
      throw Exception('Failed to fetch resources: $e');
    }
  }

  // Method to get user orders
  static Future<List<Map<String, dynamic>>> getUserOrders(String userId) async {
    try {
      await _ensureConnection();

      if (!_validateObjectId(userId)) {
        throw Exception('Invalid userId: Expected 24 characters.');
      }

      var ordersCollection = db.collection(orderCollectionName);
      return await ordersCollection
          .find(where.eq('user_id', ObjectId.fromHexString(userId)))
          .toList();
    } catch (e) {
      print("Error fetching user orders: $e");
      throw Exception('Failed to fetch user orders: $e');
    }
  }

  // Cart functionality
  static Future<String> addToCart(String userId, CartItem item) async {
    try {
      await _ensureConnection();

      if (!_validateObjectId(userId)) {
        throw Exception('Invalid userId: Expected 24 characters.');
      }

      var collection = db.collection(cartCollectionName);
      var existingCart = await collection
          .findOne(where.eq('user_id', ObjectId.fromHexString(userId)));

      if (existingCart == null) {
        await collection.insertOne({
          'user_id': ObjectId.fromHexString(userId),
          'items': [item.toMap()],
        });
        return 'Cart created and item added successfully!';
      } else {
        bool itemExists = existingCart['items']
            .any((cartItem) => cartItem['product_id'] == item.productId);
        if (itemExists) {
          await collection.update(
            where
                .eq('user_id', ObjectId.fromHexString(userId))
                .and(where.eq('items.product_id', item.productId)),
            modify.inc('items.\$.[].quantity', 1),
          );
          return 'Item quantity updated in cart successfully!';
        } else {
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

      if (!_validateObjectId(userId)) {
        throw Exception('Invalid userId: Expected 24 characters.');
      }

      var collection = db.collection(cartCollectionName);
      var cart = await collection
          .findOne(where.eq('user_id', ObjectId.fromHexString(userId)));

      if (cart != null && cart.containsKey('items')) {
        return List<Map<String, dynamic>>.from(cart['items'] ?? []);
      }
      return [];
    } catch (e) {
      throw Exception('Failed to fetch cart items: $e');
    }
  }

  // Method to remove an item from the cart
  static Future<String> removeFromCart(String userId, String productId) async {
    try {
      await _ensureConnection();

      if (!_validateObjectId(userId)) {
        throw Exception('Invalid userId: Expected 24 characters.');
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

      if (!_validateObjectId(userId)) {
        throw Exception('Invalid userId: Expected 24 characters.');
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

  // Method to book a resource and update its availability
  static Future<String> bookResource(String resourceId) async {
    try {
      await _ensureConnection();
      if (!_validateObjectId(resourceId)) {
        throw Exception('Invalid resourceId: Expected 24 characters.');
      }

      var collection = db.collection(resourceCollectionName);
      var result = await collection.updateOne(
        where.eq('_id', ObjectId.fromHexString(resourceId)),
        modify.set('availability', false),
      );

      if (result.isAcknowledged && result.nModified > 0) {
        return 'Resource booked successfully!';
      } else {
        return 'Failed to book resource: Resource may not exist or is already booked.';
      }
    } catch (e) {
      return 'Failed to book resource: $e';
    }
  }

  // Method to save a booking and update user with booking history
  static Future<String> saveBooking(
      String userId, List<String> resourceIds, double totalAmount) async {
    try {
      await _ensureConnection();

      if (!_validateObjectId(userId)) {
        throw Exception('Invalid userId: Expected 24 characters.');
      }

      var bookingCollection = db.collection(bookingCollectionName);
      var bookingData = {
        'user_id': ObjectId.fromHexString(userId),
        'resource_ids':
            resourceIds.map((id) => ObjectId.fromHexString(id)).toList(),
        'status': 'Confirmed',
        'date': DateTime.now(),
        'total_amount': totalAmount,
      };

      var bookingResult = await bookingCollection.insertOne(bookingData);

      // If booking is successful, update user's bookings array
      if (bookingResult.isAcknowledged) {
        var userCollection = db.collection(userCollectionName);
        await userCollection.updateOne(
          where.eq('_id', ObjectId.fromHexString(userId)),
          modify.push('bookings', bookingResult.document!['_id']),
        );
        return 'Booking saved and user updated successfully!';
      }
      return 'Failed to save booking!';
    } catch (e) {
      return 'Failed to save booking: $e';
    }
  }

  // Method to get booking history for a user
  static Future<List<Map<String, dynamic>>> getBookingHistory(
      String userId) async {
    try {
      await _ensureConnection();

      if (!_validateObjectId(userId)) {
        throw Exception('Invalid userId: Expected 24 characters.');
      }

      var bookingCollection = db.collection(bookingCollectionName);
      return await bookingCollection
          .find(where.eq('user_id', ObjectId.fromHexString(userId)))
          .toList();
    } catch (e) {
      return Future.error('Failed to fetch booking history: $e');
    }
  }
}
