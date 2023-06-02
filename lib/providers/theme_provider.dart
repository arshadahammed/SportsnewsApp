import 'package:flutter/material.dart';

import '../services/dark_theme_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeProvider({bool initialTheme = false}) : _darkTheme = initialTheme;

  ThemePreferences darkThemePreferences = ThemePreferences();
  bool _darkTheme = false;
  bool get getDarkTheme => _darkTheme;

  // void toggleTheme() {
  //   setDarkTheme = !getDarkTheme;
  //   darkThemePreferences.setDarkTheme(getDarkTheme);
  //   notifyListeners();
  // }

  set setDarkTheme(bool value) {
    _darkTheme = value;
    darkThemePreferences.setDarkTheme(value);
    notifyListeners();
  }
}
