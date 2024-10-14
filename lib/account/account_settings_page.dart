import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountSettingsPage extends StatelessWidget {
  const AccountSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Account Settings',
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
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 60.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 80),
            _buildSettingsOption(
              context,
              icon: Icons.logout,
              title: 'Log Out',
              onTap: () {
                _showLogoutDialog(context);
              },
            ),
            const SizedBox(height: 20),
            _buildSettingsOption(
              context,
              icon: Icons.delete,
              title: 'Delete Account',
              onTap: () {
                _showDeleteAccountDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsOption(
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

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Log Out",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          content: const Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () async {
                // Log out and clear shared preferences
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove('loggedInUserId'); // Clear session
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: const Text(
                "Yes",
                style: TextStyle(color: Color(0xFF7C4DFF)),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Delete Account",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          content: const Text(
              "Are you sure you want to delete your account? This action cannot be undone."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () async {
                // Delete account logic here (pseudo code)
                // await MongoDatabase.deleteAccount(userId);
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove('loggedInUserId'); // Clear session
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/register');
              },
              child: const Text(
                "Yes",
                style: TextStyle(color: Color(0xFF7C4DFF)),
              ),
            ),
          ],
        );
      },
    );
  }
}
