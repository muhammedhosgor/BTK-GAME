import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base_app/feature/auth/login/cubit/login_cubit.dart';
import 'package:flutter_base_app/feature/auth/login/cubit/login_state.dart';
import 'package:flutter_base_app/feature/auth/login/model/user_model.dart';
import 'package:flutter_base_app/feature/auth/login/widget/active_user_list_widget.dart';
import 'package:flutter_base_app/feature/auth/login/widget/exit_game_dialog_widget.dart';
import 'package:flutter_base_app/feature/auth/login/widget/game_room_widget.dart';
import 'package:flutter_base_app/feature/auth/login/widget/how_to_play_step_widget.dart';
import 'package:flutter_base_app/feature/auth/login/widget/how_to_play_widget.dart';
import 'package:flutter_base_app/feature/auth/login/widget/login_widget.dart';
import 'package:flutter_base_app/feature/auth/login/widget/privacy_policy_widget.dart';
import 'package:flutter_base_app/feature/auth/login/widget/store_widget.dart';
import 'package:flutter_base_app/product/components/button/image_button.dart';
import 'package:flutter_base_app/product/components/button/primary_game_button.dart';
import 'package:flutter_base_app/product/components/container/gold_nav.dart';
import 'package:flutter_base_app/product/constant/color_constants.dart';
import 'package:flutter_base_app/product/injector/injector.dart';
import 'package:flutter_base_app/product/storage/local_get_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  var userName = injector.get<LocalStorage>().getString('userName') ?? 'Guest';
  var email = injector.get<LocalStorage>().getString('email') ?? '';
  int? userId = injector.get<LocalStorage>().getInt('userId');
  var userSurname = injector.get<LocalStorage>().getString('userSurname') ?? '';
  var image = injector.get<LocalStorage>().getString('image') ?? '';

  @override
  void initState() {
    super.initState();

    context.read<LoginCubit>().getUserPoint(userId ?? 0);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: 1.sw,
        height: 1.sh,
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage('assets/asset/bg.jpg'),
            fit: BoxFit.cover,
          ),
          gradient: LinearGradient(
            colors: [
              Colors.black.withOpacity(0.8),
              kTableNavy.withOpacity(0.8)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // === ÜST KISIM: Oyun Başlığı + Profil Bilgisi ===
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: Row(
                  children: [
                    // Profil resmi
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: kSuitGold, width: 2),
                        boxShadow: [
                          BoxShadow(
                              color: kSuitGold.withOpacity(0.6), blurRadius: 8),
                        ],
                      ),
                      child: image.isEmpty
                          ? const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(Icons.person,
                                  color: Colors.white, size: 50),
                            )
                          : ClipOval(
                              child: Image.network(
                                'https://btkgameapi.linsabilisim.com/$image',
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('$userName $userSurname',
                              style: TextStyle(
                                color: kWhiteColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.sp,
                                shadows: [
                                  Shadow(
                                      color: Colors.black.withOpacity(0.8),
                                      blurRadius: 4)
                                ],
                              )),
                          Text('Welcome back!',
                              style: TextStyle(
                                  color: Colors.grey[300],
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400)),
                        ],
                      ),
                    ),
                    // Mini ikonlar (bilgi - aktif kullanıcı - ayarlar)
                    Row(
                      children: [
                        ImageButton(
                          imagePath: 'assets/asset/online.png',
                          onTap: () => showDialog(
                            context: context,
                            builder: (_) => BlocProvider.value(
                              value: LoginCubit(),
                              child: const ThemedUserListDialog(),
                            ),
                          ),
                        ),
                        ImageButton(
                          imagePath: 'assets/asset/info.png',
                          onTap: () => showDialog(
                            context: context,
                            builder: (_) => BlocProvider.value(
                              value: LoginCubit(),
                              //  child: const ThemedHowToPlayDialog(),
                              child: const HowToPlayStepDialog(),
                            ),
                          ),
                        ),
                        BlocBuilder<LoginCubit, LoginState>(
                          builder: (context, state) {
                            return Visibility(
                              visible: state.visible,
                              child: ImageButton(
                                imagePath: 'assets/asset/store.png',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BlocProvider.value(
                                        value: LoginCubit(),
                                        child: ThemedStorePage(
                                          user: UserModel(
                                            id: userId!,
                                            name: userName,
                                            surname: userSurname,
                                            email: email,
                                            password: '',
                                            point: state.userPoint,
                                            giftsIds: state.userGiftsIds,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // === Oyun Başlığı ===
              // Padding(
              //   padding: EdgeInsets.only(top: 10.h),
              //   child: Text(
              //     'BTK CARD GAME',
              //     style: TextStyle(
              //       fontSize: 28.sp,
              //       fontWeight: FontWeight.bold,
              //       color: kSuitGold,
              //       letterSpacing: 2,
              //       shadows: [
              //         Shadow(
              //             color: Colors.black.withOpacity(0.8), blurRadius: 8),
              //         Shadow(color: kSuitGold.withOpacity(0.7), blurRadius: 12),
              //       ],
              //     ),
              //   ),
              // ),
              Image.asset(
                'assets/asset/valor3.png',
                width: 0.6.sw,
              ),

              SizedBox(height: 5.h),

              // === Puan Alanı (Ortada büyük coin göstergesi) ===
              BlocBuilder<LoginCubit, LoginState>(
                builder: (context, state) {
                  return Container(
                    width: 0.40.sw,
                    height: 0.40.sw,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withOpacity(0.7),
                      boxShadow: [
                        BoxShadow(
                            color: kSuitGold.withOpacity(0.4),
                            blurRadius: 20,
                            spreadRadius: 2),
                      ],
                      border: Border.all(color: Colors.amberAccent, width: 3),
                    ),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(FontAwesomeIcons.coins,
                            color: kSuitGold, size: 45.sp),
                        SizedBox(height: 5.h),
                        Text(
                          state.userPoint != 0
                              ? state.userPoint.toString()
                              : '0',
                          style: TextStyle(
                            color: kWhiteColor,
                            fontSize: 34.sp,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                  color: kSuitGold.withOpacity(0.7),
                                  blurRadius: 10),
                            ],
                          ),
                        ),
                        Text(
                          'Your Points',
                          style: TextStyle(
                              color: Colors.grey[300],
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  );
                },
              ),

              SizedBox(height: 5.h),

              // === Ana Menü Butonları ===
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Visibility(
                      visible: injector.get<LocalStorage>().getInt('userId') ==
                              null ||
                          injector.get<LocalStorage>().getInt('userId') == 0,
                      child: PrimaryGameButton(
                        buttonColor: kButtonGreen,
                        text: 'Login',
                        icon: FontAwesomeIcons.rightToBracket,
                        onTap: () => showDialog(
                          context: context,
                          builder: (_) => BlocProvider.value(
                            value: LoginCubit(),
                            child: const ThemedLoginDialog(),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15.h),
                    Visibility(
                      visible: injector.get<LocalStorage>().getInt('userId') !=
                              null &&
                          injector.get<LocalStorage>().getInt('userId') != 0,
                      child: BlocBuilder<LoginCubit, LoginState>(
                        builder: (context, state) {
                          return PrimaryGameButton(
                            buttonColor: Colors.blueAccent,
                            text: 'Start Game',
                            icon: FontAwesomeIcons.play,
                            onTap: () {
                              if (userId != null && userId != 0) {
                                // ✅ Giriş yapılmış → Oyun odası seçim penceresi aç
                                showDialog(
                                  context: context,
                                  builder: (_) => BlocProvider.value(
                                    value: context.read<LoginCubit>(),
                                    child: const GameRoomSelectionDialog(),
                                  ),
                                );
                              } else {
                                // ❌ Giriş yapılmamış → Uyarı göster
                                showDialog(
                                  context: context,
                                  builder: (dialogContext) {
                                    return AlertDialog(
                                      backgroundColor:
                                          Colors.black.withOpacity(0.85),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        side: const BorderSide(
                                            color: Colors.redAccent, width: 2),
                                      ),
                                      title: const Row(
                                        children: [
                                          Icon(Icons.warning_amber_rounded,
                                              color: Colors.redAccent,
                                              size: 30),
                                          SizedBox(width: 10),
                                          Text(
                                            "Warning",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      content: const Text(
                                        "You must log in first to start the game.",
                                        style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 15),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(dialogContext).pop(),
                                          child: const Text(
                                            "OK",
                                            style: TextStyle(
                                                color: Colors.redAccent,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 15.h),
                    PrimaryGameButton(
                      buttonColor: Colors.deepPurpleAccent,
                      text: 'Privacy Policy',
                      icon: FontAwesomeIcons.shieldHalved,
                      onTap: () => showDialog(
                        context: context,
                        builder: (_) => BlocProvider.value(
                          value: LoginCubit(),
                          child: const ThemedPrivacyPolicyDialog(),
                        ),
                      ),
                    ),
                    SizedBox(height: 15.h),
                    PrimaryGameButton(
                      buttonColor: kSuitRed,
                      text: 'Exit Game',
                      icon: FontAwesomeIcons.doorOpen,
                      onTap: () => showDialog(
                        context: context,
                        builder: (_) => BlocProvider.value(
                          value: LoginCubit(),
                          child: const ThemedConfirmExitDialog(),
                        ),
                      ),
                    ),
                    SizedBox(height: 15.h),
                    Visibility(
                      visible: injector.get<LocalStorage>().getInt('userId') ==
                              null ||
                          injector.get<LocalStorage>().getInt('userId') == 0,
                      child: PrimaryGameButton(
                        buttonColor: Colors.deepOrange,
                        text: 'Sign Up',
                        icon: FontAwesomeIcons.userPlus,
                        onTap: () => context.pushReplacement('/register_view'),
                      ),
                    ),

                    SizedBox(height: 15.h),
                    // PrimaryGameButton(
                    //   buttonColor: Colors.black38,
                    //   text: 'Forgot Password',
                    //   icon: FontAwesomeIcons.arrowsRotate,
                    //   onTap: () =>
                    // ),
                    TextButton(
                      onPressed: () {
                        context.pushReplacement('/forget_password_view');
                      },
                      child: Text(
                        "Forgot your password?",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            decorationColor: kSuitGold),
                      ),
                    ),

                    SizedBox(height: 15.h),
                    Visibility(
                      visible: injector.get<LocalStorage>().getInt('userId') !=
                              null &&
                          injector.get<LocalStorage>().getInt('userId') != 0,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: kButtonRed,
                            side: const BorderSide(color: Colors.white30)),
                        onPressed: () => showDialog(
                            context: context,
                            builder: (dialogContext) => BlocProvider.value(
                                  value: LoginCubit(),
                                  child: AlertDialog(
                                    // 1. More emphatic title with a warning icon
                                    title: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text('Confirm Account\nDeletion',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                    // 2. More informative and clear content
                                    content: const Text(
                                        'You are about to delete your account. This action **cannot be undone**.\n\nAll your data will be permanently erased. Are you absolutely sure you want to proceed?',
                                        textAlign: TextAlign.center),
                                    actions: [
                                      // 3. Keep the 'Cancel' button less aggressive
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(dialogContext).pop(),
                                        child: const Text(
                                          "Cancel",
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ),
                                      // 4. Make the 'Delete' action the primary, high-contrast button
                                      BlocBuilder<LoginCubit, LoginState>(
                                        builder: (context, state) {
                                          return ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.red, // Red background
                                              foregroundColor:
                                                  Colors.white, // White text
                                              elevation: 3,
                                            ),
                                            onPressed: () async {
                                              ScaffoldMessenger.of(context)
                                                  .hideCurrentSnackBar();
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    'Account deleted successfully',
                                                    style: TextStyle(
                                                        color: Colors.green,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 15.sp),
                                                  ),
                                                  duration: const Duration(
                                                      seconds: 2),
                                                ),
                                              );
                                              context
                                                  .read<LoginCubit>()
                                                  .deleteAccount(injector
                                                      .get<LocalStorage>()
                                                      .getInt('userId')!);

                                              context
                                                  .read<LoginCubit>()
                                                  .closeApp();

                                              Navigator.of(context).pop();
                                              setState(() {});
                                              SystemNavigator.pop();
                                              exit(0);
                                            },
                                            child: const Text(
                                              "Permanently Delete Account",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                    // 5. Align actions to the right
                                    actionsAlignment: MainAxisAlignment.end,
                                    // 6. Slightly rounded corners for a modern look
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                )),
                        child: const Text(
                          'Delete my account',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 15.h),
                  ],
                ),
              ),

              // === Alt Bilgi ===
              Column(
                children: [
                  const GoldNavContainer(),
                  SizedBox(height: 8.h),
                  Text('Version 1.0.0',
                      style: TextStyle(
                          color: kWhiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 13.sp)),
                  Text('© 2025 Valor of Cards',
                      style: TextStyle(
                          color: kWhiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 13.sp)),
                  SizedBox(height: 10.h),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
