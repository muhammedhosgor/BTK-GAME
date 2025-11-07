import 'package:flutter/material.dart';
import 'package:flutter_base_app/product/components/container/gold_nav.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_base_app/product/constant/color_constants.dart';
import 'package:flutter_base_app/product/components/button/primary_game_button.dart';
import 'package:flutter_base_app/feature/auth/login/model/user_model.dart';

class ThemedStorePage extends StatelessWidget {
  final UserModel user;

  const ThemedStorePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> giftCards = [
      {
        'title': 'Amazon Gift Card',
        'image': 'https://www.pngall.com/wp-content/uploads/15/Amazon-Logo-White.png',
        'requiredPoint': 100,
      },
      {
        'title': 'Netflix Gift Card',
        'image': 'https://1000logos.net/wp-content/uploads/2017/05/Netflix-Logo.png',
        'requiredPoint': 250,
      },
      {
        'title': 'Apple Gift Card',
        'image': 'https://1000logos.net/wp-content/uploads/2017/02/Apple-Logosu.png',
        'requiredPoint': 500,
      },
      {
        'title': 'Google Play Gift Card',
        'image': 'https://1000logos.net/wp-content/uploads/2021/07/Google-Play-Logo.png',
        'requiredPoint': 1000,
      },
    ];

    return Scaffold(
      body: Container(
        height: 1.sh,
        width: 1.sw,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/asset/bg.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.darken),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
            child: Column(
              children: [
                // 🏆 Başlık
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Color(0xFFFFD700), Color(0xFFF5B700)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds),
                  child: Text(
                    "🎁 GAME STORE",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28.sp,
                      color: Colors.white,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                const GoldNavContainer(),
                SizedBox(height: 20.h),

                // 💰 Kullanıcı puanı bölümü
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: LinearGradient(
                      colors: [Colors.black.withOpacity(0.6), Colors.black.withOpacity(0.2)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    border: Border.all(color: kSuitGold, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: kSuitGold.withOpacity(0.4),
                        blurRadius: 15,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.monetization_on, color: Colors.amber, size: 26),
                      SizedBox(width: 8.w),
                      Text(
                        "${user.point ?? 0} Points",
                        style: TextStyle(
                          color: kSuitGold,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.sp,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.7),
                              blurRadius: 5,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),

                // 🎴 Mağaza Kartları
                Expanded(
                  child: GridView.builder(
                    itemCount: giftCards.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 18.w,
                      crossAxisSpacing: 18.w,
                      childAspectRatio: 0.78,
                    ),
                    itemBuilder: (context, index) {
                      final card = giftCards[index];
                      final bool isUnlocked = (user.point ?? 0) >= card['requiredPoint'];

                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: isUnlocked
                                ? [Colors.black.withOpacity(0.7), Colors.black.withOpacity(0.4)]
                                : [Colors.grey.shade900, Colors.grey.shade800],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isUnlocked ? kSuitGold : Colors.grey.withOpacity(0.3),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: isUnlocked ? kSuitGold.withOpacity(0.6) : Colors.black.withOpacity(0.4),
                              blurRadius: 10,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.all(8.w),
                                  child: Image.network(
                                    card['image'],
                                    fit: BoxFit.contain,
                                    color: isUnlocked ? null : Colors.white.withOpacity(0.25),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 8.h),
                                child: Column(
                                  children: [
                                    Text(
                                      card['title'],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      "${card['requiredPoint']} Points",
                                      style: TextStyle(
                                        color: kSuitGold,
                                        fontSize: 13.sp,
                                      ),
                                    ),
                                    SizedBox(height: 8.h),
                                    SizedBox(
                                      width: 0.32.sw,
                                      height: 40.h,
                                      child: PrimaryGameButton(
                                        buttonColor:
                                            isUnlocked ? const Color(0xFF00C853) : Colors.grey.withOpacity(0.4),
                                        text: isUnlocked ? "Claim" : "Locked",
                                        fontSize: 16.sp,
                                        icon: isUnlocked ? Icons.check_circle : Icons.lock_outline,
                                        onTap: isUnlocked
                                            ? () {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    backgroundColor: kSuitGold,
                                                    content: Text(
                                                      "${card['title']} claimed successfully!",
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }
                                            : null,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // 🔙 Geri Butonu
                Padding(
                  padding: EdgeInsets.only(top: 10.h),
                  child: PrimaryGameButton(
                    buttonColor: kButtonGrey,
                    text: "Back",
                    icon: Icons.arrow_back,
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
