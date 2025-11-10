// MARK: - CONFIRM EXIT DIALOG WIDGET
import 'package:flutter/material.dart';
import 'package:flutter_base_app/feature/auth/login/cubit/login_cubit.dart';
import 'package:flutter_base_app/product/components/button/primary_game_button.dart';
import 'package:flutter_base_app/product/components/container/gold_nav.dart';
import 'package:flutter_base_app/product/constant/color_constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Oyundan çıkış onay iletişim kutusu.
class ThemedConfirmExitDialog extends StatelessWidget {
  const ThemedConfirmExitDialog({super.key});

  @override
  Widget build(BuildContext context) {
    // Dialog boyutunu ekranın yaklaşık %60'ı olarak ayarla (Daha küçük bir onay penceresi).
    final double dialogWidth = MediaQuery.of(context).size.width * 0.7;

    return Center(
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          width: dialogWidth,
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: kTableNavy,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: kSuitGold, width: 3),
            boxShadow: [
              BoxShadow(
                color: kBlackColor.withOpacity(0.8),
                spreadRadius: 5,
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Başlık
              Text(
                "OYUNDAN ÇIKMAK İSTİYOR MUSUNUZ?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: kSuitRed,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  shadows: [
                    Shadow(color: kBlackColor.withOpacity(0.8), blurRadius: 5, offset: const Offset(1, 2)),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              const GoldNavContainer(),
              const SizedBox(height: 15),

              // Mesaj
              Text(
                "Oyundan gerçekten çıkmak istiyor musunuz? Ana menüye yönlendirileceksiniz. Tüm ilerlemeniz kaydedilecektir.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: kWhiteColor.withOpacity(0.9),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 30),

              // EVET, ÇIK Butonu (Kırmızı)
              PrimaryGameButton(
                buttonColor: kSuitRed,
                text: 'EVET, ÇIK',
                icon: Icons.exit_to_app,
                onTap: () {
                  context.read<LoginCubit>().closeApp();

                  // Diyalogu kapat, sonra ana menüye (veya çıkışa) yönlendir.
                  Navigator.of(context).pop();
                  print("Exit Confirmed.");
                },
              ),
              const SizedBox(height: 10),

              // İPTAL Butonu (Gri)
              PrimaryGameButton(
                buttonColor: kButtonGrey,
                text: 'İPTAL',
                icon: Icons.cancel_schedule_send_outlined,
                onTap: () {
                  Navigator.of(context).pop(); // Sadece diyaloğu kapat
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
