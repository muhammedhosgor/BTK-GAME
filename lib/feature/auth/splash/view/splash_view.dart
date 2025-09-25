import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_app/product/enum/locales_enum.dart';
import 'package:flutter_base_app/product/initial/application_initialize.dart';
import 'package:flutter_base_app/product/initial/language/locale_keys.g.dart';
import 'package:flutter_base_app/product/initial/language_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class SplashView extends StatefulWidget {
  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  bool isRinging = false;
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3), () {
      if (isRinging == false) context.pushReplacement('/login_view');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Lottie.asset('assets/lottie/splash.json', width: 350.w, height: 350.h),
        ],
      )),
    );
  }
}
