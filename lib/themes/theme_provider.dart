import 'package:flutter/material.dart';
import 'package:clock_app/themes/light_theme.dart';
import 'package:clock_app/themes/dark_mode.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  // initially, light mode
  ThemeData _themeData = lightMode;

  // get theme
  ThemeData get themeData => _themeData;

  // is dark mode
  bool get isDarkMode => _themeData == darkMode;

  // set theme 
  set themeData(ThemeData themeData) {
    _themeData = themeData;

    // update UI
    notifyListeners();
  }

  // toggle theme
  void toggleTheme() {
    if (_themeData == lightMode) {
      themeData = darkMode;
      saveTheme(true);
    } else {
      themeData = lightMode;
      saveTheme(false);
    }
  }

  // load theme from shared preferences
  Future<void> loadTheme() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isDarkMode = prefs.getBool('isDarkMode') ?? false;
    if (isDarkMode) {
      _themeData = darkMode;
    } else {
      _themeData = lightMode;
    }
    notifyListeners();
  }
  // save theme to shared preferences
  Future<void> saveTheme(bool isDarkMode) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode);
  }
  ThemeProvider() {
    loadTheme();
  }
}