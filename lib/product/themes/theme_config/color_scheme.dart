import 'package:flutter/material.dart';

ColorScheme? lightColorScheme() {
  return const ColorScheme.light(
    primary: Color.fromARGB(255, 219, 9, 19),
    secondary: Color.fromARGB(255, 255, 140, 98),
  );
}

ColorScheme? darkColorScheme() {
  return const ColorScheme.dark(
    primary: Color.fromARGB(255, 0, 247, 231),
    surface: Color.fromARGB(255, 28, 30, 36),
  );
}

// * ############################################################################

// * ---------------------  Light  --------------------------------  General ThemeData Color

enum LightGeneralThemeColor {
  hint(Colors.black54);

  final Color color;
  const LightGeneralThemeColor(this.color);
}

// * ---------------------  Dark  --------------------------------  General ThemeData Color

enum DarkGeneralThemeColor {
  hint(Colors.grey);

  final Color color;
  const DarkGeneralThemeColor(this.color);
}

// * ---------------------  Dark  --------------------------------  TextTheme Color
enum DarkTextThemeColor {
  body(Colors.white);

  final Color color;
  const DarkTextThemeColor(this.color);
}

// * -------------------------------------------------------------  Scaffold Color

enum ScaffoldBackgroundColor {
  light(Colors.white),
  dark(Color(0xff181A20));

  final Color color;
  const ScaffoldBackgroundColor(this.color);
}

// * ---------------------  Light  --------------------------------  AppBar Color

enum LightAppBarColor {
  appBar(Color.fromARGB(255, 196, 39, 39)),
  titleTextStyle(Colors.white),
  iconThemeColor(Colors.white);

  final Color color;
  const LightAppBarColor(this.color);
}
// * ---------------------  Dark  --------------------------------  AppBar Color

enum DarkAppBarColor {
  appBar(Color(0xff181A20)),
  toolbarText(Colors.black),
  titleTextStyle(Colors.white),
  iconTheme(Colors.white);

  final Color color;
  const DarkAppBarColor(this.color);
}

// * ---------------------  Light  --------------------------------  Button Color

enum LightButtonsColor {
  floatingActionButtonBackground(Color(0xffEA5B27)),
  elevatedButtonBackground(Color(0xffEA5B27)),
  elevatedInactiveButtonBackground(Color(0xffD9D9D9)),
  elevatedButtonBorderSide(Colors.transparent),
  elevatedButtonOverlay(Color.fromARGB(37, 210, 210, 210)),
  textButtonForeground(Color(0xffEA5B27));

  final Color color;
  const LightButtonsColor(this.color);
}

// * ---------------------  Dark  --------------------------------  Button Color

enum DarkButtonsColor {
  floatingActionButtonBackground(Color(0xff35383F)),
  elevatedButtonBackground(Color(0xff1F222A)),
  elevatedButtonBorderSide(Color(0xff26292F)),
  elevatedButtonOverlay(Color.fromARGB(32, 150, 150, 150)),
  textButtonForeground(Colors.white);

  final Color color;
  const DarkButtonsColor(this.color);
}

// * ---------------------  Light  --------------------------------  Input Decoration

enum LightInputDecorationColor {
  fill(Color(0xffFAFAFA)),
  errorBorder(Colors.red),
  focusedBorder(Colors.black),
  focusedErrorBorder(Colors.black),
  prefixIcon(Colors.black),
  hintText(Colors.black54);

  final Color color;
  const LightInputDecorationColor(this.color);
}

// * ---------------------   Dark  --------------------------------  Input Decoration

enum DarkInputDecorationColor {
  fill(Color(0xff1F222A)),
  errorBorder(Colors.red),
  focusedBorder(Colors.white),
  focusedErrorBorder(Colors.white),
  prefixIcon(Colors.white),
  hintText(Colors.grey);

  final Color color;
  const DarkInputDecorationColor(this.color);
}
