import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/resource_provider.dart';
import 'providers/cart_provider.dart';
import 'mongo_service.dart';
import 'auth/login_page.dart'; // Ensure this import is correct
import 'home/home_page.dart'; // Import home page
import 'auth/register_page.dart'; // Import register page

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MongoDatabase.connect();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ResourceProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MaterialApp(
        title: 'UniSpace App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/login', // Set initial route
        routes: {
          '/login': (context) => const LoginPage(),
          '/register': (context) => const RegisterPage(),
          '/home': (context) => const HomePage(
              user: {},
              refresh: false), // Ensure user is passed when navigating
        },
      ),
    );
  }
}
