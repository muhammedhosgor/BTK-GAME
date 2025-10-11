// --------------------------------------------------------------------------
// MARK: - OYUNCU BEKLEME ODASI EKRANI

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_base_app/feature/auth/login/cubit/login_cubit.dart';
import 'package:flutter_base_app/feature/auth/login/cubit/login_state.dart';
import 'package:flutter_base_app/feature/auth/login/model/user_model.dart';
import 'package:flutter_base_app/product/components/container/gold_nav.dart';
import 'package:flutter_base_app/product/constant/color_constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Oyuncuların odaya katıldıktan sonra ikinci oyuncuyu beklediği ve
/// oyun başlayana kadar beklediği tematik ekran.
class WaitingRoomScreen extends StatefulWidget {
  const WaitingRoomScreen({super.key});

  @override
  State<WaitingRoomScreen> createState() => _WaitingRoomScreenState();
}

class _WaitingRoomScreenState extends State<WaitingRoomScreen> {
  int _countdown = 5;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Sayfa açıldığında Cubit'in oda durumunu dinlemesi zaten beklenir.
    // Geri sayım, sadece oda durumu 'HAZIR' olduğunda başlatılacak.
  }

  // Geri sayımı başlatır ve bittiğinde oyuna geçiş yapar
  void _startCountdown() {
    if (_timer != null) return; // Zaten çalışıyorsa tekrar başlatma

    setState(() {
      _countdown = 5;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown == 1) {
        timer.cancel();
        // Geri sayım bitti, oyuna geçiş yap!
        // Not: context.push("/gameStartView") router mekanizması olmadan çalışmayabilir.
        // Basitlik için pop ve Navigator.pushReplacement gibi yöntemler tercih edilebilir.
        // Ancak isteğe uygun olarak push kullanılmıştır:
        Navigator.of(context).pushNamed("/gameStartView");
      } else {
        setState(() {
          _countdown--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // Oyuncu durum kartını oluşturur
  Widget _buildPlayerStatus(
      {required String title, required String status, required Color color, required bool isReady}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kBlackColor.withOpacity(0.4),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color, width: 2),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(color: kSuitGold, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            status,
            style: TextStyle(color: color, fontSize: 24, fontWeight: FontWeight.w900),
          ),
          if (isReady)
            const Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Icon(Icons.check_circle, color: kAccentGreen, size: 30),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Merkezi kartın boyutlarını belirleyelim
    final double cardMaxWidth = 550;
    final double cardMaxHeight = 650;

    return Scaffold(
      backgroundColor: kTableNavy,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: cardMaxWidth,
              maxHeight: cardMaxHeight,
            ),
            padding: const EdgeInsets.all(30),
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: kTableNavy.withOpacity(0.98),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: kSuitGold, width: 4),
              boxShadow: [
                BoxShadow(
                  color: kBlackColor.withOpacity(0.8),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                ),
              ],
              // Tema Arkaplan Resmi (Placeholder)
              image: DecorationImage(
                image: const AssetImage('assets/asset/bg.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  kBlackColor.withOpacity(0.1),
                  BlendMode.dstATop,
                ),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Başlık
                const Text(
                  "OYUNCU BEKLEME ALANI",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: kSuitGold,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                  ),
                ),
                const GoldNavContainer(),
                const SizedBox(height: 30),

                // Oda Durumu Dinleyici
                BlocConsumer<LoginCubit, LoginState>(
                  // Sadece oda bilgisi değiştiğinde dinle
                  listenWhen: (prev, curr) => prev.gameStatus != curr.gameStatus,
                  listener: (context, state) {
                    // Oda durumu "Hazır" olduğunda geri sayımı başlat
                    if (state.gameStatus == 'Hazir') {
                      _startCountdown();
                    }
                  },
                  buildWhen: (prev, curr) => prev.gameStatus != curr.gameStatus,
                  builder: (context, state) {
                    // Oyuncu ID'leri (örnek olarak mevcut kullanıcı ve rakip ID'leri)
                    // Bu mantık Cubit'ten gelmelidir. Varsayılan değerler kullanılmıştır.
                    final String player1Id =
                        '${state.userList.firstWhere((u) => u.status == true, orElse: () => UserModel(id: 0, name: 'Bilinmiyor', status: '')).id}';
                    final String player2Id = 'hacı';

                    return Column(
                      children: [
                        Text(
                          "Oda Kodu: ${'sadxxx' ?? 'YOK'}",
                          style: const TextStyle(color: kWhiteColor, fontSize: 18),
                        ),
                        const SizedBox(height: 30),

                        // Oyuncu Durumları
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: _buildPlayerStatus(
                                title: "SEN (Host)",
                                status: "ID: $player1Id",
                                color: kSuitGold,
                                isReady: true, // Host her zaman hazır sayılabilir
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: _buildPlayerStatus(
                                title: "RAKİP",
                                status: player2Id == 'Bekleniyor...' ? 'Oyuncu Aranıyor' : 'Bağlandı',
                                color: player2Id == 'Bekleniyor...' ? kButtonGrey : kAccentGreen,
                                isReady: player2Id != 'Bekleniyor...',
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 40),

                        // Ana Durum Mesajı
                        Text(
                          state.gameStatus == 'Hazir' ? "OYUN BAŞLIYOR..." : "RAKİP BEKLENİYOR...",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: state.gameStatus == 'Hazir' ? kAccentGreen : kButtonGrey,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            shadows: const [
                              Shadow(color: kBlackColor, blurRadius: 4, offset: Offset(1, 1)),
                            ],
                          ),
                        ),

                        // Geri Sayım
                        if (state.gameStatus == 'Hazir')
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: Text(
                              _countdown.toString(),
                              style: const TextStyle(
                                color: kSuitGold,
                                fontSize: 64,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),

                        // Hata Mesajı (Gerektiğinde)
                        if (state.errorMessage != null && state.errorMessage!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: Text(
                              state.errorMessage!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: kSuitRed, fontSize: 16),
                            ),
                          ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 50),

                // Odadan Ayrıl Butonu
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    //context.read<LoginCubit>().leaveRoom();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kSuitRed,
                    foregroundColor: kWhiteColor,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(color: kSuitGold, width: 2),
                    ),
                    elevation: 8,
                    shadowColor: kSuitRed.withOpacity(0.5),
                  ),
                  child: const Text(
                    "ODADAN AYRIL",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
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
