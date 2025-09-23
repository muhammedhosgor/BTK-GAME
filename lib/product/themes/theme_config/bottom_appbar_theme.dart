import 'package:flutter/material.dart';

import 'color_scheme.dart';

BottomAppBarTheme lightBottomAppBarTheme(BuildContext context) {
  return const BottomAppBarTheme().copyWith(
      color: ScaffoldBackgroundColor.light.color.withOpacity(0.8),
      elevation: 10);
}

BottomAppBarTheme darkBottomAppBarTheme(BuildContext context) {
  return const BottomAppBarTheme().copyWith(
      color: ScaffoldBackgroundColor.dark.color.withOpacity(1), elevation: 10);
}
