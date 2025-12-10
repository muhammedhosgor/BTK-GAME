import 'package:flutter/material.dart';
import 'package:flutter_base_app/feature/auth/login/cubit/login_cubit.dart';
import 'package:flutter_base_app/feature/auth/login/cubit/login_state.dart';
import 'package:flutter_base_app/product/components/container/gold_nav.dart';
import 'package:flutter_base_app/product/injector/injector.dart';
import 'package:flutter_base_app/product/storage/local_get_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_base_app/product/constant/color_constants.dart';
import 'package:flutter_base_app/product/components/button/primary_game_button.dart';
import 'package:flutter_base_app/feature/auth/login/model/user_model.dart';
import 'package:go_router/go_router.dart';

class ThemedStorePage extends StatefulWidget {
  final UserModel user;

  const ThemedStorePage({super.key, required this.user});

  @override
  State<ThemedStorePage> createState() => _ThemedStorePageState();
}

class _ThemedStorePageState extends State<ThemedStorePage> {
  @override
  void initState() {
    context.read<LoginCubit>().getAllGifts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 1.sh,
        width: 1.sw,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/asset/bg.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.5), BlendMode.darken),
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
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.6),
                        Colors.black.withOpacity(0.2)
                      ],
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
                      const Icon(Icons.monetization_on,
                          color: Colors.amber, size: 26),
                      SizedBox(width: 8.w),
                      Text(
                        "${widget.user.point ?? 0} Points",
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
                BlocBuilder<LoginCubit, LoginState>(
                  builder: (context, state) {
                    return Expanded(
                      child: GridView.builder(
                        itemCount: state.giftsList.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 18.w,
                          crossAxisSpacing: 18.w,
                          childAspectRatio: 0.78,
                        ),
                        itemBuilder: (context, index) {
                          final card = state.giftsList[index];
                          final bool isUnlocked =
                              (widget.user.point ?? 0) >= card.requiredPoint!;

                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: isUnlocked
                                    ? [
                                        Colors.black.withOpacity(0.7),
                                        Colors.black.withOpacity(0.4)
                                      ]
                                    : [
                                        Colors.grey.shade900,
                                        Colors.grey.shade800
                                      ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isUnlocked
                                    ? kSuitGold
                                    : Colors.grey.withOpacity(0.3),
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: isUnlocked
                                      ? kSuitGold.withOpacity(0.6)
                                      : Colors.black.withOpacity(0.4),
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
                                        'https://btkgameapi.linsabilisim.com/${card.imageUrl}',
                                        fit: BoxFit.contain,
                                        color: isUnlocked
                                            ? null
                                            : Colors.white.withOpacity(0.25),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 6.w, vertical: 8.h),
                                    child: Column(
                                      children: [
                                        Text(
                                          card.title!,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 4.h),
                                        Text(
                                          "${card.requiredPoint} Points",
                                          style: TextStyle(
                                            color: kSuitGold,
                                            fontSize: 13.sp,
                                          ),
                                        ),
                                        SizedBox(height: 8.h),
                                        Text(
                                          "${card.title!.substring(0, 1).toUpperCase() + card.title!.substring(1)}",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12.sp),
                                        ),
                                        Text(
                                          "${widget.user.giftsIds!.contains(card.id.toString())}",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                        Text(
                                          "${card.id}",
                                          style: const TextStyle(
                                            color: Colors.red,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 0.32.sw,
                                          height: 40.h,
                                          child:
                                              widget.user.giftsIds!.contains(
                                                      card.id.toString())
                                                  ? Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.green,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          20,
                                                        ),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          "✅ Claimed",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 16.sp),
                                                        ),
                                                      ),
                                                    )
                                                  : PrimaryGameButton(
                                                      buttonColor: isUnlocked
                                                          ? const Color(
                                                              0xFF00C853)
                                                          : widget.user
                                                                  .giftsIds!
                                                                  .contains(card
                                                                      .id
                                                                      .toString())
                                                              ? const Color(
                                                                  0xFF00C853)
                                                              : Colors.grey
                                                                  .withOpacity(
                                                                      0.4),
                                                      text: isUnlocked
                                                          ? "Claim"
                                                          : widget.user
                                                                  .giftsIds!
                                                                  .contains(card
                                                                      .id
                                                                      .toString())
                                                              ? "Claimed"
                                                              : "Locked",
                                                      fontSize: 16.sp,
                                                      icon: isUnlocked
                                                          ? Icons.check_circle
                                                          : widget.user
                                                                  .giftsIds!
                                                                  .contains(card
                                                                      .id
                                                                      .toString())
                                                              ? Icons
                                                                  .check_circle
                                                              : Icons
                                                                  .lock_outline,
                                                      onTap: isUnlocked
                                                          ? () {
                                                              String type = card
                                                                  .title!
                                                                  .split(" ")[0]
                                                                  .toUpperCase();

                                                              showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (dialogContext) =>
                                                                        Dialog(
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            16),
                                                                  ),
                                                                  backgroundColor:
                                                                      Colors
                                                                          .transparent, // transparan arka plan ile glow efekti
                                                                  child: Stack(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    children: [
                                                                      // Glow / arka plan
                                                                      Container(
                                                                        width:
                                                                            320,
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            16),
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          gradient:
                                                                              const LinearGradient(
                                                                            colors: [
                                                                              kTableNavy,
                                                                              Color.fromARGB(255, 10, 23, 49)
                                                                            ],
                                                                            begin:
                                                                                Alignment.topLeft,
                                                                            end:
                                                                                Alignment.bottomRight,
                                                                          ),
                                                                          borderRadius:
                                                                              BorderRadius.circular(16),
                                                                          boxShadow: [
                                                                            BoxShadow(
                                                                              color: kSuitGold.withOpacity(0.6),
                                                                              blurRadius: 5,
                                                                              spreadRadius: 2,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        child:
                                                                            Column(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          children: [
                                                                            // Kart resmi / ikon
                                                                            const Icon(
                                                                              Icons.card_giftcard,
                                                                              size: 80,
                                                                              color: kSuitGold,
                                                                            ),
                                                                            const SizedBox(height: 12),
                                                                            // Başlık
                                                                            const Text(
                                                                              "Claim Your Gift!",
                                                                              style: TextStyle(
                                                                                fontSize: 18,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.yellowAccent,
                                                                                shadows: [
                                                                                  Shadow(
                                                                                    blurRadius: 4,
                                                                                    color: Colors.black,
                                                                                    offset: Offset(1, 1),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              textAlign: TextAlign.center,
                                                                            ),
                                                                            const SizedBox(height: 8),
                                                                            // Açıklama
                                                                            Text(
                                                                              "Are you sure you want to claim this gift?\n${card.title}",
                                                                              style: const TextStyle(
                                                                                fontSize: 14,
                                                                                color: Colors.white,
                                                                              ),
                                                                              textAlign: TextAlign.center,
                                                                            ),
                                                                            const SizedBox(height: 16),
                                                                            // Butonlar
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                              children: [
                                                                                // Cancel
                                                                                ElevatedButton(
                                                                                  style: ElevatedButton.styleFrom(
                                                                                    backgroundColor: Colors.red.shade700,
                                                                                    shape: RoundedRectangleBorder(
                                                                                      borderRadius: BorderRadius.circular(12),
                                                                                    ),
                                                                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                                                                  ),
                                                                                  onPressed: () {
                                                                                    Navigator.pop(dialogContext);
                                                                                  },
                                                                                  child: const Text("Cancel", style: TextStyle(color: Colors.white)),
                                                                                ),
                                                                                // Claim
                                                                                ElevatedButton(
                                                                                  style: ElevatedButton.styleFrom(
                                                                                    backgroundColor: Colors.greenAccent.shade700,
                                                                                    shape: RoundedRectangleBorder(
                                                                                      borderRadius: BorderRadius.circular(12),
                                                                                    ),
                                                                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                                                                  ),
                                                                                  onPressed: () async {
                                                                                    var result = await context.read<LoginCubit>().claimGift(
                                                                                          widget.user.email!,
                                                                                          type,
                                                                                          widget.user.id!,
                                                                                          card.requiredPoint!,
                                                                                          card.id!,
                                                                                        );
                                                                                    if (result == true) {
                                                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                                                        SnackBar(
                                                                                          backgroundColor: kSuitGold,
                                                                                          content: Text(
                                                                                            "${card.title} claimed successfully!",
                                                                                            style: const TextStyle(
                                                                                              color: Colors.black,
                                                                                              fontWeight: FontWeight.bold,
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      );
                                                                                      var password = injector.get<LocalStorage>().getString('password') ?? '';
                                                                                      int? userId = injector<LocalStorage>().getInt('userId');
                                                                                      Future.wait({
                                                                                        context.read<LoginCubit>().getUserList(),
                                                                                        context.read<LoginCubit>().getAllGifts(),
                                                                                      });
                                                                                      if (userId != null) {
                                                                                        context.read<LoginCubit>().getUserPoint(userId);
                                                                                      }

                                                                                      setState(() {});
                                                                                      context.pushReplacement('/login_view');
                                                                                    } else {
                                                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                                                        SnackBar(
                                                                                          backgroundColor: kSuitRed,
                                                                                          content: Text(
                                                                                            "${card.title} claim failed!",
                                                                                            style: const TextStyle(
                                                                                              color: Colors.black,
                                                                                              fontWeight: FontWeight.bold,
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      );
                                                                                      Navigator.of(context).pop();
                                                                                    }
                                                                                  },
                                                                                  child: const Text("Claim", style: TextStyle(color: Colors.black)),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              );
                                                            }
                                                          : widget.user
                                                                  .giftsIds!
                                                                  .contains(card
                                                                      .id
                                                                      .toString())
                                                              ? null
                                                              : () {},
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
                    );
                  },
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
