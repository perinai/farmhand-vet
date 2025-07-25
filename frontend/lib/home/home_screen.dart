// lib/home/home_screen.dart

import 'package:flutter/material.dart';
import 'package:frontend/api/api_service.dart';
import 'package:frontend/core/secure_storage_service.dart';
import 'package:frontend/home/profile_screen.dart';
import 'package:frontend/home/vet_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  final SecureStorageService _storageService = SecureStorageService();
  final TextEditingController _searchController = TextEditingController();

  List<dynamic> _allVets = [];
  List<dynamic> _filteredVets = [];
  bool _isLoading = true;
  String _errorMessage = ''; // To store any error messages

  @override
  void initState() {
    super.initState();
    _fetchVets();
    _searchController.addListener(_filterVets);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchVets() async {
    // Ensure we start in a loading state
    if (mounted) setState(() { _isLoading = true; _errorMessage = ''; });

    try {
      final vets = await _apiService.getVets();
      // Update state with the fetched data
      if (mounted) {
        setState(() {
          _allVets = vets;
          _filteredVets = vets;
        });
      }
    } catch (e) {
      // If any error occurs, store the error message
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to load vets. Please try again later.';
        });
      }
      print("Error fetching vets: $e");
    } finally {
      // CRITICAL: Always set loading to false when the operation is complete
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _filterVets() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredVets = _allVets.where((vet) {
        final vetName = (vet['full_name'] as String? ?? '').toLowerCase();
        return vetName.contains(query);
      }).toList();
    });
  }
  
  // --- The Build Method ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find a Vet'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _storageService.deleteToken();
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for a vet by name...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: _buildBody(), // Use a helper function for the body
          ),
        ],
      ),
    );
  }

  // --- Helper Widget for the Body ---
  Widget _buildBody() {
    // If loading, show spinner
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    // If there was an error, show error message
    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_errorMessage, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: _fetchVets, child: const Text('Retry'))
          ],
        ),
      );
    }
    // If the filtered list is empty, show message
    if (_filteredVets.isEmpty) {
      return const Center(child: Text('No vets match your search.'));
    }
    // Otherwise, build the list
    return ListView.builder(
      itemCount: _filteredVets.length,
      itemBuilder: (context, index) {
        final vet = _filteredVets[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: Text(vet['full_name'] ?? 'No Name'),
            subtitle: Text(vet['email'] ?? 'No Email'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => VetDetailScreen(vetData: vet)),
              );
            },
          ),
        );
      },
    );
  }
}