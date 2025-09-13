import 'package:flutter/material.dart';

// Define your main brand colors
const Color primaryBlue = Color(0xFF3F51B5); // Adjusted Blue (Indigo 500)
const Color primaryYellow = Color(0xFFFFC107); 

// Define your custom light theme
ThemeData customLightTheme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryBlue, // Blue as the primary seed for light theme
      brightness: Brightness.light,
      // Let fromSeed generate primary, onPrimary, etc.
      // Override secondary if needed, but let's see what fromSeed gives first
      // secondary: primaryYellow,
      // onSecondary: Colors.black,
    ).copyWith(
      // Explicitly set secondary and onSecondary if fromSeed doesn't give desired result
      secondary: primaryYellow,
      onSecondary: Colors.black,
      error: Colors.red,
      onError: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryBlue,
      foregroundColor: Colors.white,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryYellow,
      foregroundColor: Colors.black,
    ),
  );
}

// Define your custom dark theme
ThemeData customDarkTheme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryYellow, // Yellow as the primary seed for dark theme
      brightness: Brightness.dark,
      // Let fromSeed generate primary, onPrimary, etc.
      // Override secondary if needed
      // secondary: primaryBlue,
      // onSecondary: Colors.white,
    ).copyWith(
      // Explicitly set secondary and onSecondary if fromSeed doesn't give desired result
      secondary: primaryBlue,
      onSecondary: Colors.white,
      error: Colors.redAccent,
      onError: Colors.black,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryYellow,
      foregroundColor: Colors.black,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryBlue,
      foregroundColor: Colors.white,
    ),
  );
}
