// --------------------------------------------------------------------------
// MARK: - ANA EKRAN WIDGET'I
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_base_app/feature/auth/login/cubit/login_cubit.dart';
import 'package:flutter_base_app/feature/auth/login/cubit/login_state.dart';
import 'package:flutter_base_app/feature/auth/login/model/game_model.dart';
import 'package:flutter_base_app/product/constant/color_constants.dart';
import 'package:flutter_base_app/product/injector/injector.dart';
import 'package:flutter_base_app/product/storage/local_get_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class JoinRoomScreen extends StatefulWidget {
  const JoinRoomScreen({super.key});

  @override
  State<JoinRoomScreen> createState() => _JoinRoomScreenState();
}

class _JoinRoomScreenState extends State<JoinRoomScreen> {
  String? _joiningGuid;
  Timer? _statusTimer;
  bool _isDialogVisible = false;

  @override
  void initState() {
    super.initState();
    context.read<LoginCubit>().lobby();

    // _statusTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
    //   if (!mounted) return;
    //   final cubit = context.read<LoginCubit>();
    //   // try {
    //   //   await cubit.setGameStatus(1);
    //   // } catch (e) {
    //   //   print("Status kontrol hatası: $e");
    //   // }
    // });
  }

  @override
  void dispose() {
    _statusTimer?.cancel();
    super.dispose();
  }

