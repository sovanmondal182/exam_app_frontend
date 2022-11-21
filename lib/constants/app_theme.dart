import 'package:exam_app/constants/colors.dart';
import 'package:exam_app/constants/font_family.dart';
import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData themeData = ThemeData(
    fontFamily: FontFamily.productSans,
    brightness: Brightness.light,
    primaryColor: Colors.indigo,
    primaryColorLight: Colors.black12,
    primaryColorDark: Colors.white,
    primaryIconTheme: IconThemeData(color: Colors.indigo[200]),
  );

  static final ThemeData themeDataDark = ThemeData(
    fontFamily: FontFamily.productSans,
    brightness: Brightness.dark,
    primaryColor: Colors.purpleAccent[700],
    primaryColorLight: Colors.white10,
    primaryColorDark: Colors.black87,
    primaryIconTheme: IconThemeData(color: Colors.deepPurple[100]),
  );
}
