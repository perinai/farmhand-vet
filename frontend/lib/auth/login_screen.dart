// lib/auth/login_screen.dart

import 'package:flutter/material.dart';
import 'package:frontend/api/api_service.dart'; // Import the new service
import 'package:frontend/home/home_screen.dart'; // <-- ADD THIS LINE
import 'package:frontend/auth/register_screen.dart'; // <-- ADD THIS LINE

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Create an instance of our ApiService
  final ApiService _apiService = ApiService();

  // A new variable to track loading state
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // --- Updated Login Function ---
  Future<void> _login() async {
    // Check if the form fields are valid
    if (_formKey.currentState!.validate()) {
      // Set loading state to true to show a progress indicator
      setState(() {
        _isLoading = true;
      });

      // Call the login method from our ApiService
      final result = await _apiService.login(
        _emailController.text,
        _passwordController.text,
      );

      // Set loading state back to false
      setState(() {
        _isLoading = false;
      });

      // --- Show the result to the user ---
      // NEW CODE
      if (result['success']) {
        // On success, navigate to the HomeScreen.
        // NEW CODE in login_screen.dart
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        // On failure, show a red snackbar with the error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login Failed: ${result['message']}'),
            backgroundColor: Colors.red,
          ),
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
                  const Icon(Icons.pets, size: 80, color: Colors.green),
                  const SizedBox(height: 20),
                  const Text('Welcome to VetLig', textAlign: TextAlign.center, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  const Text('Connecting Farmers and Vets', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Colors.grey)),
                  const SizedBox(height: 40),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(prefixIcon: Icon(Icons.email_outlined), labelText: 'Email', hintText: 'you@example.com', filled: true, fillColor: Colors.white),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty || !value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(prefixIcon: Icon(Icons.lock_outline), labelText: 'Password', filled: true, fillColor: Colors.white),
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // --- Updated Login Button ---
                  // Show a circular progress indicator if loading, otherwise show the button
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: _login,
                          style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16), textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          child: const Text('Login'),
                        ),
                  
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      // NEW CODE
                      TextButton(
                        onPressed: () {
                          // Navigate to the RegisterScreen
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => const RegisterScreen()),
                          );
                        },
                        child: const Text('Register Now'),
                      ),
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