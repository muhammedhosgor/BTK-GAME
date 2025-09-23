import 'package:flutter/material.dart';

extension ContexExtension on BuildContext {
  MediaQueryData get mediaQuery => MediaQuery.of(this);
}

extension MediaQueriyExtension on BuildContext {
  double get height => mediaQuery.size.height;
  double get width => mediaQuery.size.width;

  //* Padding Extension için
  double get lowValue => height * 0.01;
  double get normalValue => height * 0.03;
  double get mediumValue => height * 0.04;
  double get highValue => height * 0.05;
}
