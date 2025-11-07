// Bu dosya, harici paket bağımlılıklarını kullanacak şekilde güncellenmiştir.
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_base_app/feature/auth/login/cubit/login_cubit.dart';
import 'package:flutter_base_app/feature/auth/login/cubit/login_state.dart';
import 'package:flutter_base_app/feature/auth/login/model/user_model.dart';
import 'package:flutter_base_app/product/components/button/primary_game_button.dart';
import 'package:flutter_base_app/product/components/container/gold_nav.dart';
import 'package:flutter_base_app/product/constant/color_constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// MARK: - USER LIST DIALOG WIDGET
/// Temaya uygun aktif kullanıcı listesi iletişim kutusu.
class ThemedUserListDialog extends StatelessWidget {
  const ThemedUserListDialog({super.key});

  Widget _buildUserListItem(UserModel user) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
      child: Row(
        children: [
          // Online Status Indicator
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: kSuitGold, width: 2),
              boxShadow: [
                BoxShadow(color: kSuitGold.withOpacity(0.6), blurRadius: 8),
              ],
            ),
            child: user.image!.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.person, color: Colors.white, size: 50),
                  )
                : ClipOval(
                    child: Image.network(
                      'https://btkgameapi.linsabilisim.com/${user.image!}',
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
          ),
          SizedBox(
            width: 10.w,
          ),
          Transform.translate(
            offset: Offset(-25.w, -20.w),
            child: Container(
              width: 16.w,
              height: 16.w,
              decoration: BoxDecoration(
                  color: user.status == "Oyunda"
                      ? kButtonGreen
                      : user.status == "Bitirdi"
                          ? kSuitRed
                          : kSuitGold,
                  shape: BoxShape.circle,
                  boxShadow: [
                    // Harici sabit kullanılıyor
                    BoxShadow(
                      color: user.status == "Oyunda"
                          ? kButtonGreen.withOpacity(0.8)
                          : user.status == "Bitirdi"
                              ? kSuitRed.withOpacity(0.5)
                              : kSuitGold.withOpacity(0.5), // Harici sabit kullanılıyor
                      blurRadius: 4,
                    )
                  ]),
            ),
          ),
          const SizedBox(width: 15),

          // Name and Level
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name ?? 'Bilinmiyor', // user.name'i kullanır, null ise 'Bilinmiyor' yazar.
                  style: const TextStyle(
                    color: kWhiteColor, // Harici sabit kullanılıyor
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  //  '${user.level} | ${user.status}',
                  '${user.point} | ${user.status}',
                  style: TextStyle(
                    color: kSuitGold.withOpacity(0.9), // Harici sabit kullanılıyor
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Action/Detail Icon (Mock)
          Icon(
            Icons.group,
            color: kWhiteColor.withOpacity(0.7), // Harici sabit kullanılıyor
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Dialog boyutunu ekranın yaklaşık %80'i olarak ayarla.
    final double dialogWidth = MediaQuery.of(context).size.width * 0.8;

    return Center(
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          width: dialogWidth,
          height: MediaQuery.of(context).size.height * 0.8,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: kTableNavy, // Harici sabit kullanılıyor
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: kSuitGold, width: 3), // Harici sabit kullanılıyor
            boxShadow: [
              BoxShadow(
                color: kBlackColor.withOpacity(0.8), // Harici sabit kullanılıyor
                spreadRadius: 5,
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Başlık (BlocBuilder ile dinamik online kullanıcı sayısı)
              BlocBuilder<LoginCubit, LoginState>(
                builder: (context, state) {
                  // state.userList'teki aktif (isOnline: true) kullanıcı sayısını hesaplar.
                  final onlineCount = state.userList.where((u) => u.status == "Musait" || u.status == "Oyunda").length;
                  return Text(
                    "Leader Board ($onlineCount ONLINE)",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: kSuitGold, // Harici sabit kullanılıyor
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      shadows: [
                        Shadow(
                            color: kBlackColor.withOpacity(0.8),
                            blurRadius: 5,
                            offset: const Offset(1, 2)), // Harici sabit kullanılıyor
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              const GoldNavContainer(), // Harici widget kullanılıyor
              const SizedBox(height: 20),

              // Kullanıcı Listesi (Scrollable) - BlocBuilder ile dinamik veri çekimi
              BlocBuilder<LoginCubit, LoginState>(
                builder: (context, state) {
                  return Expanded(
                    child: ListView.separated(
                      // userList'teki öğe sayısını kullanır.
                      itemCount: state.userList.length,
                      separatorBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Divider(color: kWhiteColor.withOpacity(0.2), height: 1), // Harici sabit kullanılıyor
                      ),
                      itemBuilder: (context, index) {
                        // userList'teki her bir öğeyi _buildUserListItem'a iletir.
                        final sortedList = [...state.userList]..sort((a, b) => b.point!.compareTo(a.point!));

                        return _buildUserListItem(sortedList[index]);
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),

              // Kapat Butonu
              PrimaryGameButton(
                // Harici widget kullanılıyor
                buttonColor: kButtonGrey, // Harici sabit kullanılıyor
                text: 'Close',
                icon: Icons.close,
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
