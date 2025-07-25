// lib/core/secure_storage_service.dart

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  // Create an instance of the storage
  final _storage = const FlutterSecureStorage();

  // A key to identify our token in storage
  static const _tokenKey = 'auth_token';

  // Function to write the token to storage

    Future<void> saveToken(String token) async {
    print('Attempting to save token: $token'); // <-- ADD THIS
    await _storage.write(key: _tokenKey, value: token);
    print('Token supposedly saved!'); // <-- ADD THIS
    }

    Future<String?> readToken() async {
    print('Attempting to read token...'); // <-- ADD THIS
    final token = await _storage.read(key: _tokenKey);
    print('Token read from storage: $token'); // <-- ADD THIS
    return token;
    }



  // Function to delete the token from storage (for logout)
  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
    print('Token deleted!');
  }
}