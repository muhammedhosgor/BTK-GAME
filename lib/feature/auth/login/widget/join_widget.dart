// --------------------------------------------------------------------------
// MARK: - ANA EKRAN WIDGET'I
import 'package:flutter/material.dart';
import 'package:flutter_base_app/feature/auth/login/cubit/login_cubit.dart';
import 'package:flutter_base_app/feature/auth/login/cubit/login_state.dart';
import 'package:flutter_base_app/feature/auth/login/model/game_model.dart';
import 'package:flutter_base_app/product/components/container/gold_nav.dart';
import 'package:flutter_base_app/product/constant/color_constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Kullanıcının mevcut lobileri görüp "Bekliyor" durumundaki odaya katıldığı ekran.
class JoinRoomScreen extends StatefulWidget {
  const JoinRoomScreen({super.key});

  @override
  State<JoinRoomScreen> createState() => _JoinRoomScreenState();
}

class _JoinRoomScreenState extends State<JoinRoomScreen> {
  String? _joiningGuid; // Hangi odanın şu anda katılma işlemi yaptığını takip eder

  @override
  void initState() {
    super.initState();
    // Sayfa açıldığında lobi verilerini yükle
    context.read<LoginCubit>().lobby();
  }

  // Oda listesi öğesi oluşturucu
  Widget _buildRoomListItem({
    required GameModel room,
    required bool isJoinable,
    required bool isJoining,
    VoidCallback? onTap,
  }) {
    Color statusColor;
    // Status alanının null gelme ihtimaline karşı null check eklenmiştir.
    switch (room.status) {
      case "Bekliyor":
        statusColor = kAccentGreen;
        break;
      case "Oynanıyor":
        statusColor = kSuitGold;
        break;
      default:
        statusColor = kSuitRed;
    }

    // player1Id'nin null gelme ihtimali kontrol edilir (Host ID için)
    final String hostIdText =
        room.player1Id != null && room.player1Id != 0 ? "Host ID: ${room.player1Id}" : "Host ID: BİLİNMİYOR";

    return InkWell(
      onTap: onTap,
      // Tıklanabilir olmayan odaların rengini daha az belirgin yapmak için Container eklendi
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        decoration: BoxDecoration(
          color: isJoinable ? kBlackColor.withOpacity(0.4) : kBlackColor.withOpacity(0.2),
          border: Border(
            left: BorderSide(
              color: isJoinable ? kSuitGold : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Oda Bilgisi
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Oda Kodu: ${room.guid ?? 'YOK'}",
                  style: const TextStyle(
                    color: kWhiteColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  hostIdText,
                  style: TextStyle(
                    color: kWhiteColor.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
              ],
            ),

            // Durum ve Aksiyon
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      room.status?.toUpperCase() ?? 'BİLİNMİYOR',
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      room.player2Id == 0 ? "1/2 Kişi" : "2/2 Kişi",
                      style: TextStyle(
                        color: kSuitGold.withOpacity(0.8),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 15),
                // Buton veya Yüklenme Durumu
                isJoining
                    ? const SizedBox(
                        width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: kSuitGold))
                    : Icon(
                        isJoinable ? Icons.login_rounded : Icons.lock_rounded,
                        color: isJoinable ? kAccentGreen : kSuitRed, // Kilitli ikon için kSuitRed kullanıldı
                        size: 30,
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Merkezi kartın maksimum boyutunu tanımla.
    final double cardMaxWidth = 0.9.sw;
    final double cardMaxHeight = 0.95.sh;

    return Scaffold(
      backgroundColor: kTableNavy, // Ana arkaplan lacivert
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
              color: kTableNavy.withOpacity(0.95),
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
                  kWhiteColor.withOpacity(0.1),
                  BlendMode.dstATop,
                ),
              ),
            ),
            // İçerik boyutunu Card Max Height'e sabitlemek için SizedBox kullanıldı.
            // Bu, içindeki Column'un ve Expanded'ın düzgün çalışmasını sağlar.
            child: SizedBox(
              height: cardMaxHeight - 60, // Padding'ler düşüldü (30*2)
              child: Column(
                mainAxisSize: MainAxisSize.max, // Expanded'ın çalışması için max olmalı
                children: [
                  // Başlık
                  const Text(
                    "MEVCUT OYUN ODALARI",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: kSuitGold,
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                      shadows: [
                        Shadow(color: kBlackColor, blurRadius: 6, offset: Offset(1, 2)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  const GoldNavContainer(), // Tematik ayırıcı

                  const SizedBox(height: 20),

                  // Yenile Butonu (Lobi servisini tetikler)
                  InkWell(
                    onTap: () => context.read<LoginCubit>().lobby(),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: BlocBuilder<LoginCubit, LoginState>(
                        buildWhen: (prev, curr) => prev.lobbyState != curr.lobbyState,
                        builder: (context, state) {
                          final isFetching = state.lobbyState == LobbyStates.loading;
                          return Text(
                            isFetching ? "YÜKLENİYOR..." : "LİSTEYİ YENİLE",
                            style: TextStyle(
                              color: isFetching ? kSuitGold.withOpacity(0.5) : kSuitGold,
                              fontSize: 16,
                              decoration: TextDecoration.underline,
                              decorationColor: kSuitGold,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Oda Listesi
                  Expanded(
                    child: BlocBuilder<LoginCubit, LoginState>(
                      builder: (context, state) {
                        if (state.lobbyState == LobbyStates.loading &&
                            (state.gameList == null || state.gameList!.isEmpty)) {
                          // İlk yüklemede büyük center loading
                          return const Center(child: CircularProgressIndicator(color: kSuitGold));
                        } else if (state.lobbyState == LobbyStates.completed ||
                            state.lobbyState == LobbyStates.loading) {
                          // Yüklenirken de eski listeyi göstermeye devam et (tamamlanmış veya yükleniyor)
                          final rooms = state.gameList ?? [];

                          if (rooms.isEmpty) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 50.0),
                                child: Text(
                                  "Şu anda katılabilecek oda bulunmamaktadır.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: kSuitGold, fontSize: 18),
                                ),
                              ),
                            );
                          }

                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: kSuitGold.withOpacity(0.5), width: 1),
                              color: kBlackColor.withOpacity(0.2),
                            ),
                            child: ListView.separated(
                              itemCount: rooms.length,
                              separatorBuilder: (context, index) =>
                                  const GoldNavContainer(), // Tematik ayırıcı kullanıldı
                              itemBuilder: (context, index) {
                                final room = rooms[index];
                                // Hem status 'Bekliyor' olmalı hem de player2Id 0 olmalı (yani boş yer olmalı)
                                final isJoinable =
                                    room.status == "Bekliyor" && (room.player2Id == null || room.player2Id == 0);
                                final isJoining = _joiningGuid == room.guid;

                                return _buildRoomListItem(
                                  room: room,
                                  isJoinable: isJoinable,
                                  isJoining: isJoining,
                                  onTap: isJoinable && !isJoining
                                      ? () async {
                                          final success = await context.read<LoginCubit>().joinRoom(room.id!);

                                          if (success) {
                                            Navigator.of(context).pop(); // Başarılı katılım sonrası ekranı kapat
                                          } else {
                                            // Hata mesajı için tematik SnackBar
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  'Odaya katılırken bir hata oluştu.',
                                                  style: TextStyle(color: kWhiteColor, fontWeight: FontWeight.bold),
                                                ),
                                                backgroundColor: kSuitRed,
                                              ),
                                            );
                                          }
                                        }
                                      : null,
                                );
                              },
                            ),
                          );
                        } else if (state.lobbyState == LobbyStates.error) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 50.0),
                              child: Text(
                                state.errorMessage ?? 'Oda listesi yüklenirken beklenmedik bir hata oluştu.',
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: kSuitRed, fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Geri Dön Butonu
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Geri Dön",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: kSuitGold,
                          fontSize: 16,
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
        ),
      ),
    );
  }
}
