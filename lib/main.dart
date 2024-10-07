import 'package:flutter/material.dart';
import 'package:flutter_application_1/mongo_service.dart';
import 'auth/login_page.dart'; // Ensure this import is correct

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MongoDatabase.connect();
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
    ); // Added closing parenthesis here
  }
}
