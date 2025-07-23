// lib/home/home_screen.dart

import 'package:flutter/material.dart';
import 'package:frontend/api/api_service.dart';
import 'package:frontend/home/vet_detail_screen.dart'; // <-- ADD THIS

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<dynamic>> _vetsFuture;

  @override
  void initState() {
    super.initState();
    // When the screen loads, start fetching the vets
    _vetsFuture = _apiService.getVets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find a Vet'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // We'll import the login screen to navigate back
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
        ],
      ),
      // Use a FutureBuilder to handle the loading state
      body: FutureBuilder<List<dynamic>>(
        future: _vetsFuture,
        builder: (context, snapshot) {
          // Case 1: Still loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // Case 2: Error occurred
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          // Case 3: Data is empty or not available
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No verified vets found.'));
          }
          
          // Case 4: Data is available, display the list
          final vets = snapshot.data!;
          return ListView.builder(
            itemCount: vets.length,
            itemBuilder: (context, index) {
              final vet = vets[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                  title: Text(vet['full_name'] ?? 'No Name'),
                  subtitle: Text(vet['email'] ?? 'No Email'),
                  // We'll add an onTap to go to a detail screen later
                  // NEW CODE
                    onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(
                        builder: (context) => VetDetailScreen(vetData: vet),
                        ),
                    );
                    },
                ),
              );
            },
          );
        },
      ),
    );
  }
}