// lib/home/vet_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // <-- ADD THIS

class VetDetailScreen extends StatelessWidget {
  // We will pass the vet's data into this screen as a map
  final Map<String, dynamic> vetData;

  const VetDetailScreen({super.key, required this.vetData});

  @override
  Widget build(BuildContext context) {
    // A helper function to safely get data or return a default string
    String getData(String key, {String defaultValue = 'Not Provided'}) {
      return vetData[key]?.toString() ?? defaultValue;
    }

    // Safely get the vet profile data
    final vetProfile = vetData['vet_profile'] as Map<String, dynamic>? ?? {};

    return Scaffold(
      appBar: AppBar(
        // The title of the app bar will be the vet's name
        title: Text(getData('full_name')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView( // Use a ListView to prevent overflow on small screens
          children: [
            // Header Section
            Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    child: Icon(Icons.person, size: 50),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    getData('full_name'),
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Qualifications: ${getData('qualifications', defaultValue: 'N/A')}',
                    style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),

            // Contact Info Section
            _buildDetailRow(icon: Icons.email, title: 'Email', detail: getData('email')),
            _buildDetailRow(icon: Icons.phone, title: 'Phone', detail: getData('phone_number')),
            _buildDetailRow(icon: Icons.verified_user, title: 'Registration No.', detail: getData('vet_council_reg_number', defaultValue: 'N/A')),
            
            const SizedBox(height: 32),

            // Action Buttons
            ElevatedButton.icon(
              // NEW CODE
                onPressed: () async {
                // Get the phone number, removing any spaces
                final String phoneNumber = getData('phone_number').replaceAll(' ', '');
                
                // Create the telephone URL. The 'tel:' prefix is what tells the OS to open the dialer.
                final Uri telephoneUrl = Uri.parse('tel:$phoneNumber');

                // Check if the device can handle this URL before trying to launch it
                if (await canLaunchUrl(telephoneUrl)) {
                    await launchUrl(telephoneUrl);
                } else {
                    // If it can't launch, show an error message to the user
                    ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Could not place a call to $phoneNumber'),
                        backgroundColor: Colors.red,
                    ),
                    );
                }
                },
              icon: const Icon(Icons.call),
              label: const Text('Call Now'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Implement "Send Message" functionality
                print('Messaging ${getData('phone_number')}...');
              },
              icon: const Icon(Icons.message),
              label: const Text('Send Message'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // A helper widget to build a consistent row style for details
  Widget _buildDetailRow({required IconData icon, required String title, required String detail}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[600]),
          const SizedBox(width: 16),
          Text('$title: ', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Expanded(child: Text(detail, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}