  // 🔹 Revize Edilmiş Oda Listesi Öğesi
  Widget _buildRoomListItem({
    required GameModel room,
    required bool isJoinable,
    required bool isJoining,
    VoidCallback? onTap,
  }) {
    // Kişi Sayısı Kontrolü
    final isFull = (room.player2Id ?? 0) != 0;
    final playerCount = isFull ? '2/2' : '1/2';
    final statusColor = isJoinable ? kAccentGreen : (isFull ? kSuitRed : kSuitGold);

    // Tema Rengi Seçimi
    final backgroundColor = isJoinable ? kTableNavy.withOpacity(0.9) : kDarkGrey.withOpacity(0.8);
    final borderColor = isJoinable ? kSuitGold : Colors.white24;

    // Guid gösterimini basitleştirildi
    String safeGuid = room.guid ?? 'YOK';
    final guidDisplay = room.guid! + (safeGuid.length > 8 ? safeGuid.substring(0, 8) : safeGuid);

    return Card(
      elevation: isJoinable ? 12 : 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: borderColor, width: isJoinable ? 3 : 1),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: isJoinable ? [BoxShadow(color: kSuitGold.withOpacity(0.3), blurRadius: 10)] : null,
          ),
          child: Row(
            children: [
              // Kişi Sayısı & Durumu
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  border: Border.all(color: statusColor, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        playerCount,
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                          color: statusColor,
                        ),
                      ),
                      Text(
                        isJoinable ? "Bekliyor" : (isFull ? "Dolu" : "Hazır"),
                        style: TextStyle(
                          fontSize: 10,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Oda Bilgisi
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      guidDisplay.substring(0, 8),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: kWhiteColor,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      "Oyun Durumu: ${room.status ?? 'BİLİNMİYOR'}",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                    SizedBox(
                      height: 4.h,
                    ),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: kWhiteColor, width: 2),
                          ),
                          child: ClipOval(
                            child: Image.network(
                              'https://btkgameapi.linsabilisim.com/${room.player1Image}',
                              width: 30,
                              height: 30,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        Text(
                          "${'${room.player1Name} ${room.player1Surname}' ?? 'BİLİNMİYOR'}",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Durum Göstergesi/Buton
              isJoining
                  ? const CircularProgressIndicator(color: kSuitGold)
                  : isJoinable
                      ? Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: kButtonGreen, // Yeşil KATIL butonu
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(color: kButtonGreen.withOpacity(0.5), blurRadius: 5),
                            ],
                          ),
                          child: const Text(
                            "KATIL",
                            style: TextStyle(
                              color: kWhiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        )
                      : Icon(
                          isFull ? Icons.lock : Icons.check_circle_outline,
                          color: isFull ? kButtonRed : kButtonGrey, // Doluysa Kırmızı Kilit
                          size: 30,
                        ),
            ],
          ),
        ),
      ),
    );
  }

  // Odaları listeler
  Widget _buildRoomList({required List<GameModel> rooms}) {
    if (rooms.isEmpty) {
      return const Center(
        child: Text(
          "Şu anda aktif oda bulunmamaktadır.",
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
      );
    }
    return ListView.builder(
      itemCount: rooms.length,
      reverse: false, // scroll yukarıdan başlasın
      itemBuilder: (context, index) {
        // Ters sıra için index'i hesapla
        final reverseIndex = rooms.length - 1 - index;
        final room = rooms[reverseIndex];

        final isJoinable = room.status == "Bekliyor" && (room.player2Id ?? 0) == 0;
        final isJoining = _joiningGuid == room.guid;

        return _buildRoomListItem(
          room: room,
          isJoinable: isJoinable,
          isJoining: isJoining,
          onTap: isJoinable
              ? () async {
                  LocalStorage localStorage = injector.get<LocalStorage>();
                  localStorage.remove('createGameId');
                  String? userName = localStorage.getString('userName');
                  String? userSurname = localStorage.getString('userSurname');
                  String? image = localStorage.getString('image');
                  int joinGameId = room.id ?? 0;
                  localStorage.saveInt('joinGameId', joinGameId);
                  print("ODA GAME ID JOIN: $joinGameId");
                  setState(() => _joiningGuid = room.guid);

                  final success = await context
                      .read<LoginCubit>()
                      .joinRoom(room.id!, userName ?? '', userSurname ?? '', image ?? '');

                  _statusTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
                    if (!mounted) return;
                    final cubit = context.read<LoginCubit>();
                    try {
                      await cubit.setGameStatus(room.id!);
                    } catch (e) {
                      print("Status kontrol hatası: $e");
                    }
                  });

                  if (!mounted) return;
                  setState(() => _joiningGuid = null);
                  // if (success) context.push("/home_view", extra: false);
                }
              : null,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final rooms = context.watch<LoginCubit>().state.gameList ?? [];

    return Scaffold(
      backgroundColor: kTableNavy, // Arka planı koyu yap
      appBar: AppBar(
        title: const Text("Oda Lobisi", style: TextStyle(color: kWhiteColor, fontWeight: FontWeight.bold)),
        backgroundColor: kTableNavy,
        elevation: 0,
        iconTheme: const IconThemeData(color: kWhiteColor),
      ),
      body: BlocConsumer<LoginCubit, LoginState>(
        listenWhen: (previous, current) =>
            (previous.gameStatus != current.gameStatus && current.countDownJoinRoom == 5) ||
            previous.countDownJoinRoom != current.countDownJoinRoom,
        listener: (listenerContext, state) {
          switch (state.gameStatus) {
            case 'Hazir':
              print('HAZIRIM');
              // Mevcut dialog açık mı kontrolü eklendi
              if (!_isDialogVisible) {
                _isDialogVisible = true;
                context.read<LoginCubit>().setCountDownJoinRoom();
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (dialogContext) {
                    return BlocProvider.value(
                      value: context.read<LoginCubit>(),
                      child: Dialog(
                        insetPadding: EdgeInsets.zero, // 🔥 ekran kenar boşluklarını sıfırla
                        backgroundColor: Colors.transparent, // dış çerçeve transparan
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            color: kTableNavy.withOpacity(0.95),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color.fromARGB(255, 9, 24, 53), width: 3),
                          ),
                          child: Center(
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
                                      "${state.countDownJoinRoom}",
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
                      ),
                    );
                  },
                ).then((_) => _isDialogVisible = false);
              }

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
          if (state.countDownJoinRoom == 0) {
            context.read<LoginCubit>().cancelJoinRoomTimer();
            // Dialog'u kapat
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
            // JoinRoomScreen'i kapat (bu ekranın kendisini)
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
            context.push("/home_view", extra: false);
          }

          if (state.gameStatus == 'Hazir') {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Oyun Durumu: ${state.gameStatus ?? 'Durum Bilgisi Yok'}',
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: kSuitGold,
              ),
            );
          }
        },
        builder: (context, state) {
          return _buildRoomList(rooms: rooms);
        },
      ),
    );
  }
}
