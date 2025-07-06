import 'package:chattappv1/themes/dark_mode.dart';
import 'package:chattappv1/themes/light_mode.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = lightMode; // الثيم الافتراضي
  ThemeData get themeData => _themeData;
  bool get isDarkMode => _themeData == darkMode;

  set themeData(ThemeData themeData) {
    _themeData = themeData; // تعيين الثيم الجديد
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeData == lightMode) {
      themeData = darkMode;
    } else {
      themeData = lightMode;
    }
  }
}
