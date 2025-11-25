import 'package:flutter/material.dart';

enum AppFont { poppins, sora, roboto, lato }

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  AppFont _font = AppFont.lato;
  String? _backgroundImage;

  final List<String> _availableBackgrounds = [
    'media/backgrounds/background 1920x1080.png',
    'media/backgrounds/background 1080x1920.png',
  ];

  ThemeMode get themeMode => _themeMode;
  AppFont get font => _font;
  String? get backgroundImage => _backgroundImage;
  List<String> get availableBackgrounds => _availableBackgrounds;

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  void setFont(AppFont font) {
    _font = font;
    notifyListeners();
  }

  void setBackgroundImage(String? imagePath) {
    _backgroundImage = imagePath;
    notifyListeners();
  }
}
