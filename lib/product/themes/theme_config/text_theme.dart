import 'package:flutter/material.dart';

class LightTextTheme {
  // static TextTheme fontFamily = GoogleFonts.aladinTextTheme();

  static TextSelectionThemeData getTextSelectionTheme() {
    return const TextSelectionThemeData(
        cursorColor: Color(0xffEA5B27),
        selectionColor: Color.fromARGB(255, 242, 151, 118),
        selectionHandleColor: Color.fromARGB(255, 239, 119, 76));
  }
}

class DarkTextTheme {
  static TextSelectionThemeData getTextSelectionTheme() {
    return const TextSelectionThemeData(
        cursorColor: Colors.white,
        selectionColor: Color.fromARGB(255, 242, 151, 118),
        selectionHandleColor: Color.fromARGB(255, 239, 119, 76));
  }
}
