import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  static const String _themeKey = 'theme_mode';
  bool _isDarkMode = false;
  SharedPreferences? _prefs;
  bool _isInitialized = false;

  bool get isDarkMode => _isDarkMode;
  bool get isInitialized => _isInitialized;

  ThemeProvider() {
    print('ThemeProvider constructor called');
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    print('Loading theme mode');
    try {
      _prefs = await SharedPreferences.getInstance();
      _isDarkMode = _prefs?.getBool(_themeKey) ?? false;
      _isInitialized = true;
      print('Theme loaded: isDarkMode = $_isDarkMode');
      notifyListeners();
    } catch (e) {
      print('Error loading theme: $e');
    }
  }

  Future<void> toggleTheme() async {
    print('Toggling theme from $_isDarkMode');
    _isDarkMode = !_isDarkMode;
    print('New theme state: isDarkMode = $_isDarkMode');
    try {
      await _prefs?.setBool(_themeKey, _isDarkMode);
      notifyListeners();
      print('Theme saved successfully');
    } catch (e) {
      print('Error saving theme: $e');
    }
  }
}
