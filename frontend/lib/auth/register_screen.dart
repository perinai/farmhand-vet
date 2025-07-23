// lib/auth/register_screen.dart

import 'package:flutter/material.dart';
import 'package:frontend/api/api_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  String _selectedUserType = 'farmer'; // Default selection
  bool _isLoading = false;
  final ApiService _apiService = ApiService();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() { _isLoading = true; });

      final result = await _apiService.register(
        email: _emailController.text,
        password: _passwordController.text,
        fullName: _nameController.text,
        phoneNumber: _phoneController.text,
        userType: _selectedUserType,
      );

      setState(() { _isLoading = false; });

      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration Successful! Please log in.'), backgroundColor: Colors.green),
        );
        // Go back to the login screen after successful registration
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration Failed: ${result['message']}'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('Create Your Account', textAlign: TextAlign.center, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 30),
                  
                  // Form Fields
                  TextFormField(controller: _nameController, decoration: const InputDecoration(labelText: 'Full Name', filled: true, fillColor: Colors.white), validator: (v) => v!.isEmpty ? 'Please enter your name' : null),
                  const SizedBox(height: 16),
                  TextFormField(controller: _emailController, decoration: const InputDecoration(labelText: 'Email', filled: true, fillColor: Colors.white), keyboardType: TextInputType.emailAddress, validator: (v) => v!.isEmpty || !v.contains('@') ? 'Please enter a valid email' : null),
                  const SizedBox(height: 16),
                  TextFormField(controller: _phoneController, decoration: const InputDecoration(labelText: 'Phone Number', filled: true, fillColor: Colors.white), keyboardType: TextInputType.phone, validator: (v) => v!.isEmpty ? 'Please enter a phone number' : null),
                  const SizedBox(height: 16),
                  TextFormField(controller: _passwordController, obscureText: true, decoration: const InputDecoration(labelText: 'Password', filled: true, fillColor: Colors.white), validator: (v) => v!.isEmpty || v.length < 6 ? 'Password must be at least 6 characters' : null),
                  const SizedBox(height: 20),
                  
                  // User Type Selector
                  const Text('I am a:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  DropdownButtonFormField<String>(
                    value: _selectedUserType,
                    items: const [
                      DropdownMenuItem(value: 'farmer', child: Text('Farmer')),
                      DropdownMenuItem(value: 'vet', child: Text('Veterinarian')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedUserType = value!;
                      });
                    },
                    decoration: const InputDecoration(filled: true, fillColor: Colors.white),
                  ),
                  const SizedBox(height: 24),

                  // Register Button
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(onPressed: _register, style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16), textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), child: const Text('Register')),
                  
                  // Login Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account?"),
                      TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Login')),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}