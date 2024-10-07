import 'package:flutter/material.dart';
import '../account/profile_page.dart';

class PersonalInfoPage extends StatefulWidget {
  final Map<String, dynamic> user; // Add user parameter

  const PersonalInfoPage({Key? key, required this.user}) : super(key: key);

  @override
  _PersonalInfoPageState createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  late TextEditingController _nameController;
  late TextEditingController _mobileController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with user data
    _nameController = TextEditingController(text: widget.user['name']);
    _mobileController = TextEditingController(text: widget.user['mobile']);
    _emailController = TextEditingController(text: widget.user['email']);
    _addressController = TextEditingController(text: widget.user['address']);
  }

  void _saveInfo(BuildContext context) {
    String savedName = _nameController.text;
    String savedMobile = _mobileController.text;
    String savedEmail = _emailController.text;
    String savedAddress = _addressController.text;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Details Saved:\nName: $savedName\nMobile: $savedMobile\nEmail: $savedEmail\nAddress: $savedAddress'),
      ),
    );

    Map<String, dynamic> user = {
      'name': savedName,
      'mobile': savedMobile,
      'email': savedEmail,
      'address': savedAddress,
    };

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ProfilePage(user: user)),
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
              const SizedBox(height: 80),
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
                  _saveInfo(context);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF7C4DFF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
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
