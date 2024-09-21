import 'package:flutter/material.dart';
import 'auth/login_page.dart'; // Ensure this import is correct

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UniSpace App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(), // LoginPage should now be recognized
      
);

  
  }
}
