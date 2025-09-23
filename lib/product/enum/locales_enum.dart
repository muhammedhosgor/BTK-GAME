import 'package:flutter/material.dart';

enum Locales {
  en(Locale('en', 'US')),
  tr(Locale('tr', 'TR'));

  final Locale locale;
  const Locales(this.locale);

  static final List<Locale> supportedLocales = [
    Locales.tr.locale,
    Locales.en.locale,
  ];
}
