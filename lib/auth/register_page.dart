import 'package:flutter/material.dart';
import '../mongo_service.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isLoading = false;
  bool _showPassword = false;
  bool _showConfirmPassword = false;

  Future<void> _registerUser(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      String name = _nameController.text.trim();
      String email = _emailController.text.trim();
      String mobile = _mobileController.text.trim();

      // Concatenate address components into a single string
      String address = '${_streetController.text.trim()}, '
          '${_areaController.text.trim()}, '
          '${_cityController.text.trim()}, '
          '${_stateController.text.trim()}, '
          '${_pincodeController.text.trim()}';

      String password = _passwordController.text;

      Map<String, dynamic> user = {
        'name': name,
        'email': email,
        'mobile': mobile,
        'address': address,
        'password': password,
        'createdAt': DateTime.now().toIso8601String(),
      };

      String result = await MongoDatabase.insertDocument('users', user);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result)),
      );

      // Navigate to LoginPage on successful registration
      if (result == 'Account Created successfully!') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration failed: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFB388FF), Color(0xFF7C4DFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Register',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Full Name
                  _buildTextField('Full Name', _nameController),

                  // Email and Mobile in the same row
                  Row(
                    children: [
                      Expanded(
                          child: _buildTextField('Email', _emailController,
                              keyboardType: TextInputType.emailAddress)),
                      const SizedBox(width: 10),
                      Expanded(
                          child: _buildTextField(
                              'Mobile Number', _mobileController,
                              keyboardType: TextInputType.phone)),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Street/House No. and Area in the same row
                  Row(
                    children: [
                      Expanded(
                          child: _buildTextField(
                              'Street/House No.', _streetController)),
                      const SizedBox(width: 10),
                      Expanded(child: _buildTextField('Area', _areaController)),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // City and State in the same row
                  Row(
                    children: [
                      Expanded(child: _buildTextField('City', _cityController)),
                      const SizedBox(width: 10),
                      Expanded(
                          child: _buildTextField('State', _stateController)),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Pincode
                  _buildTextField('Pincode', _pincodeController,
                      keyboardType: TextInputType.number),

                  const SizedBox(height: 20),

                  // Password and Confirm Password in the same row
                  Row(
                    children: [
                      Expanded(
                        child: _buildPasswordField(
                            'Password', _passwordController, _showPassword, () {
                          setState(() {
                            _showPassword = !_showPassword;
                          });
                        }),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildPasswordField(
                            'Confirm Password',
                            _confirmPasswordController,
                            _showConfirmPassword, () {
                          setState(() {
                            _showConfirmPassword = !_showConfirmPassword;
                          });
                        }),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  _isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () => _registerUser(context),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: Colors.white,
                            minimumSize: const Size(200, 50),
                            foregroundColor: const Color(0xFF7C4DFF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Register',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),

                  const SizedBox(height: 20),

                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                      );
                    },
                    child: const Text(
                      'Already have an account? Login here',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text,
      bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white.withOpacity(0.9),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your $label';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller,
      bool showPassword, VoidCallback toggleVisibility) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.text,
        obscureText: !showPassword,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white.withOpacity(0.9),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          suffixIcon: IconButton(
            icon: Icon(
              showPassword ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: toggleVisibility,
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your $label';
          }
          return null;
        },
      ),
    );
  }
}
