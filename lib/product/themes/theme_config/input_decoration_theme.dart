import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'color_scheme.dart';

InputDecorationTheme lightInputDecorationTheme() {
  return InputDecorationTheme(
    filled: true,
    fillColor: Color.fromARGB(
        255, 238, 238, 238), //const Color.fromARGB(255, 255, 255, 255),
    focusColor: Colors.green,
    enabledBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: Color.fromARGB(255, 255, 255, 255)),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide:
          BorderSide(color: Color.fromARGB(255, 255, 255, 255), width: 2.sp),
    ),
    prefixIconColor: LightInputDecorationColor.prefixIcon.color,
    hintStyle: TextStyle(color: LightInputDecorationColor.hintText.color),
  );
}

InputDecorationTheme darkInputDecorationTheme() {
  return InputDecorationTheme(
    filled: true,
    fillColor: DarkInputDecorationColor.fill.color,
    border: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(15.0)),
      borderSide: BorderSide.none,
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(
        width: 1,
        color: const Color.fromARGB(255, 255, 255, 255),
      ),
      borderRadius: const BorderRadius.all(Radius.circular(15.0)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(15.0)),
      borderSide: BorderSide(
        width: 1,
        color: DarkInputDecorationColor.focusedBorder.color,
      ),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(15.0)),
      borderSide: BorderSide(
        width: 1,
        color: DarkInputDecorationColor.focusedErrorBorder.color,
      ),
    ),
    prefixIconColor: DarkInputDecorationColor.prefixIcon.color,
    hintStyle:
        TextStyle(color: DarkInputDecorationColor.hintText.color, fontSize: 16),
  );
}
