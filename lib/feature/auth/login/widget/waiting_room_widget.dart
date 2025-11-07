// --------------------------------------------------------------------------
// MARK: - OYUNCU BEKLEME ODASI EKRANI

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_base_app/feature/auth/login/cubit/login_cubit.dart';
import 'package:flutter_base_app/feature/auth/login/cubit/login_state.dart';
import 'package:flutter_base_app/product/components/container/gold_nav.dart';
import 'package:flutter_base_app/product/constant/color_constants.dart';
import 'package:flutter_base_app/product/injector/injector.dart';
import 'package:flutter_base_app/product/storage/local_get_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class WaitingRoomScreen extends StatefulWidget {
  const WaitingRoomScreen({super.key});

  @override
  State<WaitingRoomScreen> createState() => _WaitingRoomScreenState();
}

class _WaitingRoomScreenState extends State<WaitingRoomScreen> {
  Timer? _statusTimer;
  int? createGameId = 0;
  var image = injector.get<LocalStorage>().getString('image') ?? '';

  @override
  void initState() {
    super.initState();

    // Her 1 saniyede bir oda durumunu kontrol et
    _statusTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (!mounted) return;
      final cubit = context.read<LoginCubit>();

      try {
        LocalStorage localStorage = injector.get<LocalStorage>();
        createGameId = await localStorage.getInt('createGameId');
        await cubit.setGameStatus(createGameId!);
        print("ODA GAME ID CREATE: $createGameId");
      } catch (e) {
        // ignore: avoid_print
        print("Status kontrol hatası: $e");
      }
    });
  }

  @override
  void dispose() {
    _statusTimer?.cancel();
    _statusTimer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double cardMaxWidth = 550;
    final double cardMaxHeight = 750;

    return Scaffold(
      backgroundColor: kTableNavy,
      body: BlocProvider.value(
        value: context.read<LoginCubit>(),
        child: Center(
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
                children: [
                  const Text(
                    "PLAYER WAITING AREA",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: kSuitGold,
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const GoldNavContainer(),
                  const SizedBox(height: 30),
                  BlocConsumer<LoginCubit, LoginState>(
                    listenWhen: (previous, current) =>
                        (previous.gameStatus != current.gameStatus && current.countDownWaitingRoom == 5) ||
                        previous.countDownWaitingRoom != current.countDownWaitingRoom,
                    listener: (listenerContext, state) {
                      switch (state.gameStatus) {
                        case 'Hazir':
                          print('HAZIRIM');
                          //  _showCountdownDialog();
                          context.read<LoginCubit>().setCountDownWaitingRoom();

                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (dialogContext) {
                              return BlocProvider.value(
                                value: context.read<LoginCubit>(),
                                child: Dialog(
                                  insetPadding: EdgeInsets.zero, // tam ekran
                                  backgroundColor: Colors.transparent,
                                  child: Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    decoration: BoxDecoration(
                                      color: kTableNavy.withOpacity(0.95),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: const Color.fromARGB(255, 9, 24, 53), width: 3),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Lottie.asset('assets/lottie/splash.json'),
                                        SizedBox(height: 20.h),
                                        const Text(
                                          "Oyun Başlıyor!",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: kSuitGold,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22,
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        BlocBuilder<LoginCubit, LoginState>(
                                          builder: (context, state) {
                                            return Text(
                                              "${state.countDownWaitingRoom}",
                                              style: const TextStyle(
                                                color: kAccentGreen,
                                                fontSize: 40,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            );
                                          },
                                        ),
                                        const SizedBox(height: 10),
                                        const Text(
                                          "Hazırlan, oyun birazdan başlıyor...",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: Colors.white70),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );

                          context.read<LoginCubit>().setGameStatusToStarted();
                          _statusTimer?.cancel(); // Geri sayım başladıktan sonra timer'ı iptal et

                          break;
                        case 'Bekliyor':
                          print('BEKLİYORUM');

                          break;
                        case 'Ayrildi':
                          print('AYRILDIM');
                          _statusTimer?.cancel(); // Geri sayım başladıktan sonra timer'ı iptal et
                          context.read<LoginCubit>().setGameStatusToStarted();

                          break;
                        default:
                      }
                      if (state.countDownWaitingRoom == 0) {
                        context.read<LoginCubit>().cancelWaitingRoomTimer();
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        context.push("/home_view", extra: true);
                      }

                      if (state.gameStatus == 'Hazir') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Oyun Durumu: ${state.gameStatus ?? 'Durum Bilgisi Yok'}',
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: kSuitGold,
                          ),
                        );
                      }
                    },
                    builder: (context, state) {
                      final bool bothReady = state.gameStatus == 'Hazir';
                      final String statusText = bothReady ? "OYUN BAŞLIYOR..." : "RAKİP BEKLENİYOR...";

                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            statusText,
                            style: const TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          const SizedBox(height: 20),
                          _buildPlayerStatus(
                            title: "SİZ",
                            status: bothReady ? "Hazır" : "Beklemede",
                            color: bothReady ? kAccentGreen : kSuitGold,
                            isReady: bothReady,
                            image: image,
                          ),
                          SizedBox(height: 24.h),
                          _buildPlayerStatus(
                              title: "RAKİP",
                              status: bothReady ? "Hazır" : "Bekliyor",
                              color: bothReady ? kAccentGreen : kSuitGold,
                              isReady: bothReady,
                              image: ''),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 50),
                  ElevatedButton(
                    onPressed: () {
                      // Odadan ayrılma işlemi (isteğe göre eklenebilir)
                      context.read<LoginCubit>().leaveRoom(createGameId!).whenComplete(() {
                        context.pop(2); // Diyalogdan çık
                        // Bekleme odasından çık
                      });
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
      ),
    );
  }
}

Widget _buildPlayerStatus({
  required String title,
  required String status,
  required Color color,
  required bool isReady,
  required String image,
}) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: kBlackColor.withOpacity(0.4),
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: color, width: 2),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        image.isEmpty
            ? CircleAvatar(
                radius: 30,
                backgroundColor: Colors.amber.shade100,
                child: Icon(
                  Icons.person,
                  color: Colors.black,
                  size: 40.sp,
                ))
            : ClipOval(
                child: Image.network(
                  'https://btkgameapi.linsabilisim.com/$image',
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
        Text(
          title,
          style: const TextStyle(
            color: kSuitGold,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          status,
          style: TextStyle(
            color: color,
            fontSize: 24,
            fontWeight: FontWeight.w900,
          ),
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
