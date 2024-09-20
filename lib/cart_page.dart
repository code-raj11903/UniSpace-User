import 'package:flutter/material.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: 3, // Replace with actual cart item count
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(Icons.shopping_cart),
                  title: Text('Item ${index + 1}'),
                  subtitle: Text('Item description here'),
                  trailing: Text('Price: \$100'), // Replace with actual price
                );
              },
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                // Checkout logic
                Navigator.pushNamed(context, '/checkout');
              },
              child: Text('Proceed to Checkout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
