// --------------------------------------------------------------------------
// MARK: - ANA DİYALOG WIDGET'I
import 'package:flutter/material.dart';
import 'package:flutter_base_app/feature/auth/login/cubit/login_cubit.dart';
import 'package:flutter_base_app/feature/auth/login/widget/waiting_room_widget.dart';
import 'package:flutter_base_app/feature/auth/login/widget/join_widget.dart';
import 'package:flutter_base_app/product/components/button/primary_game_button.dart';
import 'package:flutter_base_app/product/components/container/gold_nav.dart';
import 'package:flutter_base_app/product/constant/color_constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Oyun odası kurma ve katılma seçeneklerini sunan temalı iletişim kutusu.
class GameRoomSelectionDialog extends StatelessWidget {
  const GameRoomSelectionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final double dialogWidth = MediaQuery.of(context).size.width * 0.9;

    return Center(
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          width: dialogWidth,
          // Maksimum genişlik ve yükseklik kısıtlamaları eklenmiştir.
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.7,
            maxWidth: 400,
          ),
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: kTableNavy, // Koyu Lacivert Arkaplan
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: kSuitGold, width: 4), // Altın Çerçeve
            boxShadow: [
              BoxShadow(
                color: kBlackColor.withOpacity(0.9),
                spreadRadius: 5,
                blurRadius: 25,
                offset: const Offset(0, 10),
              ),
            ],
            // Arkaplan deseni (Placeholder görsel kullanıldı)
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Başlık
              const Text(
                "OYUN MODU SEÇİN",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: kSuitGold,
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                  shadows: [
                    Shadow(color: kBlackColor, blurRadius: 5, offset: Offset(2, 2)),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              const GoldNavContainer(), // Altın Ayırıcı
              const SizedBox(height: 30),

              // Açıklama Metni
              const Text(
                "Yeni bir oyun odası oluşturun veya mevcut bir odaya katılın.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: kWhiteColor,
                  fontSize: 17,
                  fontWeight: FontWeight.w300,
                  fontStyle: FontStyle.italic,
                  shadows: [
                    Shadow(color: kBlackColor, blurRadius: 2),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // 1. Seçenek: Oda Kur
              PrimaryGameButton(
                buttonColor: kAccentGreen, // Vurgulu renk (Yeşil)
                text: 'ODA KUR',
                icon: Icons.add_business_rounded,
                onTap: () {
                  context.read<LoginCubit>().createRoom().whenComplete(() {
                    // Oda oluşturma işlemi tamamlandığında diyalogdan çık
                    Navigator.of(context).pop();
                    showDialog(
                      context: context,
                      barrierDismissible: true, // Dışarıya tıklayınca kapanabilir
                      builder: (BuildContext context) {
                        return BlocProvider.value(
                          value: LoginCubit(),
                          child: const WaitingRoomScreen(),
                        );
                      },
                    );
                  });
                },
              ),
              const SizedBox(height: 20),

              // Ayırıcı Metin
              Text(
                "VEYA",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: kSuitGold.withOpacity(0.8),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 20),

              // 2. Seçenek: Katıl
              PrimaryGameButton(
                buttonColor: kButtonGrey, // Daha sakin bir renk (Gri)
                text: 'KATIL',
                icon: Icons.group_add_rounded,
                onTap: () {
                  // Odaya katılma işlemi buraya gelecek
                  // Diyalogdan çıkış ve bir sonuç döndürme örneği:
                  Navigator.of(context).pop();
                  showDialog(
                    context: context,
                    barrierDismissible: true, // Dışarıya tıklayınca kapanabilir
                    builder: (BuildContext context) {
                      return BlocProvider.value(
                        value: LoginCubit(),
                        child: const JoinRoomScreen(),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 30),

              // Geri Dön Butonu
              InkWell(
                onTap: () {
                  Navigator.of(context).pop('CANCEL');
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Geri Dön",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: kSuitGold,
                      fontSize: 14,
                      decoration: TextDecoration.underline,
                      decorationColor: kSuitGold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
