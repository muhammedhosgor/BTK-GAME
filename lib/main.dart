import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base_app/product/configuration/text_config.dart';
import 'package:flutter_base_app/product/initial/application_initialize.dart';
import 'package:flutter_base_app/product/initial/language_localization.dart';
import 'package:flutter_base_app/product/injector/injector.dart';
import 'package:flutter_base_app/product/routes/app_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';

Future<void> main() async {
  _initMain();
  await EasyLocalization.ensureInitialized(); // Uygulama dil desteği için gerekli olan kütüphane
  runApp(LanguageLocalization(child: const MyApp()));
}

Future<void> _initMain() async {
  await GetStorage.init(); //* Storage initialization
  await initializeDependencies(); //* Dependency injection initialization
  ApplicationInitialize.make(); //* Application initialization
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(430, 932),
      minTextAdapt: true,
      builder: (context, child) => MaterialApp.router(
          localizationsDelegates: context.localizationDelegates, //* Your delegates for this app
          supportedLocales: context.supportedLocales, //* Your supported locales
          locale: context.locale, //* Your locale
          builder: (context, child) {
            return AnnotatedRegion<SystemUiOverlayStyle>(
                value: SystemUiOverlayStyle.light,
                child: MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                      textScaler: const TextScaler.linear(TextConfig.textScaleFactor), alwaysUse24HourFormat: true),
                  child: Platform.isIOS
                      ? Container(
                          color: Colors.transparent,
                          child: SafeArea(
                            top: true,
                            bottom: false,
                            child: child!,
                          ))
                      : Container(
                          color: Colors.transparent,
                          child: SafeArea(child: child!),
                        ),
                ));
          },
          title: 'Başlık',

          //* dark theme settings

          // themeMode: (ilgili kosul == true)
          //     ? ThemeMode.dark
          //     : ThemeMode.light,

          debugShowCheckedModeBanner: false,
          routerConfig: AppRoute.router,
          theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.blue,
          ) //MyThemeData().lightThemeData(context),
          ),
    );
  }
}
