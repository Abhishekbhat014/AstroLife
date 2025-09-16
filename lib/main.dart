import 'package:astro_life/db/database_helper.dart';
import 'package:astro_life/example.dart';
import 'package:astro_life/screens/auth/login_screen.dart';
import 'package:astro_life/screens/auth/register_screen.dart';
import 'package:astro_life/screens/features/birthchart_screen.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the database
  await DatabaseHelper().database;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AstroLife',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF9F4E9),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF556B2F),
          primary: const Color(0xFF556B2F),
          secondary: const Color(0xFFA52A2A),
        ),

        // Default font for body text
        fontFamily: 'Inter',

        // Text styles
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontFamily: 'Inter',
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFF556B2F), // Deep Olive Green
          ),
          headlineMedium: TextStyle(
            fontFamily: 'Inter',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF556B2F), // Deep Olive Green
          ),
          headlineSmall: TextStyle(
            fontFamily: 'Inter',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF556B2F), // Deep Olive Green
          ),
          bodyLarge: TextStyle(
            fontFamily: 'Inter',
            fontSize: 18,
            color: Color(0xFF2F2F2F), // Dark charcoal
          ),
          bodyMedium: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            color: Color(0xFF2F2F2F), // Dark charcoal
          ),
          bodySmall: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            color: Color(0xFF556B2F), // Deep Olive Green
          ),
        ),

        // Buttons
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF556B2F), // Deep Olive Green
            foregroundColor: Colors.white,
            textStyle: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),

        // Input fields
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: Color(0xFFA52A2A),
              width: 2,
            ), // Terracotta
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
        ),
      ),
      // Start directly with RegisterScreen
      home: LoginScreen(),
    );
  }
}
