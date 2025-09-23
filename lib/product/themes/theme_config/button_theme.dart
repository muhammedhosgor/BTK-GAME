import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'color_scheme.dart';

// * #FFFFFF Light Theme Config *

class LightButtonTheme {
  //

  //* Floating Action Button Theme

  static FloatingActionButtonThemeData getFloatingActionButtonThemeData() {
    return FloatingActionButtonThemeData(
      backgroundColor: LightButtonsColor.floatingActionButtonBackground.color,
    );
  }

  //* Elevated Button Theme

  static ElevatedButtonThemeData getElevatedButtonThemeData() {
    return ElevatedButtonThemeData(
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28.sp),
          ),
        ),
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) {
              return LightButtonsColor.elevatedButtonBackground.color;
            } else if (states.contains(MaterialState.disabled)) {
              return LightButtonsColor.elevatedInactiveButtonBackground.color;
            }
            return LightButtonsColor
                .elevatedButtonBackground.color; // Use the component's default.
          },
        ),
        side: MaterialStateProperty.all(
          BorderSide(
            color: LightButtonsColor.elevatedButtonBorderSide.color,
          ),
        ),
        overlayColor: MaterialStateProperty.all(
          LightButtonsColor.elevatedButtonOverlay.color,
        ),
      ),
    );
  }

  //* Button Theme

  static ButtonThemeData getButtonThemeData() {
    return const ButtonThemeData(
      alignedDropdown: true,
    );
  }

  //* Text Button Theme

  static TextButtonThemeData getTextButtonThemeData() {
    return TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(
          LightButtonsColor.textButtonForeground.color,
        ),
        overlayColor: MaterialStateProperty.all(
          const Color(0x6046605).withOpacity(0.1),
        ),
      ),
    );
  }
}

// * ##############################################################################

// * #000000 Dark Theme Config *

class DarkButtonTheme {
  //

  // * Floating Action Button Theme
  static FloatingActionButtonThemeData getFloatingActionButtonThemeData() {
    return FloatingActionButtonThemeData(
      backgroundColor: DarkButtonsColor.floatingActionButtonBackground.color,
    );
  }

  // * Elevated Button Theme

  static ElevatedButtonThemeData getElevatedButtonThemeData() {
    return ElevatedButtonThemeData(
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28.sp),
          ),
        ),
        backgroundColor: MaterialStateProperty.all(
          DarkButtonsColor.elevatedButtonBackground.color,
        ),
        side: MaterialStateProperty.all(
          BorderSide(
            color: DarkButtonsColor.elevatedButtonBorderSide.color,
          ),
        ),
        overlayColor: MaterialStateProperty.all(
          DarkButtonsColor.elevatedButtonOverlay.color,
        ),
      ),
    );
  }

  // * Button Theme

  static ButtonThemeData getButtonThemeData() {
    return const ButtonThemeData(
      alignedDropdown: true,
    );
  }

  // * Text Button Theme

  static TextButtonThemeData getTextButtonThemeData() {
    return TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(
          DarkButtonsColor.textButtonForeground.color,
        ),
      ),
    );
  }
}
