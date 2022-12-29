import 'package:exam_app/constants/font_family.dart';
import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.indigo,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.white),
  ),
  iconTheme: IconThemeData(color: Colors.black),
  brightness: Brightness.light,
  fontFamily: FontFamily.productSans,
  primaryColorLight: Colors.white,
  dialogBackgroundColor: Colors.white,
  highlightColor: Color.fromARGB(255, 0, 131, 196),
  disabledColor: Color.fromARGB(255, 161, 191, 206),
  scaffoldBackgroundColor: Colors.white,
  cardTheme: CardTheme(
    color: Colors.white,
  ),
  dividerTheme: DividerThemeData(
    color: Colors.black,
  ),
  popupMenuTheme: PopupMenuThemeData(
    color: Colors.white,
  ),
);

ThemeData darkTheme = ThemeData(
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.indigo,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.white),
  ),
  iconTheme: IconThemeData(color: Colors.white),
  brightness: Brightness.dark,
  fontFamily: FontFamily.productSans,
  primaryColorLight: Colors.white10,
  dialogBackgroundColor: Colors.black,
  highlightColor: Color.fromARGB(255, 0, 131, 196),
  disabledColor: Color.fromARGB(255, 27, 27, 27),
  scaffoldBackgroundColor: Color.fromARGB(255, 4, 9, 36),
  cardTheme: CardTheme(
    color: Color.fromARGB(255, 4, 9, 36),
  ),
  dividerTheme: DividerThemeData(
    color: Colors.white,
  ),
  popupMenuTheme: PopupMenuThemeData(
    color: Color.fromARGB(255, 4, 9, 36),
  ),
);
