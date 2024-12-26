import 'package:flutter/material.dart';
import 'package:notepad/Themes/dark.dart';
import 'package:notepad/Themes/light.dart';


class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;

  ThemeData getTheme() {
    return _isDarkMode ? darkTheme : lightTheme;
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}