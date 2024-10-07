import 'package:flutter/material.dart';
import 'package:flutter_application_1/orders/order_history_page.dart'
    as orderHistory;
import 'package:flutter_application_1/orders/cart_page.dart' as cart;
import 'package:flutter_application_1/account/personal_info_page.dart';
import 'package:flutter_application_1/account/account_settings_page.dart';
import 'package:flutter_application_1/home/home_page.dart' as home;

class ProfilePage extends StatelessWidget {
  final Map<String, dynamic> user; // Store user data

  const ProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontSize: 24),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFB388FF), Color(0xFF7C4DFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 80), // Adjust space for AppBar
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 50, color: Color(0xFF7C4DFF)),
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                user['name'] ?? 'No Name', // Display user name
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Center(
              child: Text(
                user['email'] ?? 'No Email', // Display user email
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
            ),
            const SizedBox(height: 30),
            _buildProfileOption(
              context,
              icon: Icons.history,
              title: 'Order History',
              onTap: () {
                // Pass userId when navigating
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => orderHistory.OrderHistoryPage(
                      userId:
                          user['_id'] ?? '', // Assuming '_id' is the user ID
                    ),
                  ),
                );
              },
            ),
            _buildProfileOption(
              context,
              icon: Icons.person,
              title: 'Personal Information',
              onTap: () {
                // Pass user data to PersonalInfoPage
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        PersonalInfoPage(user: user), // Pass user data
                  ),
                );
              },
            ),
            _buildProfileOption(
              context,
              icon: Icons.settings,
              title: 'Account Settings',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AccountSettingsPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex:
            3, // Set this to the correct index based on the current page (Profile is 3)
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          switch (index) {
            case 0:
              // Pass the user object to HomePage
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => home.HomePage(
                    user: user, // Navigate to HomePage with user
                  ),
                ),
              );
              break;
            case 1:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => cart.CartPage(
                    userId: user['_id'] ?? '', // Pass userId to CartPage
                  ),
                ),
              );
              break;
            case 2:
              // Pass userId when navigating
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => orderHistory.OrderHistoryPage(
                    userId: user['_id'] ?? '', // Assuming '_id' is the user ID
                  ),
                ),
              );
              break;
            case 3:
              // Already on Profile page
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Order History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 5,
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF7C4DFF)),
        title: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
