import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'theme_config/appbar_theme.dart';
import 'theme_config/bottom_appbar_theme.dart';
import 'theme_config/bottom_navigation_bar_theme.dart';
import 'theme_config/button_theme.dart';
import 'theme_config/color_scheme.dart';
import 'theme_config/input_decoration_theme.dart';
import 'theme_config/text_theme.dart';

class MyThemeData {
  static MyThemeData? _instance;
  factory MyThemeData() {
    return _instance ??= MyThemeData._init();
  }

  MyThemeData._init();

  ThemeData lightThemeData(BuildContext context) => ThemeData.light().copyWith(
        useMaterial3: false,
        brightness: Brightness.light,

        colorScheme: lightColorScheme(),
        textSelectionTheme: LightTextTheme.getTextSelectionTheme(),
        splashColor: const Color(0x6046605).withOpacity(0.1), //ffF28E27
        dialogTheme: const DialogTheme(),
        scrollbarTheme: ScrollbarThemeData(
          thumbVisibility: MaterialStateProperty.all(true),
          thumbColor: MaterialStateProperty.all(Color.fromARGB(255, 211, 4, 48)),
          trackVisibility: MaterialStateProperty.all(true),
          trackColor: MaterialStateProperty.all(const Color(0xffE9E9E9)),
          thickness: MaterialStateProperty.all(7.w),
          radius: Radius.circular(20.r),
        ),
        textButtonTheme: LightButtonTheme.getTextButtonThemeData(),

        scaffoldBackgroundColor: Color.fromARGB(255, 251, 249, 249),
        floatingActionButtonTheme: LightButtonTheme.getFloatingActionButtonThemeData(),
        bottomNavigationBarTheme: lightBottomNavigationBarTheme(context),
        bottomAppBarTheme: lightBottomAppBarTheme(context),
        buttonTheme: LightButtonTheme.getButtonThemeData(),
        elevatedButtonTheme: LightButtonTheme.getElevatedButtonThemeData(),
        inputDecorationTheme: lightInputDecorationTheme(),
        cardTheme: CardTheme(
          surfaceTintColor: Colors.white,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        primaryColor: const Color(0xffEA5B27),
        hintColor: LightGeneralThemeColor.hint.color,
        appBarTheme: lightAppBarTheme(context),
        checkboxTheme: CheckboxThemeData(
          fillColor: MaterialStateProperty.all(const Color(0xffEA5B27)),
        ),
      );

  ThemeData darkThemeData(BuildContext context) => ThemeData.dark().copyWith(
        useMaterial3: false,
        // textTheme:
        //     GoogleFonts.robotoFlexTextTheme().apply(bodyColor: DarkTextThemeColor.body.color),
        colorScheme: darkColorScheme(),
        textSelectionTheme: DarkTextTheme.getTextSelectionTheme(),
        scaffoldBackgroundColor: ScaffoldBackgroundColor.dark.color,
        textButtonTheme: DarkButtonTheme.getTextButtonThemeData(),
        floatingActionButtonTheme: DarkButtonTheme.getFloatingActionButtonThemeData(),
        bottomNavigationBarTheme: darkBottomNavigationBarTheme(context),
        bottomAppBarTheme: darkBottomAppBarTheme(context),
        buttonTheme: DarkButtonTheme.getButtonThemeData(),
        elevatedButtonTheme: DarkButtonTheme.getElevatedButtonThemeData(),
        inputDecorationTheme: darkInputDecorationTheme(),
        cardTheme: CardTheme(
          color: const Color(0xff35383F),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        primaryColor: Color.fromARGB(255, 52, 90, 179),

        textTheme: TextTheme(),

        // bottomSheetTheme: ,
        hintColor: DarkGeneralThemeColor.hint.color,
        dialogTheme: const DialogTheme(backgroundColor: Color(0xff181A20)),
        bottomSheetTheme: const BottomSheetThemeData(backgroundColor: Color(0xff181A20)),
        appBarTheme: darkAppBarTheme(context),
        checkboxTheme: CheckboxThemeData(
          fillColor: MaterialStateProperty.all(Colors.grey.shade800),
          checkColor: MaterialStateProperty.all(Colors.red),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      );
}
