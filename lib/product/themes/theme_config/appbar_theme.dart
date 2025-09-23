import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base_app/product/themes/theme_config/color_scheme.dart';

AppBarTheme lightAppBarTheme(BuildContext context) {
  return AppBarTheme(
    systemOverlayStyle: const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.transparent,
    ),
    titleTextStyle: Theme.of(context)
        .textTheme
        .titleLarge
        ?.copyWith(color: LightAppBarColor.titleTextStyle.color),
    elevation: 0,
    color: LightAppBarColor.appBar.color,
    iconTheme: IconThemeData(
      color: LightAppBarColor.iconThemeColor.color,
    ),
  );
}

AppBarTheme darkAppBarTheme(BuildContext context) {
  return AppBarTheme(
    systemOverlayStyle: const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
      statusBarColor: Colors.transparent,
    ),
    toolbarTextStyle: TextStyle(
      color: DarkAppBarColor.toolbarText.color,
    ),
    titleTextStyle: Theme.of(context)
        .textTheme
        .titleLarge
        ?.copyWith(color: DarkAppBarColor.titleTextStyle.color),
    elevation: 0,
    color: DarkAppBarColor.appBar.color,
    iconTheme: IconThemeData(
      color: DarkAppBarColor.iconTheme.color,
    ),
  );
}
