import 'package:flutter/material.dart';
import 'package:flutter_base_app/product/components/button/image_button.dart';
import 'package:flutter_base_app/product/components/button/primary_game_button.dart';
import 'package:flutter_base_app/product/components/container/gold_nav.dart';
import 'package:flutter_base_app/product/constant/color_constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: 1.sw,
      height: 1.sh,
      // color: kTableGreen,
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage('assets/asset/bg.jpg'),
          fit: BoxFit.cover,
          opacity: 0.9,
        ),
        boxShadow: [
          BoxShadow(
            color: kBlackColor.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
              width: 1.sw,
              height: 100.h,
              color: kTableNavy,
              child: Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: kWhiteColor, width: 2),
                        ),
                        child: ClipOval(
                          child: Image.network(
                            'https://avatars.githubusercontent.com/u/12345678?v=4',
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    'Welcome, Player!',
                    style: TextStyle(color: kWhiteColor, fontSize: 20.sp, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  SizedBox(width: 10.w),
                  ImageButton(
                    imagePath: 'assets/asset/star.png',
                    onTap: () {},
                  ),
                  SizedBox(width: 10.w),
                  ImageButton(
                    imagePath: 'assets/asset/settings.png',
                    onTap: () {},
                  ),
                  SizedBox(width: 10.w),
                ],
              )),
          const GoldNavContainer(),
          SizedBox(height: 10.h),
          Container(
            width: 0.95.sw,
            height: 100.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: kButtonGrey, width: 2),
              boxShadow: [
                BoxShadow(
                  color: kBlackColor.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Row(
              spacing: 20.w,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ImageButton(onTap: () {}, imagePath: 'assets/asset/online.png'),
                ImageButton(onTap: () {}, imagePath: 'assets/asset/mail.png'),
                ImageButton(onTap: () {}, imagePath: 'assets/asset/frends.png'),
                ImageButton(onTap: () {}, imagePath: 'assets/asset/star.png'),
                ImageButton(onTap: () {}, imagePath: 'assets/asset/info.png')
              ],
            ),
          ),
          SizedBox(height: 20.h),
          Container(
            width: 0.8.sw,
            height: 0.5.sh,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: kWhiteColor, width: 2),
              image: const DecorationImage(
                image: AssetImage('assets/asset/bg.jpg'),
                fit: BoxFit.cover,
                opacity: 0.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: kBlackColor.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 4.0.w),
              child: Column(
                spacing: 15.h,
                children: [
                  SizedBox(height: 2.h),
                  Text("Play Now!", style: TextStyle(color: kWhiteColor, fontSize: 22.sp, fontWeight: FontWeight.bold)),
                  const GoldNavContainer(),
                  PrimaryGameButton(
                    buttonColor: kButtonGreen,
                    text: 'Login',
                    icon: Icons.login,
                  ),
                  PrimaryGameButton(
                    buttonColor: Colors.blue,
                    text: 'Guest Login',
                    icon: Icons.person_outline,
                  ),
                  PrimaryGameButton(
                    buttonColor: Colors.deepOrange,
                    text: 'Offline Play',
                    icon: Icons.wifi_off,
                  ),
                  PrimaryGameButton(
                    buttonColor: kSuitRed,
                    text: 'Exit Game',
                    icon: Icons.exit_to_app,
                  ),
                  PrimaryGameButton(
                    buttonColor: Colors.deepPurpleAccent,
                    text: 'Privacy Policy',
                    icon: Icons.privacy_tip,
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          Text(
            'Version 1.0.0',
            style: TextStyle(color: kWhiteColor, fontWeight: FontWeight.bold, fontSize: 14.sp),
          ),
          SizedBox(height: 10.h),
          Text(
            '© 2025 YourGameCompany',
            style: TextStyle(color: kWhiteColor, fontWeight: FontWeight.bold, fontSize: 14.sp),
          ),
          SizedBox(height: 20.h),
          const GoldNavContainer(),
        ],
      ),
    ));
  }
}
