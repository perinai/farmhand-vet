// lib/core/auth_check_screen.dart

import 'package:flutter/material.dart';
import 'package:frontend/core/secure_storage_service.dart';

class AuthCheckScreen extends StatefulWidget {
  const AuthCheckScreen({super.key});

  @override
  State<AuthCheckScreen> createState() => _AuthCheckScreenState();
}

class _AuthCheckScreenState extends State<AuthCheckScreen> {
  final SecureStorageService _storageService = SecureStorageService();

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    // Give the UI a moment to build before navigating
    await Future.delayed(const Duration(seconds: 1)); 

    final token = await _storageService.readToken();

    if (mounted) { // Check if the widget is still in the tree
      if (token != null && token.isNotEmpty) {
        // If token exists, go to home screen
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        // If no token, go to login screen
        Navigator.of(context).pushReplacementNamed('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show a simple loading indicator while we check
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}