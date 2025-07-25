// lib/main.dart

import 'package:flutter/material.dart';
import 'package:frontend/auth/login_screen.dart'; // We will create this file next
import 'package:frontend/home/home_screen.dart'; // <--- ADD THIS LINE
import 'package:frontend/core/auth_check_screen.dart';

// NEW CODE
void main() {
  // This line is crucial for plugins that need to use platform channels before runApp
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const VetLigApp());
}

class VetLigApp extends StatelessWidget {
  const VetLigApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VetLig',
      // This removes the debug banner from the top right corner
      debugShowCheckedModeBanner: false, 
      
      // We will define a custom theme to make our app look professional
      theme: ThemeData(
        // Set the primary color swatch for the app
        primarySwatch: Colors.green, 
        
        // Set the default brightness and colors
        brightness: Brightness.light,
        
        // Define styles for text input fields
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),

        // Define a default style for elevated buttons
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      
      // The first screen the user will see is the LoginScreen
      
      initialRoute: '/auth_check',
      routes: {
        // ADD the route for the check screen
        '/auth_check': (context) => const AuthCheckScreen(),
        // RENAME the login route from '/' to '/login'
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}