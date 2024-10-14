// ignore_for_file: file_names, unused_element

import 'package:flutter/material.dart';

const primaryColor = Color(0xFF685BFF);
const canvasColor = Color.fromARGB(255, 58, 58, 162);
const scaffoldBackgroundColor = Color.fromARGB(255, 232, 232, 239);
const accentCanvasColor = Color(0xFF3E3E61);
const white = Colors.white;
final actionColor = const Color(0xFF5F5FA7).withOpacity(0.6);
final divider = Divider(color: white.withOpacity(0.3), height: 1);
  double  height=0;
  double width=0;
 Map<DateTime, List<String>> notes = {};
  DateTime selectedDay = DateTime.now();
  
  bool _isDarkMode = false;
  final ThemeData lightTheme = ThemeData(
    primaryColor: primaryColor,
    canvasColor: canvasColor,
    scaffoldBackgroundColor: scaffoldBackgroundColor,
    textTheme: const TextTheme(
      headlineSmall: TextStyle(
        color: Colors.white,
        fontSize: 46,
        fontWeight: FontWeight.w800,
      ),
    ),
  );

  final ThemeData darkTheme = ThemeData(
    primaryColor: Colors.grey[850],
    canvasColor: Colors.black,
    scaffoldBackgroundColor: Colors.black,
    textTheme: const TextTheme(
      headlineSmall: TextStyle(
        color: Colors.white,
        fontSize: 46,
        fontWeight: FontWeight.w800,
      ),
    ),
  );

