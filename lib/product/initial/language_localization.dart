import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_app/product/enum/locales_enum.dart';

class LanguageLocalization extends EasyLocalization {
  LanguageLocalization({
    required super.child,
    super.key,
  }) : super(
          supportedLocales: _supportedLocalesItems,
          path: _locazationPath,
          useOnlyLangCode: true,
        );

  static final List<Locale> _supportedLocalesItems = [
    Locales.tr.locale,
    Locales.en.locale,
  ];
  static const String _locazationPath = 'assets/translations';

  static Future<void> updateLanguage({required BuildContext context, required Locales value}) async {
    context.setLocale(value.locale);
  }
}
