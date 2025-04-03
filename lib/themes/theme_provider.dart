import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  // Colors
  static const Color primaryYellow = Colors.yellow;
  static const Color darkModeAccent = Colors.yellow;
  static const Color darkGrey = Colors.black;
  static const Color primaryWhite = Colors.white;
  static const Color primaryBlack = Colors.black;

  // Neo-brutalist decoration for light mode
  static BoxDecoration neoBrutalistDecoration = BoxDecoration(
    color: Colors.white,
    border: Border.all(color: Colors.black, width: 2),
    boxShadow: const [
      BoxShadow(
        color: Colors.black,
        offset: Offset(4, 4),
        blurRadius: 0,
      ),
    ],
  );

  // Neo-brutalist decoration for dark mode (white borders and shadows)
  static BoxDecoration neoBrutalistDecorationDark = BoxDecoration(
    color: darkGrey,
    border: Border.all(color: Colors.white, width: 2),
    boxShadow: const [
      BoxShadow(
        color: Colors.white,
        offset: Offset(4, 4),
        blurRadius: 0,
      ),
    ],
  );

  // Button decoration for dark mode (keeps yellow accents)
  static BoxDecoration buttonDecorationDark = BoxDecoration(
    color: darkGrey,
    border: Border.all(color: darkModeAccent, width: 2),
    boxShadow: const [
      BoxShadow(
        color: darkModeAccent,
        offset: Offset(4, 4),
        blurRadius: 0,
      ),
    ],
  );

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  ThemeData get themeData {
    return ThemeData(
      brightness: _isDarkMode ? Brightness.dark : Brightness.light,
      scaffoldBackgroundColor: _isDarkMode ? primaryBlack : primaryWhite,
      primarySwatch: Colors.yellow,
      appBarTheme: AppBarTheme(
        backgroundColor: _isDarkMode ? primaryBlack : primaryWhite,
        foregroundColor: _isDarkMode ? darkModeAccent : primaryBlack,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(
          color: _isDarkMode ? Colors.white.withOpacity(0.7) : Colors.black.withOpacity(0.5),
        ),
        filled: true,
        fillColor: _isDarkMode ? darkGrey : primaryWhite,
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: _isDarkMode ? Colors.white : Colors.black,
            width: 2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: _isDarkMode ? Colors.white : Colors.black,
            width: 2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: _isDarkMode ? Colors.white : Colors.black,
            width: 2,
          ),
        ),
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(
          color: _isDarkMode ? primaryWhite : primaryBlack,
        ),
        bodyMedium: TextStyle(
          color: _isDarkMode ? primaryWhite : primaryBlack,
        ),
        titleMedium: TextStyle(
          color: _isDarkMode ? primaryWhite : primaryBlack,
        ),
        headlineMedium: TextStyle(
          color: _isDarkMode ? darkModeAccent : primaryBlack,
          fontWeight: FontWeight.bold,
        ),
      ),
      colorScheme: ColorScheme(
        brightness: _isDarkMode ? Brightness.dark : Brightness.light,
        primary: _isDarkMode ? darkModeAccent : primaryBlack,
        onPrimary: _isDarkMode ? primaryBlack : primaryWhite,
        secondary: _isDarkMode ? darkModeAccent : primaryYellow,
        onSecondary: primaryBlack,
        error: Colors.red,
        onError: primaryWhite,
        surface: _isDarkMode ? darkGrey : primaryWhite,
        onSurface: _isDarkMode ? primaryWhite : primaryBlack,
      ),
    );
  }
}