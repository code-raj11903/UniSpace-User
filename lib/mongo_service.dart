import 'dart:developer';
import 'package:mongo_dart/mongo_dart.dart';
import 'cart/cart_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MongoDatabase {
  static late Db db;
  static late DbCollection resourceCollection;
  static const String uri =
      'mongodb+srv://tremortech15:database15@cluster0.crcga.mongodb.net/UniSpace?retryWrites=true&w=majority&appName=Cluster0';
  static const String userCollectionName = "users";
  static const String resourceCollectionName = "resources";
  static const String cartCollectionName = "cart";
  static const String orderCollectionName = "orders";
  static const String instituteCollectionName = "institutes";
  static const String departmentCollectionName = "departments";
  // Method to connect to the MongoDB database
  static Future<String> connect() async {
    try {
      db = await Db.create(uri);
      await db.open();
      resourceCollection = db.collection(
          resourceCollectionName); // Use the constant collection name
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
    print('Saving userId in SharedPreferences: $userId');

    bool isSaved = await prefs.setString('userId', userId);
    if (isSaved) {
      print('UserId saved successfully');
    } else {
      print('Error saving userId to SharedPreferences');
    }
  }

  static Future<void> clearUserLogin() async {
    final prefs = await SharedPreferences.getInstance();
    print('Clearing SharedPreferences');
    await prefs.remove('isLoggedIn');
    await prefs.remove('userId');
    print('SharedPreferences cleared.');
  }

  void testSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Saving userId
    String testUserId = 'testUserId123';
    print('Saving testUserId: $testUserId');
    await prefs.setString('userId', testUserId);

    // Retrieving userId
    String? retrievedUserId = prefs.getString('userId');
    print('Retrieved userId: $retrievedUserId');
  }

  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    print('Retrieved userId from SharedPreferences: $userId');
    return userId;
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

  static DateTime getISTDateTime(DateTime utcTime) {
    return utcTime
        .toUtc()
        .add(Duration(hours: 5, minutes: 30)); // Convert UTC to IST
  }

  static Future<Map<String, dynamic>?> getUserById(String userId) async {
    try {
      await _ensureConnection();
      String userdetail =
          userId.toString().replaceAll('ObjectId("', '').replaceAll('")', '');

      if (!_validateObjectId(userdetail)) {
        throw Exception('Invalid userId: Expected 24 characters. $userdetail');
      }

      // Fetch user using ObjectId from the user collection
      var userCollection = db.collection(userCollectionName);
      var user = await userCollection
          .findOne(where.id(ObjectId.fromHexString(userdetail)));

      if (user != null) {
        return {
          'id': user['_id'].toString(),
          'name': user['name'],
          'mobile': user['mobile'],
          'email': user['email'],
          'address': user['address'],
        };
      }

      return null; // Return null if no user is found
    } catch (e) {
      print('Error fetching user by ID: $e');
      return null;
    }
  }

  static Future<void> updateUser(
      String userId, Map<String, dynamic> updatedUser) async {
    try {
      await _ensureConnection();
      String userdetail =
          userId.toString().replaceAll('ObjectId("', '').replaceAll('")', '');

      if (!_validateObjectId(userdetail)) {
        throw Exception('Invalid userId: Expected 24 characters. $userdetail');
      }

      var userCollection = db.collection(userCollectionName);
      await userCollection.updateOne(
        where.id(ObjectId.fromHexString(userdetail)),
        modify
            .set('name', updatedUser['name'])
            .set('mobile', updatedUser['mobile'])
            .set('email', updatedUser['email'])
            .set('address', updatedUser['address']),
      );
    } catch (e) {
      print('Error updating user: $e');
      throw Exception('Failed to update user details.');
    }
  }

  // Method to fetch resources
  static Future<List<Map<String, dynamic>>> fetchResources() async {
    try {
      await _ensureConnection();
      var collection = db.collection(resourceCollectionName);
      return await collection
          .find(where
              .eq('availability', true)
              .sortBy('createdAt', descending: true))
          .toList();
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
  static Future<String> addToCart(String userId, CartItem newItem) async {
    try {
      await _ensureConnection();

      if (!_validateObjectId(userId)) {
        throw Exception('Invalid userId: Expected 24 characters.');
      }
      String pid = newItem.productId
          .toString()
          .replaceAll('ObjectId("', '')
          .replaceAll('")', '');
      var collection = db.collection(cartCollectionName);
      var existingCart = await collection
          .findOne(where.eq('user_id', ObjectId.fromHexString(userId)));

      // Fetch the institute_id for the new item being added
      var newResource = await db
          .collection(resourceCollectionName)
          .findOne(where.id(ObjectId.fromHexString(pid)));

      if (newResource == null) {
        return 'Resource not found';
      }

      String newItemInstitute =
          newResource['institute_id'].toString(); // Ensure this is a string

      // Check if the cart already contains items
      if (existingCart != null && existingCart['items'].isNotEmpty) {
        // Get the first item's product ID from the cart
        var firstItem = existingCart['items'][0];
        String firstItemProductId =
            firstItem['productId'].toString(); // Ensure this is a string

        // Fetch the institute_id for the first item in the cart from the resources collection
        var firstResource = await db
            .collection(resourceCollectionName)
            .findOne(where.id(ObjectId.fromHexString(firstItemProductId)));

        if (firstResource == null) {
          return 'Resource not found';
        }

        String firstItemInstitute =
            firstResource['institute_id'].toString(); // Ensure this is a string

        // Check if the new item's institute is the same as the first item's institute
        if (firstItemInstitute != newItemInstitute) {
          return 'You can only add resources from the same institute. Please remove the previous items or complete your purchase.';
        }
      }

      // If no items in the cart or from the same institute, add the new item
      if (existingCart == null) {
        await collection.insertOne({
          'user_id': ObjectId.fromHexString(userId),
          'items': [newItem.toMap()],
        });
        return 'Cart created and item added successfully!';
      } else {
        bool itemExists = existingCart['items']
            .any((cartItem) => cartItem['productId'] == pid);

        if (itemExists) {
          await collection.update(
            where
                .eq('user_id', ObjectId.fromHexString(userId))
                .and(where.eq('items.productId', pid)),
            modify.inc('items.\$.[].quantity', 1),
          );
          return 'Item quantity updated in cart successfully!';
        } else {
          await collection.update(
            where.eq('user_id', ObjectId.fromHexString(userId)),
            modify.push('items', newItem.toMap()),
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

      String usercart =
          userId.toString().replaceAll('ObjectId("', '').replaceAll('")', '');

      if (!_validateObjectId(usercart)) {
        throw Exception('Invalid userId: Expected 24 characters. $usercart');
      }

      var collection = db.collection(cartCollectionName);
      var cart = await collection
          .findOne(where.eq('user_id', ObjectId.fromHexString(usercart)));

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

      // Find the user's cart
      var userCart = await collection
          .findOne(where.eq('user_id', ObjectId.fromHexString(userId)));

      if (userCart == null) {
        return 'Cart not found for the user.';
      }

      // Remove the item based on productId
      var updateResult = await collection.update(
        where.eq('user_id', ObjectId.fromHexString(userId)),
        modify.pull('items', {
          'productId': productId
        }), // Remove the item with matching productId
      );

      if (updateResult['nModified'] > 0) {
        return 'Item removed from cart successfully!';
      } else {
        return 'Failed to remove item from cart or item not found.';
      }
    } catch (e) {
      return 'Failed to remove item from cart: $e';
    }
  }

  // Method to clear the cart (e.g., after a purchase)
  static Future<String> clearCart(String userId) async {
    try {
      await _ensureConnection();
      String usercart =
          userId.toString().replaceAll('ObjectId("', '').replaceAll('")', '');

      if (!_validateObjectId(usercart)) {
        throw Exception('Invalid userId: Expected 24 characters. $usercart');
      }

      var collection = db.collection(cartCollectionName);
      await collection.update(
        where.eq('user_id', ObjectId.fromHexString(usercart)),
        modify.set('items', []),
      );

      return 'Cart cleared successfully!';
    } catch (e) {
      return 'Failed to clear cart: $e';
    }
  }

  // Updated booking method with rollback on failure
  static Future<String> bookResource(
      String resourceId, DateTime startDate, DateTime endDate) async {
    try {
      print(
          'Booking resource with ID: $resourceId from $startDate to $endDate');

      await _ensureConnection();
      print('MongoDB connection established for resource booking.');

      if (!_validateObjectId(resourceId)) {
        print('Invalid resourceId: Expected 24 characters.');
        throw Exception('Invalid resourceId: Expected 24 characters.');
      }

      // Accessing the collection where the resources are stored
      var collection = db.collection(resourceCollectionName);

      // Updating the resource availability and setting the start and end dates
      var result = await collection.updateOne(
          where.eq('_id', ObjectId.fromHexString(resourceId)),
          modify.set('availability', false));

      if (result.isAcknowledged && result.nModified > 0) {
        print('Resource booked successfully.');
        return 'Resource booked successfully!';
      } else {
        print(
            'Failed to book resource: Resource may not exist or is already booked.');
        return 'Failed to book resource: Resource may not exist or is already booked.';
      }
    } catch (e) {
      print('Failed to book resource: $e');
      return 'Failed to book resource: $e';
    }
  }

// Updated method to save order instead of booking
  static Future<String> saveOrder(String userId, List<String> resourceIds,
      double totalAmount, DateTime startDate, DateTime endDate) async {
    try {
      await _ensureConnection();
      print('MongoDB connection is active.');

      if (!_validateObjectId(userId)) {
        print('Invalid userId: Expected 24 characters.');
        throw Exception('Invalid userId: Expected 24 characters.');
      }
      double duration = endDate.difference(startDate).inDays + 1;
      if (duration <= 0) {
        throw Exception('Invalid date range: endDate must be after startDate.');
      }
      totalAmount = totalAmount * duration;
      // Convert startDate, endDate, and current date to IST
      startDate = getISTDateTime(startDate); // Convert to IST
      endDate = getISTDateTime(endDate); // Convert to IST
      DateTime currentDate = getISTDateTime(DateTime.now());
      // Prepare order data for the orders collection
      var orderData = {
        'user_id': ObjectId.fromHexString(userId),
        'resource_ids':
            resourceIds.map((id) => ObjectId.fromHexString(id)).toList(),
        'status': 'Confirmed',
        'date': DateTime.now(),
        'total_amount': totalAmount,
        'payment_status': 'Completed',
        'start_date': startDate, // Add start date
        'end_date': endDate, // Add end date
      };

      // Initialize collections
      var orderCollection = db.collection(orderCollectionName);
      var userCollection = db.collection(userCollectionName);
      var instituteCollection = db.collection(instituteCollectionName);
      var departmentCollection = db.collection(departmentCollectionName);
      var resourceCollection = db.collection(resourceCollectionName);

      var orderResult = await orderCollection.insertOne(orderData);

      if (orderResult.isAcknowledged) {
        print('Order saved successfully!');
        var orderId = orderResult.id;

        var updateResult = await userCollection.updateOne(
          where.id(ObjectId.fromHexString(userId)),
          modify.push('bookings', {'order_id': orderId}),
        );

        if (updateResult.isAcknowledged && updateResult.nModified > 0) {
          print('User booking history updated successfully!');
        } else {
          print('Order saved, but failed to update user booking history.');
        }

        for (var resourceId in resourceIds) {
          var resource = await resourceCollection
              .findOne(where.id(ObjectId.fromHexString(resourceId)));
          if (resource != null) {
            var instituteId = resource['institute_id'];
            var departmentId = resource['department_id'];
            print('Fetched institute ID: $instituteId');
            print('Fetched department ID: $departmentId');
            instituteId = instituteId
                .toString()
                .replaceAll('ObjectId("', '')
                .replaceAll('")', '');
            departmentId = departmentId
                .toString()
                .replaceAll('ObjectId("', '')
                .replaceAll('")', '');
            if (instituteId != null) {
              await instituteCollection.updateOne(
                where.id(ObjectId.fromHexString(instituteId.toString())),
                modify.push('orders', orderId),
              );
              print('Order added to institute.');
            }

            if (departmentId != null) {
              await departmentCollection.updateOne(
                where.id(ObjectId.fromHexString(departmentId.toString())),
                modify.push('orders', orderId),
              );
              print('Order added to department.');
            }
          }
        }

        return 'Order and references updated successfully!';
      } else {
        print('Failed to save order!');
        return 'Failed to save order!';
      }
    } catch (e) {
      print('Error occurred while saving order: $e');
      return 'Failed to save order: $e';
    }
  }

  // Method to fetch orders instead of bookings
  static Future<List<Map<String, dynamic>>> getOrderHistory(
      String userId) async {
    try {
      await _ensureConnection();

      if (!_validateObjectId(userId)) {
        throw Exception('Invalid userId: Expected 24 characters.');
      }

      var orderCollection = db.collection(orderCollectionName);

      return await orderCollection
          .find(where.eq('user_id', ObjectId.fromHexString(userId)))
          .toList();
    } catch (e) {
      return Future.error('Failed to fetch order history: $e');
    }
  }

  static Future<Map<String, dynamic>?> getResourceDetailsById(
      String resourceId) async {
    await _ensureConnection(); // Ensure database connection

    try {
      // Ensure resourceId is just a plain hexadecimal string (24 characters)
      String cleanedResourceId = resourceId
          .toString()
          .replaceAll('ObjectId("', '')
          .replaceAll('")', '');

      print('Searching resource collection for resourceId: $cleanedResourceId');

      // Fetch resource using ObjectId from the resource collection
      var resource = await db
          .collection(resourceCollectionName)
          .findOne(where.id(ObjectId.fromHexString(cleanedResourceId)));

      if (resource != null) {
        print('Resource details found for resourceId: $cleanedResourceId');
        return resource; // Return the fetched resource details
      } else {
        print('Resource details not found for resourceId: $cleanedResourceId');
        return null; // Return null if resource is not found
      }
    } catch (e) {
      print("Error fetching resource details: $e");
      return null; // Handle error and return null
    }
  }
}
