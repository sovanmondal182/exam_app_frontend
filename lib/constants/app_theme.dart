import 'package:exam_app/constants/font_family.dart';
import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData themeData = ThemeData(
    fontFamily: FontFamily.productSans,
    brightness: Brightness.light,
    primaryColor: Colors.indigo,
    primaryColorLight: Color.fromARGB(31, 121, 121, 121),
    dialogBackgroundColor: Colors.white,
    backgroundColor: Colors.white,
    highlightColor: Color.fromARGB(255, 0, 131, 196),
    primaryIconTheme: IconThemeData(color: Color.fromARGB(255, 161, 191, 206)),
  );

  static final ThemeData themeDataDark = ThemeData(
    fontFamily: FontFamily.productSans,
    brightness: Brightness.dark,
    primaryColor: Colors.purpleAccent[700],
    primaryColorLight: Colors.white10,
    dialogBackgroundColor: Colors.black,
    backgroundColor: Color.fromARGB(255, 4, 9, 36),
    highlightColor: Color.fromARGB(255, 0, 131, 196),
    primaryIconTheme: IconThemeData(color: Colors.deepPurple[100]),
  );
}
