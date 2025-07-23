// lib/api/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // The base URL of our running backend
  // For Windows desktop, we use the real IP address. For Android emulator, it's different.
  static const String _baseUrl = "http://127.0.0.1:8000";

  // --- The Login Function ---
  // This function will take the email and password and send it to the backend.
  Future<Map<String, dynamic>> login(String email, String password) async {
    // Construct the full URL for the login endpoint
    final url = Uri.parse('$_baseUrl/auth/login');

    try {
      // Send a POST request.
      // IMPORTANT: FastAPI's OAuth2PasswordRequestForm expects data as a 'form', not JSON.
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {'username': email, 'password': password},
      );

      // Decode the JSON response from the backend
      final responseData = json.decode(response.body);

      // Check if the request was successful (status code 200-299)
      if (response.statusCode >= 200 && response.statusCode < 300) {
        // Return the successful data (which includes the access_token)
        return {'success': true, 'data': responseData};
      } else {
        // If the server returned an error (like 401 Unauthorized), return that error detail.
        return {'success': false, 'message': responseData['detail'] ?? 'An unknown error occurred'};
      }
    } catch (e) {
      // Handle network errors (e.g., backend server is not running)
      print('Network Error: $e');
      return {'success': false, 'message': 'Could not connect to the server.'};
    }
  }

  // We will add register(), getVets(), etc. functions here later.
  // lib/api/api_service.dart

    // ... (keep the existing _baseUrl and login function) ...

    // --- The Register Function ---
    Future<Map<String, dynamic>> register({
        required String email,
        required String password,
        required String fullName,
        required String phoneNumber,
        required String userType, // 'vet' or 'farmer'
    }) async {
        final url = Uri.parse('$_baseUrl/auth/register');

        try {
        final response = await http.post(
            url,
            headers: {"Content-Type": "application/json"}, // Register endpoint expects JSON
            body: json.encode({
            'email': email,
            'password': password,
            'full_name': fullName,
            'phone_number': phoneNumber,
            'user_type': userType,
            }),
        );

        final responseData = json.decode(response.body);

        if (response.statusCode == 201) { // 201 Created is the success code for registration
            return {'success': true, 'data': responseData};
        } else {
            return {'success': false, 'message': responseData['detail'] ?? 'An unknown error occurred'};
        }
        } catch (e) {
        print('Network Error: $e');
        return {'success': false, 'message': 'Could not connect to the server.'};
        }
    }

    // lib/api/api_service.dart

   // ... (keep existing code) ...

  // --- Get Vets Function ---
  Future<List<dynamic>> getVets() async {
    final url = Uri.parse('$_baseUrl/vets');
    
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // If the request was successful, decode the list of vets
        return json.decode(response.body);
      } else {
        // If there was an error, return an empty list
        print('Failed to load vets: ${response.body}');
        return [];
      }
    } catch (e) {
      // Handle network errors
      print('Network Error while fetching vets: $e');
      return [];
    }
  }
}
