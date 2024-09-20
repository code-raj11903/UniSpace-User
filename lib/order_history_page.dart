import 'package:flutter/material.dart';

class OrderHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order History'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFB388FF), Color(0xFF7C4DFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Completed Orders', style: TextStyle(fontSize: 20, color: Colors.white)),
            ListTile(
              leading: Icon(Icons.check_circle, color: Colors.green),
              title: Text('Order #12345', style: TextStyle(color: Colors.white)),
              subtitle: Text('Delivered on 12/09/2023', style: TextStyle(color: Colors.white70)),
            ),
            Divider(color: Colors.white54),
            Text('Cancelled Orders', style: TextStyle(fontSize: 20, color: Colors.white)),
            ListTile(
              leading: Icon(Icons.cancel, color: Colors.red),
              title: Text('Order #54321', style: TextStyle(color: Colors.white)),
              subtitle: Text('Cancelled on 10/09/2023', style: TextStyle(color: Colors.white70)),
            ),
          ],
        ),
      ),
    );
  }
}

