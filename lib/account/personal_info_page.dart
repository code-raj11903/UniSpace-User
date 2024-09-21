import 'package:flutter/material.dart';
import 'profile_page.dart';

class PersonalInfoPage extends StatefulWidget {
  const PersonalInfoPage({super.key});

  @override
  _PersonalInfoPageState createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  final TextEditingController _nameController = TextEditingController(text: 'John Doe');
  final TextEditingController _mobileController = TextEditingController(text: '+1234567890');
  final TextEditingController _emailController = TextEditingController(text: 'john.doe@example.com');
  final TextEditingController _addressController = TextEditingController(text: '123 Main St');

  void _saveInfo(BuildContext context) {
    // Logic to save user info (you can update this with backend API calls)
    String savedName = _nameController.text;
    String savedMobile = _mobileController.text;
    String savedEmail = _emailController.text;
    String savedAddress = _addressController.text;

    // Show confirmation message with the saved details
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Details Saved:\nName: $savedName\nMobile: $savedMobile\nEmail: $savedEmail\nAddress: $savedAddress'),
      ),
    );

    // Redirect back to Profile Page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ProfilePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Personal Information',
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 80), // Space for AppBar
              const Text(
                'Edit Your Information',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              _buildTextField(
                label: 'Full Name',
                controller: _nameController,
                icon: Icons.person,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                label: 'Mobile Number',
                controller: _mobileController,
                icon: Icons.phone,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                label: 'Email',
                controller: _emailController,
                icon: Icons.email,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                label: 'Address',
                controller: _addressController,
                icon: Icons.home,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  _saveInfo(context); // Save and Redirect to Profile Page
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF7C4DFF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Save',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        prefixIcon: Icon(icon, color: const Color(0xFF7C4DFF)),
      ),
    );
  }
}
