import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primarySwatch: Colors.green,
      highlightColor: Colors.orange,
      textTheme: GoogleFonts.poppinsTextTheme(
        TextTheme(
          headlineLarge: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          headlineMedium: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          bodyMedium: TextStyle(fontSize: 16, color: Colors.black87),
          bodySmall: TextStyle(fontSize: 14, color: Colors.black54),
        ),
      ),
    );
  }
}
