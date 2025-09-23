import 'package:flutter/material.dart';

import 'color_scheme.dart';

BottomNavigationBarThemeData lightBottomNavigationBarTheme(
    BuildContext context) {
  return const BottomNavigationBarThemeData().copyWith(
    unselectedItemColor: Colors.black.withOpacity(0.4),
    selectedItemColor: const Color(0xffEA5B27),
    type: BottomNavigationBarType.fixed,
    backgroundColor: ScaffoldBackgroundColor.light.color.withOpacity(0.9),
    elevation: 10,
  );
}

BottomNavigationBarThemeData darkBottomNavigationBarTheme(
    BuildContext context) {
  return const BottomNavigationBarThemeData().copyWith(
    unselectedItemColor: Colors.white.withOpacity(0.4),
    selectedItemColor: Colors.white,
    type: BottomNavigationBarType.fixed,
    backgroundColor: const Color.fromARGB(255, 35, 37, 41).withOpacity(0.8),
    elevation: 10,
  );
}
