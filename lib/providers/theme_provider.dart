import 'package:exam_app/stores/theme/local_storage.dart';
import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  late ThemeMode themeData;

  ThemeProvider(String theme) {
    if (theme == 'light') {
      themeData = ThemeMode.light;
    } else {
      themeData = ThemeMode.dark;
    }
  }

  void toggleTheme() async {
    if (themeData == ThemeMode.light) {
      themeData = ThemeMode.dark;
      await LocalStorage.saveTheme('dark');
      print('dark');
    } else {
      themeData = ThemeMode.light;
      await LocalStorage.saveTheme('light');
      print('light');
    }
    notifyListeners();
  }
}
