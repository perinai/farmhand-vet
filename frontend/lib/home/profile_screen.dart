// lib/home/profile_screen.dart

import 'package:flutter/material.dart';
import 'package:frontend/api/api_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Create an instance of the ApiService to fetch data
  final ApiService _apiService = ApiService();
  
  // This Future will hold the result of our API call
  late Future<Map<String, dynamic>?> _profileFuture;

  @override
  void initState() {
    super.initState();
    // When the screen is first created, start fetching the user's profile
    _profileFuture = _apiService.getMe();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        // The back button is automatically added by the Navigator
      ),
      // Use a FutureBuilder to easily handle loading/error/data states
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _profileFuture,
        builder: (context, snapshot) {
          // 1. While the data is still loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          // 2. If an error occurred or no data was returned
          if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
            return const Center(
              child: Text('Could not load profile. Please try again.'),
            );
          }

          // 3. If we have data, display it
          final userData = snapshot.data!;
          
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView( // Use a ListView to be scrollable
              children: [
                // A helper widget to build a consistent row style
                _buildProfileRow(
                  icon: Icons.person,
                  title: 'Name',
                  detail: userData['full_name'] ?? 'Not Provided',
                ),
                _buildProfileRow(
                  icon: Icons.email,
                  title: 'Email',
                  detail: userData['email'] ?? 'Not Provided',
                ),
                _buildProfileRow(
                  icon: Icons.phone,
                  title: 'Phone',
                  detail: userData['phone_number'] ?? 'Not Provided',
                ),
                _buildProfileRow(
                  icon: Icons.work,
                  title: 'Account Type',
                  // Capitalize the user type for better display
                  detail: (userData['user_type'] ?? 'N/A').toString().toUpperCase(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // A reusable helper widget to avoid repeating code
  Widget _buildProfileRow({
    required IconData icon,
    required String title,
    required String detail,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: Icon(icon, color: Colors.green, size: 30),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
        ),
        subtitle: Text(
          detail,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}