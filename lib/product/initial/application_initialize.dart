import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base_app/product/initial/config/app_enviroment.dart';
import 'package:flutter_base_app/product/initial/config/env_dev.dart';
import 'package:logger/logger.dart';

@immutable

/// Uygulama ilk açıldığında çalışacak olan sınıf
class ApplicationInitialize {
  /// Uygulama ilk açıldığında çalışacak olan fonksiyon
  static Future<void> make() async {
    await runZonedGuarded<Future<void>>(() => _initialize(), (error, stack) {
      Logger().e('Error: $error');
      Logger().e('Stack: $stack');
    });
  }

  static Future<void> _initialize() async {
    /// Uygulama ilk açıldığında çalışacak olan kodlar burada yer alır.

    WidgetsFlutterBinding.ensureInitialized();

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]); // Uygulama dikey modda çalışsın diye.
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky,
        overlays: [SystemUiOverlay.bottom]); // close status bar
    //Todo: Dependency Injection

    /// Uygulama ortamı için gerekli değerlerin ayarlandığı metod
    AppEnvironment.setup(config: DevEnv());
  }
}
