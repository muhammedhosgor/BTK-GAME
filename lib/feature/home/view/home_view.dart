import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter_base_app/feature/home/cubit/home_cubit.dart';
import 'package:flutter_base_app/feature/home/cubit/home_state.dart';
import 'package:flutter_base_app/feature/home/model/card_model.dart';
import 'package:flutter_base_app/product/constant/color_constants.dart';
import 'package:flutter_base_app/product/injector/injector.dart';
import 'package:flutter_base_app/product/storage/local_get_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CardGamePage extends StatefulWidget {
  final bool isPlayer1;
  const CardGamePage({super.key, required this.isPlayer1});

  @override
  State<CardGamePage> createState() => _CardGamePageState();
}

// TickerProviderStateMixin eklendi — overlay animasyonlar için gerekli
class _CardGamePageState extends State<CardGamePage> with TickerProviderStateMixin {
  bool selectionPhase = true;
  bool userTurnToSelect = true; // kullanıcı önce seçer
  List<bool> userSelected = List.filled(5, false);
  List<bool> oppSelected = List.filled(5, false);
  String log = '';
  //Todo: El sonucu gösterilecek
  //Todo: Diğer ele geçme işlemi yapılacak
  //Todo: Özel kartların uygulanma esnasında lottie çıkarılacak
  //Todo 3. el sonucunda  puanlar veri tabanına set edilecek

  // Yeni: maç/elde sayacı
  int userHandWins = 0;
  int oppHandWins = 0;

  // Hazır mekanizması
  bool userReady = false;
  bool botReady = false;

  // Yeni: El sonu/başlangıcı overlay kontrolü
  bool showHandResultOverlay = false;
  String handResultText = '';
  bool showReadyOverlay = false;

  // Yeni: Özel kart işaretleme için
  int? swappedUserIndex;
  int? swappedOppIndex;

  // YENİ: Altın sarısı info mesajı için
  String _currentInfoMessage = '';

  // Card keys for animation overlay
  late List<GlobalKey> userCardKeys;
  late List<GlobalKey> oppCardKeys;

  // Log scroll controller
  final ScrollController _logController = ScrollController();
  Timer? timer;

  LocalStorage localStorage = injector.get<LocalStorage>();

  int? gameId;
  @override
  void initState() {
    gameId = localStorage.getInt('createGameId') ?? localStorage.getInt('joinGameId');

    super.initState();
    context.read<HomeCubit>().setStateToLoading();

    timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (!mounted) return; // ✅ widget hâlâ ekrandaysa devam et
      context.read<HomeCubit>().getInitialStatusGame();
    });
    // initialize keys
    userCardKeys = List.generate(5, (_) => GlobalKey());
    oppCardKeys = List.generate(5, (_) => GlobalKey());
  }

  @override
  void dispose() {
    timer?.cancel(); // ✅ ekran kapanınca iptal et
    super.dispose();
  }

  // Yardımcı: given index, uygun GlobalKey döndürür
  GlobalKey? userCardKeyForIndex(int idx) {
    if (idx < 0 || idx >= userCardKeys.length) return null;
    return userCardKeys[idx];
  }

  GlobalKey? oppCardKeyForIndex(int idx) {
    if (idx < 0 || idx >= oppCardKeys.length) return null;
    return oppCardKeys[idx];
  }

  void _appendLog(String s) {
    if (!mounted) return;
    setState(() {
      final time = DateTime.now().toIso8601String().split('T').last.substring(0, 8);
      log = '$time - $s\n$log';
    });
  }

  // Yeni: El başlangıcı hazır olma overlay'i
  Widget _buildReadyOverlay() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(opacity: animation, child: ScaleTransition(scale: animation, child: child));
      },
      child: showReadyOverlay
          ? Container(
              color: Colors.black.withOpacity(0.6),
              alignment: Alignment.center,
              child: BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  if (state.getStatusState == GetStatusStates.completed) {
                    return Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey.shade700,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.lightBlueAccent, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.8),
                            blurRadius: 15,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${state.game.currentTurnId! + 1}. Its starting...',
                            style: TextStyle(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          BlocBuilder<HomeCubit, HomeState>(
                            builder: (context, state) {
                              return Text(
                                widget.isPlayer1
                                    ? state.game.isPlayer2Ready!
                                        ? 'Opponent ready. Waiting...'
                                        : 'Opponent is expected...'
                                    : state.game.isPlayer1Ready!
                                        ? 'Opponent ready. Waiting...'
                                        : 'Opponent is expected...',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: state.game.isPlayer1Ready! ? Colors.greenAccent : Colors.amberAccent,
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          BlocConsumer<HomeCubit, HomeState>(
                            listenWhen: (prev, curr) =>
                                prev.game.isPlayer1Ready != curr.game.isPlayer1Ready ||
                                prev.game.isPlayer2Ready != curr.game.isPlayer2Ready,
                            listener: (context, state) {
                              if (state.game.isPlayer1Ready! && state.game.isPlayer2Ready!) {
                                // timer!.cancel();
                                setState(() {
                                  showReadyOverlay = false;
                                });
                                _appendLog('Both players are ready. The game begins!');
                                print('İKİ OYUNCU DA HAZIR, EL BAŞLIYOR...');
                              } else if (widget.isPlayer1 && state.game.isPlayer2Ready!) {
                                // Kullanıcı 1 ve rakip hazırsa
                                _appendLog('Your opponent is ready. If you are ready, the hand will begin.');
                                print('PLAYER 1 siniz RAKİP HAZIR, KULLANICI BEKLENİYOR...');
                              } else if (!widget.isPlayer1 && state.game.isPlayer1Ready!) {
                                // Kullanıcı 2 ve rakip hazırsa
                                _appendLog('Your opponent is ready. If you are ready, the hand will begin.');
                                print('PLAYER 2 siniz RAKİP HAZIR, KULLANICI BEKLENİYOR...');
                              }
                            },
                            builder: (context, state) {
                              return ElevatedButton(
                                onPressed: () {
                                  if (widget.isPlayer1) {
                                    context.read<HomeCubit>().setPlayerReady(gameId!, true); //! ***
                                  } else {
                                    context.read<HomeCubit>().setPlayerReady(gameId!, false); //! ***
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: userReady ? Colors.grey : Colors.lightBlueAccent,
                                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                                child: Text(
                                  widget.isPlayer1
                                      ? state.game.isPlayer1Ready!
                                          ? 'READY'
                                          : 'I AM READY'
                                      : state.game.isPlayer2Ready!
                                          ? 'READY'
                                          : 'I AM READY',
                                  style: TextStyle(
                                      fontSize: 18.sp,
                                      color: state.game.isPlayer2Ready! ? Colors.white70 : Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
            )
          : const SizedBox.shrink(),
    );
  }

  Widget buildTimeChip(int seconds, bool isSpecialEffectPlaying) {
    final bool isActive = seconds != 10;

    return Chip(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isActive ? const Color(0xFFFFD700) : Colors.grey.shade700,
          width: 1.5,
        ),
      ),
      avatar: Icon(
        Icons.timer,
        color: isActive ? Colors.amberAccent : Colors.grey.shade300,
        size: 20,
      ),
      backgroundColor: isActive
          ? const Color(0xFF3B2F0A) // Altınla kontrast koyu arka plan
          : Colors.grey.shade700,
      label: Text(
        isSpecialEffectPlaying ? 'Time: $seconds' : 'Ready',
        style: TextStyle(
          color: isActive ? Colors.amberAccent : Colors.white70,
          fontWeight: FontWeight.bold,
          fontSize: 14,
          shadows: [
            Shadow(
              blurRadius: 4,
              color: Colors.black.withOpacity(0.4),
              offset: const Offset(1, 1),
            ),
          ],
        ),
      ),
      elevation: 6,
      shadowColor: Colors.black54,
    )
        .animate(
          onPlay: (controller) => controller.repeat(reverse: true),
        )
        .scale(
          begin: const Offset(1.0, 1.0),
          end: isActive ? const Offset(1.05, 1.05) : const Offset(1.0, 1.0),
          curve: Curves.easeInOut,
          duration: 600.ms,
        );
  }

  // YENİ: Info Mesajı Overlay'i
  Widget _buildInfoMessageOverlay() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(opacity: animation, child: ScaleTransition(scale: animation, child: child));
      },
      child: _currentInfoMessage.isNotEmpty
          ? Positioned(
              top: MediaQuery.of(context).size.height * 0.4, // Ekranın ortasına yakın
              left: 0,
              right: 0,
              key: ValueKey(_currentInfoMessage), // Mesaj değiştiğinde animasyon tetiklenir
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.amberAccent, width: 2), // Altın Sarısı çerçeve
                    boxShadow: [
                      BoxShadow(
                        color: Colors.amber.withOpacity(0.5),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Text(
                    _currentInfoMessage,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.amberAccent, // Altın Sarısı Metin
                    ),
                  ),
                ),
              ),
            )
          : const SizedBox.shrink(key: ValueKey('empty')),
    );
  }

  List<String> swappingCards = [];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Geri tuşuna basıldığında timer'ı iptal et
        timer?.cancel();
        return true; // Pop işlemini devam ettir
      },
      child: Scaffold(
        backgroundColor: kTableGreen,
        body: Stack(
          alignment: Alignment.center,
          children: [
            // Arkaplan ve Oyun Alanı
            Container(
              width: 1.sw,
              height: 1.sh,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/asset/bg.jpg'),
                  fit: BoxFit.cover,
                  opacity: 0.9,
                ),
              ),
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/asset/table.png'),
                    fit: BoxFit.contain,
                  ),
                ),
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(height: 10.h),

                      // Hazır durumu göstergesi (eski, artık sadece bilgi amaçlı)
                      Container(
                        width: 0.9.sw,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            BlocBuilder<HomeCubit, HomeState>(
                              builder: (context, state) {
                                return Row(
                                  children: [
                                    BackButton(
                                      onPressed: () {
                                        timer?.cancel();
                                        context.pop();
                                        //! Navigator.of(context).pop();
                                      },
                                      color: Colors.white,
                                    ),
                                    Text('Round ${state.game.currentTurnId! + 1} / ${3}',
                                        style: TextStyle(color: Colors.white, fontSize: 14.sp)),
                                  ],
                                );
                              },
                            ),
                            Row(
                              children: [
                                // todo: timer ekleyecen yer burası
                                BlocBuilder<HomeCubit, HomeState>(
                                  builder: (context, state) {
                                    return buildTimeChip(state.seconds, state.isSpecialEffectPlaying);
                                  },
                                ),
                                const SizedBox(width: 8),
                                // Buradaki 'Hazırım' butonu artık _buildReadyOverlay'e taşındı.
                                // Sadece seçim aşamasında değilken ve hazır değilken görünüyor.
                                if (!selectionPhase && !userReady)
                                  ElevatedButton(
                                    onPressed: null, // Pasif bırak
                                    child: Text(userReady ? 'Ready' : 'Waiting...'),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 18.h),
                      BlocBuilder<HomeCubit, HomeState>(
                        builder: (context, state) {
                          if (state.getStatusState == GetStatusStates.completed) {
                            // Her iki oyuncu da hamle yaptıysa, el sonucu göster
                            return InfoProfile(
                              image: widget.isPlayer1
                                  ? state.game.player2Image! // P1 ise rakip P2
                                  : state.game.player1Image!, // P2 ise rakip P1
                              isPlayer1: widget.isPlayer1,
                              content: widget.isPlayer1
                                  ? 'Round ${state.game.currentTurnId! + 1} / ${3}  • Score: Opponent ${state.player2WinCount} - You ${state.player1WinCount}'
                                  : 'Round ${state.game.currentTurnId! + 1} / ${3}  • Score: Opponent ${state.player1WinCount} - You ${state.player2WinCount}',
                              point: // 0

                                  (state.game.isPlayer1Move! && state.game.isPlayer2Move!) || state.game.turn!
                                      ? (state.opponentCards
                                              .where((oc) => oc.fullName != state.game.disabledCards)
                                              .toList()
                                              .map((c) => c.value)
                                              .toList()
                                              .reduce((a, b) => a + b) *
                                          (widget.isPlayer1 ? state.player2Multiplier : state.player1Multiplier))
                                      : null,
                              userWins: widget.isPlayer1
                                  ? state.player2WinCount // Cihaz P1 ise, userWins P2 skorudur (Rakip).
                                  : state.player1WinCount, // Cihaz P2 ise, userWins P1 skorudur (Rakip).
                              oppWins: widget.isPlayer1
                                  ? state.player1WinCount // Cihaz P1 ise, oppWins P1 skorudur (Kullanıcı).
                                  : state.player2WinCount, // Cihaz P2 ise, oppWins P2 skorudur (Kullanıcı).
                              name: widget.isPlayer1
                                  ? '${state.game.player2Name!} ${state.game.player2Surname!} ${state.player2Multiplier > 1 ? '(x${state.player2Multiplier})' : ''}'
                                  : '${state.game.player1Name!} ${state.game.player1Surname!} ${state.player1Multiplier > 1 ? '(x${state.player1Multiplier})' : ''}',
                            );
                          } else {
                            return const SizedBox();
                          }
                        },
                      ),
                      const Spacer(),

                      // _buildHandRow(opponent, isTop: true),

                      BlocBuilder<HomeCubit, HomeState>(
                        builder: (context, state) {
                          if (state.getStatusState == GetStatusStates.loading) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (state.getStatusState == GetStatusStates.error) {
                            return Text('Hata: ${state.errorMessage}', style: const TextStyle(color: Colors.red));
                          } else if (state.getStatusState == GetStatusStates.completed) {
                            // 🔄 Kart Gösterimi
                            if ((state.game.isPlayer1Move! && state.game.isPlayer2Move!) || state.game.turn!) {
                              return Column(
                                children: [
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 800),
                                    curve: Curves.easeInOut,
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: state.karoVar || (state.sinekVar && swappingCards.isNotEmpty)
                                            ? Colors.yellowAccent
                                            : Colors.transparent,
                                        width: (state.karoVar || (state.sinekVar && swappingCards.isNotEmpty)) ? 4 : 0,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: (state.karoVar || (state.sinekVar && swappingCards.isNotEmpty))
                                          ? [
                                              BoxShadow(
                                                color: Colors.yellow.withOpacity(0.7),
                                                blurRadius: 20,
                                                spreadRadius: 2,
                                              )
                                            ]
                                          : [],
                                    ),
                                    child: SizedBox(
                                      height: 110,
                                      width: 1.sw,
                                      child: ListView.builder(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: (1.sw -
                                                  (state.opponentCards.length * 70 +
                                                      (state.opponentCards.length - 1) * 10)) /
                                              2,
                                        ),
                                        itemCount: state.opponentCards.length,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          final card = state.opponentCards[index];

                                          // Kart çerçeve rengi belirleme
                                          Color baseBorderColor = card.isSpecial
                                              ? (state.game.swappedCards!.isNotEmpty && card.fullName == 'Sinek-2')
                                                  ? const Color.fromARGB(255, 30, 149, 34)
                                                  : const Color.fromARGB(255, 255, 0, 157)
                                              : (state.karoVar || (state.sinekVar && swappingCards.isNotEmpty))
                                                  ? const Color.fromARGB(255, 255, 203, 15)
                                                  : const Color.fromRGBO(0, 0, 0, 0.867);

                                          double baseBorderWidth = card.isSpecial
                                              ? 3
                                              : (state.karoVar || (state.sinekVar && swappingCards.isNotEmpty))
                                                  ? 3
                                                  : 2;

                                          Color cardSymbolColor = (card.symbol == '♥' || card.symbol == '♦')
                                              ? Colors.red.shade800
                                              : Colors.black;

                                          return Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 5.w),
                                            child: AnimatedSwitcher(
                                              duration: const Duration(milliseconds: 400),
                                              transitionBuilder: (child, anim) =>
                                                  ScaleTransition(scale: anim, child: child),
                                              child: GestureDetector(
                                                onTap: () {
                                                  // 🎯 Kart etkileşimleri
                                                  if (state.karoVar) {
                                                    // 🟥 Karo: Rakibin kartını devre dışı bırak
                                                    context.read<HomeCubit>().disableCards(gameId!, card.fullName);
                                                    context.read<HomeCubit>().setKaroVar(false);
                                                  } else if (state.sinekVar && swappingCards.isNotEmpty) {
                                                    // ♣ Sinek: Takas işlemi

                                                    if (state.game.disabledCards != 'Sinek-2') {
                                                      swappingCards.add(card.fullName);

                                                      context
                                                          .read<HomeCubit>()
                                                          .sinekle(gameId!, swappingCards.join(','));
                                                      context.read<HomeCubit>().setSinekVar(false);
                                                      swappingCards.clear();
                                                    } else {
                                                      //! snakbar
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        const SnackBar(
                                                          content: Text(
                                                              "Your special card power is passive, you cannot use this card in this hand.\nAt the end of the period, you will be redirected to a new hand."),
                                                        ),
                                                      );
                                                    }
                                                  }
                                                },
                                                child: TweenAnimationBuilder<Color?>(
                                                  tween: ColorTween(
                                                    begin: card.isSpecial ? baseBorderColor : Colors.black26,
                                                    end: card.isSpecial ? baseBorderColor : Colors.black26,
                                                  ),
                                                  duration: const Duration(milliseconds: 700),
                                                  curve: Curves.easeInOut,
                                                  builder: (context, color, child) {
                                                    return AnimatedContainer(
                                                      duration: const Duration(milliseconds: 600),
                                                      curve: Curves.easeInOut,
                                                      margin: EdgeInsets.only(
                                                        top: swappingCards.contains(card.fullName) ? 0 : 8,
                                                      ),
                                                      transform: Matrix4.translationValues(
                                                          0, swappingCards.contains(card.fullName) ? -14 : 0, 0),
                                                      decoration: BoxDecoration(
                                                        color: state.game.disabledCards! == card.fullName
                                                            ? Colors.white.withAlpha(160)
                                                            : Colors.white,
                                                        borderRadius: BorderRadius.circular(8),
                                                        border:
                                                            Border.all(color: baseBorderColor, width: baseBorderWidth),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            blurRadius: card.isSpecial ? 20 : 4,
                                                            color: baseBorderColor.withOpacity(0.6),
                                                            offset: const Offset(1, 2),
                                                          ),
                                                        ],
                                                      ),
                                                      width: 60,
                                                      height: 92,
                                                      child: Stack(
                                                        clipBehavior: Clip.none,
                                                        children: [
                                                          // 🂡 Sol üst köşe
                                                          Positioned(
                                                            top: 4,
                                                            left: 4,
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: [
                                                                Text(
                                                                  card.rank,
                                                                  style: TextStyle(
                                                                    fontSize: 20,
                                                                    fontWeight: FontWeight.w900,
                                                                    color: cardSymbolColor,
                                                                    height: 0.9,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  card.symbol,
                                                                  style: TextStyle(
                                                                    fontSize: 20,
                                                                    fontWeight: FontWeight.bold,
                                                                    color: cardSymbolColor,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),

                                                          // 🂡 Sağ alt köşe (180° dönük)
                                                          Positioned(
                                                            bottom: 4,
                                                            right: 4,
                                                            child: Transform.rotate(
                                                              angle: math.pi,
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: [
                                                                  Text(
                                                                    card.rank,
                                                                    style: TextStyle(
                                                                      fontSize: 20,
                                                                      fontWeight: FontWeight.w900,
                                                                      color: cardSymbolColor,
                                                                      height: 0.9,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    card.symbol,
                                                                    style: TextStyle(
                                                                      fontSize: 20,
                                                                      fontWeight: FontWeight.bold,
                                                                      color: cardSymbolColor,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),

                                                          // 🔁 Takas edilmiş kart göstergesi
                                                          if (state.game.swappedCards!
                                                              .split(',')
                                                              .contains(card.fullName))
                                                            Positioned(
                                                              top: -8,
                                                              right: -8,
                                                              child: Container(
                                                                padding: const EdgeInsets.all(2),
                                                                decoration: const BoxDecoration(
                                                                  color: Color.fromARGB(255, 83, 105, 192),
                                                                  shape: BoxShape.circle,
                                                                ),
                                                                child: const Icon(Icons.swap_horiz,
                                                                    size: 24, color: Colors.white),
                                                              ),
                                                            ),

                                                          // 🚫 Engellenmiş kart overlay
                                                          if (state.game.disabledCards! == card.fullName)
                                                            Positioned.fill(
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                  color: Colors.black38,
                                                                  borderRadius: BorderRadius.circular(8),
                                                                ),
                                                                child: Center(
                                                                  child: Icon(
                                                                    Icons.block,
                                                                    size: 40,
                                                                    color: Colors.white.withOpacity(0.8),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),

                                                          // ✅ Sinek-2 takas edildi göstergesi
                                                          if (state.game.swappedCards!.isNotEmpty &&
                                                              card.fullName == 'Sinek-2')
                                                            Positioned(
                                                              top: -20,
                                                              left: 18,
                                                              child: Container(
                                                                padding: const EdgeInsets.all(2),
                                                                decoration: const BoxDecoration(
                                                                  color: Color.fromARGB(255, 0, 141, 21),
                                                                  shape: BoxShape.circle,
                                                                ),
                                                                child: const Icon(Icons.check,
                                                                    size: 18, color: Colors.white),
                                                              ),
                                                            ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              // 🔒 Rakip kartlar kapalı (tur bitmemişse)
                              return Container(
                                width: 55,
                                height: 85,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: const DecorationImage(
                                    image: AssetImage('assets/asset/lock.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            }
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      ),

                      Container(
                        width: 100.w,
                        height: 150.h,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: Image.asset('assets/asset/deck.png').image,
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Container(
                            margin: const EdgeInsets.all(4),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.amberAccent.withOpacity(0.95),
                                  Colors.orangeAccent.withOpacity(0.85),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.8),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.amber.withOpacity(0.5),
                                  blurRadius: 8,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: BlocBuilder<HomeCubit, HomeState>(
                              builder: (context, state) {
                                if (state.getStatusState != GetStatusStates.completed) {
                                  return const SizedBox();
                                } else {
                                  final int playedCount = state.game.playedCards!.split(',').length;
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.2),
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white.withOpacity(0.5),
                                            width: 1,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.style_rounded,
                                          size: 22,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        '$playedCount',
                                        style: TextStyle(
                                          color: kTableNavy,
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.5,
                                          shadows: [
                                            Shadow(
                                              blurRadius: 6,
                                              color: Colors.white.withOpacity(0.9),
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      ),

                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            BlocListener<HomeCubit, HomeState>(
                              listenWhen: (previous, current) =>
                                  previous.game.turn != current.game.turn ||
                                  previous.game.isPlayer1Move != current.game.isPlayer1Move ||
                                  previous.game.isPlayer2Move != current.game.isPlayer2Move,
                              listener: (contextl, state) async {
                                print('listener -- player : ${widget.isPlayer1}');

                                if (state.game.currentTurnId! > 2) {
                                  //* VERİ TABANINDA SAYAC 0 DAN BAŞLADIĞI İÇİN 2
                                  // showDialog(
                                  //   barrierDismissible: false,
                                  //   context: context,
                                  //   builder: (dialogContext) {
                                  //     return AlertDialog(
                                  //       backgroundColor: Colors.black87,
                                  //       title: const Text(
                                  //         'El tamamlandı',
                                  //         style: TextStyle(color: Colors.white),
                                  //       ),
                                  //       content: Text(
                                  //         'Kazanan oyuncu ${state.player1WinCount > state.player2WinCount ? 'Kazanan 1. Oyuncu' : 'Kazanan 2. Oyuncu'} ',
                                  //         style: const TextStyle(color: Colors.white70),
                                  //       ),
                                  //       actions: [
                                  //         TextButton(
                                  //           onPressed: () async {
                                  //             Navigator.of(dialogContext).pop(); //! Eli kazananı belirleme
                                  //             // Todo: Buraya yönlendiriliyorsunuz yazan bir animasyon ekleyip login sayfasına gönder.

                                  //             // context.pushReplacement('/login_view');
                                  //             print("win: ${state.player1WinCount}}");
                                  //             print("win 2 : ${state.player2WinCount}}");

                                  //             context
                                  //                 .read<HomeCubit>()
                                  //                 .finish(
                                  //                   state.game.id!,
                                  //                   widget.isPlayer1,
                                  //                   widget.isPlayer1 ? state.game.player1Id! : state.game.player2Id!,
                                  //                   widget.isPlayer1 ? state.player1Score : state.player2Score,
                                  //                 )
                                  //                 .whenComplete(() {
                                  //               context.pushReplacement('/login_view');
                                  //             });
                                  //           },
                                  //           child: const Text(
                                  //             'Tamam',
                                  //             style: TextStyle(color: Colors.amberAccent),
                                  //           ),
                                  //         )
                                  //       ],
                                  //     );
                                  //   },
                                  // );

                                  showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (dialogContext) {
                                      final bool player1Won = state.player1WinCount > state.player2WinCount;

                                      // 🔹 Bu cihaz 1. oyuncu mu?
                                      final bool isPlayer1 = widget.isPlayer1;

                                      // 🔹 Bu cihaza göre kazandı mı kaybetti mi?
                                      final bool thisPlayerWon =
                                          (isPlayer1 && player1Won) || (!isPlayer1 && !player1Won);
                                      final String resultText = thisPlayerWon ? 'You won!' : 'You lost!';

                                      // 🔹 Animasyon seçimi
                                      final String lottiePath = thisPlayerWon
                                          ? 'assets/file/win.png' // 🏆 Kazanan animasyonu
                                          : 'assets/file/defeat.png'; // 😔 Kaybeden animasyonu

                                      // 🔹 Metin seçimi
                                      final String winnerText = player1Won ? 'Winner 1. Player' : 'Winner 2. Player';

                                      return Scaffold(
                                        backgroundColor: kTableNavy,
                                        body: Center(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              // 🟢 Lottie animasyonu
                                              Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: thisPlayerWon
                                                          ? Colors.greenAccent.withOpacity(0.27)
                                                          : Colors.redAccent.withOpacity(0.27),
                                                      width: 2),
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                child: Image.asset(
                                                  lottiePath,
                                                  height: 250,
                                                  width: 250,
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                              const SizedBox(height: 20),
                                              // 🏁 Başlık
                                              const Text(
                                                'The round is complete.',
                                                style: TextStyle(
                                                    color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                                              ),
                                              const SizedBox(height: 10),
                                              // 🧩 Oyuncu sonucu
                                              Text(
                                                resultText,
                                                style: TextStyle(
                                                  color: thisPlayerWon ? Colors.greenAccent : Colors.redAccent,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              // 🏆 Kazanan oyuncu bilgisi
                                              Text(
                                                'Winning player: $winnerText',
                                                style: const TextStyle(color: Colors.white70, fontSize: 18),
                                              ),
                                              const SizedBox(height: 40),
                                              // 🔘 Buton
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.amberAccent,
                                                  foregroundColor: Colors.black,
                                                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                                                  shape:
                                                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                                ),
                                                onPressed: () async {
                                                  Navigator.of(dialogContext).pop();

                                                  print("win: ${state.player1WinCount}");
                                                  print("win 2 : ${state.player2WinCount}");

                                                  await context
                                                      .read<HomeCubit>()
                                                      .finish(
                                                        state.game.id!,
                                                        widget.isPlayer1,
                                                        widget.isPlayer1
                                                            ? state.game.player1Id!
                                                            : state.game.player2Id!,
                                                        widget.isPlayer1 ? state.player1Score : state.player2Score,
                                                      )
                                                      .whenComplete(() {
                                                    context.pushReplacement('/login_view');
                                                  });
                                                },
                                                child: const Text(
                                                  'OK',
                                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                } else {
                                  //! Oyunun devam ettiği kısım
                                  if (state.game.isPlayer1Move! && state.game.isPlayer2Move! && state.game.turn!) {
                                    await Future.delayed(
                                      const Duration(seconds: 1),
                                    );
                                    await showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (dialogContext) {
                                        int youScore = (state.cards
                                                .where((card) => card.fullName != state.game.disabledCards)
                                                .toList()
                                                .map((c) => c.value)
                                                .toList()
                                                .reduce((a, b) => a + b)) *
                                            (widget.isPlayer1 ? state.player1Multiplier : state.player2Multiplier);
                                        int opponentScore = (state.opponentCards
                                                .where((oc) => oc.fullName != state.game.disabledCards)
                                                .toList()
                                                .map((c) => c.value)
                                                .toList()
                                                .reduce((a, b) => a + b) *
                                            (widget.isPlayer1 ? state.player2Multiplier : state.player1Multiplier));

                                        // 🔹 Kazanan / Kaybeden kontrolü
                                        bool thisPlayerWon = youScore > opponentScore;
                                        bool draw = youScore == opponentScore;

                                        String resultText;
                                        String winnerText;

                                        if (draw) {
                                          resultText = "It's a Draw!";
                                          winnerText = "No winner this round";
                                        } else if (thisPlayerWon) {
                                          resultText = "You Win!";
                                          winnerText = widget.isPlayer1 ? "Player 1" : "Player 2";
                                        } else {
                                          resultText = "You Lost!";
                                          winnerText = widget.isPlayer1 ? "Player 2" : "Player 1";
                                        }

                                        return Scaffold(
                                          backgroundColor: kTableNavy,
                                          body: Center(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "${state.game.currentTurnId! + 1}. Round Over! ",
                                                  style: TextStyle(
                                                      fontSize: 24.sp,
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                                Text(
                                                  "Opponent Card (Score: ${opponentScore})",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 18.sp),
                                                ),
                                                SizedBox(
                                                  height: 130,
                                                  child: ListView.separated(
                                                    // padding: EdgeInsets.symmetric(
                                                    //   horizontal: (1.sw -
                                                    //           (state.opponentCards.length * 70 +
                                                    //               (state.opponentCards.length - 1) * 10)) /
                                                    //       2,
                                                    // ),
                                                    shrinkWrap: true,
                                                    scrollDirection: Axis.horizontal,
                                                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                                                    itemCount: state.opponentCards.length,
                                                    itemBuilder: (context, index) {
                                                      final card = state.opponentCards[index];

                                                      // Kart çerçeve rengi belirleme
                                                      Color baseBorderColor = card.isSpecial
                                                          ? (state.game.swappedCards!.isNotEmpty &&
                                                                  card.fullName == 'Sinek-2')
                                                              ? const Color.fromARGB(255, 30, 149, 34)
                                                              : const Color.fromARGB(255, 255, 0, 157)
                                                          : (state.karoVar ||
                                                                  (state.sinekVar && swappingCards.isNotEmpty))
                                                              ? const Color.fromARGB(255, 255, 203, 15)
                                                              : const Color.fromRGBO(0, 0, 0, 0.867);

                                                      double baseBorderWidth = card.isSpecial
                                                          ? 3
                                                          : (state.karoVar ||
                                                                  (state.sinekVar && swappingCards.isNotEmpty))
                                                              ? 3
                                                              : 2;

                                                      Color cardSymbolColor = (card.symbol == '♥' || card.symbol == '♦')
                                                          ? Colors.red.shade800
                                                          : Colors.black;

                                                      return Padding(
                                                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                                                        child: AnimatedSwitcher(
                                                          duration: const Duration(milliseconds: 400),
                                                          transitionBuilder: (child, anim) =>
                                                              ScaleTransition(scale: anim, child: child),
                                                          child: GestureDetector(
                                                            onTap: () {
                                                              // 🎯 Kart etkileşimleri
                                                              if (state.karoVar) {
                                                                // 🟥 Karo: Rakibin kartını devre dışı bırak
                                                                context
                                                                    .read<HomeCubit>()
                                                                    .disableCards(gameId!, card.fullName);
                                                                context.read<HomeCubit>().setKaroVar(false);
                                                              } else if (state.sinekVar && swappingCards.isNotEmpty) {
                                                                // ♣ Sinek: Takas işlemi
                                                                swappingCards.add(card.fullName);
                                                                context
                                                                    .read<HomeCubit>()
                                                                    .sinekle(gameId!, swappingCards.join(','));
                                                                context.read<HomeCubit>().setSinekVar(false);
                                                                swappingCards.clear();
                                                              }
                                                            },
                                                            child: TweenAnimationBuilder<Color?>(
                                                              tween: ColorTween(
                                                                begin:
                                                                    card.isSpecial ? baseBorderColor : Colors.black26,
                                                                end: card.isSpecial ? baseBorderColor : Colors.black26,
                                                              ),
                                                              duration: const Duration(milliseconds: 700),
                                                              curve: Curves.easeInOut,
                                                              builder: (context, color, child) {
                                                                return AnimatedContainer(
                                                                  duration: const Duration(milliseconds: 600),
                                                                  curve: Curves.easeInOut,
                                                                  margin: EdgeInsets.only(
                                                                    top: swappingCards.contains(card.fullName) ? 0 : 8,
                                                                  ),
                                                                  transform: Matrix4.translationValues(
                                                                      0,
                                                                      swappingCards.contains(card.fullName) ? -14 : 0,
                                                                      0),
                                                                  decoration: BoxDecoration(
                                                                    color: state.game.disabledCards! == card.fullName
                                                                        ? Colors.white.withAlpha(160)
                                                                        : Colors.white,
                                                                    borderRadius: BorderRadius.circular(8),
                                                                    border: Border.all(
                                                                        color: baseBorderColor, width: baseBorderWidth),
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                        blurRadius: card.isSpecial ? 20 : 4,
                                                                        color: baseBorderColor.withOpacity(0.6),
                                                                        offset: const Offset(1, 2),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  width: 60,
                                                                  height: 92,
                                                                  child: Stack(
                                                                    clipBehavior: Clip.none,
                                                                    children: [
                                                                      // 🂡 Sol üst köşe
                                                                      Positioned(
                                                                        top: 4,
                                                                        left: 4,
                                                                        child: Column(
                                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                                          children: [
                                                                            Text(
                                                                              card.rank,
                                                                              style: TextStyle(
                                                                                fontSize: 20,
                                                                                fontWeight: FontWeight.w900,
                                                                                color: cardSymbolColor,
                                                                                height: 0.9,
                                                                              ),
                                                                            ),
                                                                            Text(
                                                                              card.symbol,
                                                                              style: TextStyle(
                                                                                fontSize: 20,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: cardSymbolColor,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),

                                                                      // 🂡 Sağ alt köşe (180° dönük)
                                                                      Positioned(
                                                                        bottom: 4,
                                                                        right: 4,
                                                                        child: Transform.rotate(
                                                                          angle: math.pi,
                                                                          child: Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.center,
                                                                            children: [
                                                                              Text(
                                                                                card.rank,
                                                                                style: TextStyle(
                                                                                  fontSize: 20,
                                                                                  fontWeight: FontWeight.w900,
                                                                                  color: cardSymbolColor,
                                                                                  height: 0.9,
                                                                                ),
                                                                              ),
                                                                              Text(
                                                                                card.symbol,
                                                                                style: TextStyle(
                                                                                  fontSize: 20,
                                                                                  fontWeight: FontWeight.bold,
                                                                                  color: cardSymbolColor,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),

                                                                      // 🔁 Takas edilmiş kart göstergesi
                                                                      if (state.game.swappedCards!
                                                                          .split(',')
                                                                          .contains(card.fullName))
                                                                        Positioned(
                                                                          top: -8,
                                                                          right: -8,
                                                                          child: Container(
                                                                            padding: const EdgeInsets.all(2),
                                                                            decoration: const BoxDecoration(
                                                                              color: Color.fromARGB(255, 83, 105, 192),
                                                                              shape: BoxShape.circle,
                                                                            ),
                                                                            child: const Icon(Icons.swap_horiz,
                                                                                size: 24, color: Colors.white),
                                                                          ),
                                                                        ),

                                                                      // 🚫 Engellenmiş kart overlay
                                                                      if (state.game.disabledCards! == card.fullName)
                                                                        Positioned.fill(
                                                                          child: Container(
                                                                            decoration: BoxDecoration(
                                                                              color: Colors.black38,
                                                                              borderRadius: BorderRadius.circular(8),
                                                                            ),
                                                                            child: Center(
                                                                              child: Icon(
                                                                                Icons.block,
                                                                                size: 40,
                                                                                color: Colors.white.withOpacity(0.8),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),

                                                                      // ✅ Sinek-2 takas edildi göstergesi
                                                                      if (state.game.swappedCards!.isNotEmpty &&
                                                                          card.fullName == 'Sinek-2')
                                                                        Positioned(
                                                                          top: -20,
                                                                          left: 18,
                                                                          child: Container(
                                                                            padding: const EdgeInsets.all(2),
                                                                            decoration: const BoxDecoration(
                                                                              color: Color.fromARGB(255, 0, 141, 21),
                                                                              shape: BoxShape.circle,
                                                                            ),
                                                                            child: const Icon(Icons.check,
                                                                                size: 18, color: Colors.white),
                                                                          ),
                                                                        ),
                                                                    ],
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10.h,
                                                ),
                                                Image.asset('assets/file/info.png',
                                                    height: 200, width: 200, fit: BoxFit.contain),
                                                SizedBox(
                                                  height: 10.h,
                                                ),
                                                Text(
                                                  resultText,
                                                  style: TextStyle(
                                                    color: draw
                                                        ? Colors.amberAccent
                                                        : thisPlayerWon
                                                            ? Colors.greenAccent
                                                            : Colors.redAccent,
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(height: 5.h),

                                                // 🥇 Kazanan Oyuncu Bilgisi
                                                Text(
                                                  draw ? '' : 'Winning player: $winnerText',
                                                  style: const TextStyle(
                                                    color: Colors.white70,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                const SizedBox(height: 20),
                                                // 🔹 İçerik metni
                                                Text(
                                                  'The cards were revealed and the points were calculated.',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Colors.white70,
                                                    fontSize: 18.sp,
                                                    height: 1.4,
                                                  ),
                                                ),
                                                const SizedBox(height: 40),
                                                Text(
                                                  "Your Card (Score: ${(state.cards.where((card) => card.fullName != state.game.disabledCards).toList().map((c) => c.value).toList().reduce((a, b) => a + b)) * (widget.isPlayer1 ? state.player1Multiplier : state.player2Multiplier)})",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 18.sp),
                                                ),
                                                SizedBox(
                                                  height: 130, // 🔹 Kart alanını biraz genişlettik
                                                  child: ListView.separated(
                                                    // padding: EdgeInsets.symmetric(
                                                    //   horizontal: (1.sw -
                                                    //           (state.cards.length * 70 +
                                                    //               (state.cards.length - 1) * 10)) /
                                                    //       2,
                                                    // ),
                                                    shrinkWrap: true,
                                                    scrollDirection: Axis.horizontal,
                                                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                                                    itemCount: state.cards.length,
                                                    itemBuilder: (context, index) {
                                                      // 🔹 Kart renkleri
                                                      Color baseBorderColor = state.cards[index].isSpecial
                                                          ? state.game.swappedCards!.isNotEmpty &&
                                                                  state.cards[index].fullName == 'Sinek-2'
                                                              ? const Color.fromARGB(255, 30, 149, 34)
                                                              : const Color.fromARGB(255, 255, 0, 157)
                                                          : const Color.fromRGBO(0, 0, 0, 0.867);
                                                      double baseBorderWidth = state.cards[index].isSpecial ? 3 : 1.6;

                                                      // 🔹 Symbol rengi
                                                      Color cardSymbolColor = (state.cards[index].symbol == '♥' ||
                                                              state.cards[index].symbol == '♦')
                                                          ? Colors.red.shade800
                                                          : Colors.black;

                                                      bool isSwappedCard = state.game.swappedCards!
                                                          .split(',')
                                                          .contains(state.cards[index].fullName);

                                                      bool isSelectedToSwap =
                                                          swappingCards.contains(state.cards[index].fullName) ||
                                                              state.selectedCardsToSwap
                                                                  .map((c) => c.fullName)
                                                                  .toList()
                                                                  .contains(state.cards[index].fullName);

                                                      return Padding(
                                                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                                                        child: AnimatedSwitcher(
                                                          duration: const Duration(milliseconds: 400),
                                                          transitionBuilder: (child, anim) =>
                                                              ScaleTransition(scale: anim, child: child),
                                                          child: GestureDetector(
                                                            onTap: () {
                                                              // 🔹 Kart seçimi / takası
                                                              // if (state.sinekVar) {
                                                              //   if (swappingCards.isNotEmpty) {
                                                              //     swappingCards.remove(state.cards[index].fullName);
                                                              //     swappingCards.add(state.cards[index].fullName);
                                                              //   } else {
                                                              //     swappingCards.add(state.cards[index].fullName);
                                                              //   }

                                                              // 🔹 Kart seçimi / takası
                                                              if (state.sinekVar) {
                                                                // Sinek-2 (Takas) özel kartı aktifse
                                                                // setState kullanmalıyız ki kartın görseli (isSelectedToSwap) güncellensin
                                                                setState(() {
                                                                  if (swappingCards
                                                                      .contains(state.cards[index].fullName)) {
                                                                    // Eğer aynı karta tekrar tıklarsa: Seçimi kaldır (swappingCards boşalır)
                                                                    swappingCards.clear();
                                                                  } else {
                                                                    // Yeni bir kart seçerse:
                                                                    swappingCards
                                                                        .clear(); // Önceki seçimi temizle (1 kart kuralı garanti edilir)
                                                                    swappingCards.add(
                                                                        state.cards[index].fullName); // Yeni kartı ekle
                                                                  }
                                                                });
                                                              } else {
                                                                if ((state.game.isPlayer1Move! &&
                                                                        state.game.isPlayer2Move!) ||
                                                                    state.game.turn!) {
                                                                  print('KART SEÇİMİ ENGELLENDİ');
                                                                } else {
                                                                  print('KART SEÇİMİ YAPILDI:  ${state.game.turn!}');
                                                                  if (widget.isPlayer1) {
                                                                    if (!state.game.isPlayer1Move!) {
                                                                      context.read<HomeCubit>().selectCard(CardModel(
                                                                          symbol: state.cards[index].symbol,
                                                                          rank: state.cards[index].rank,
                                                                          value: state.cards[index].value,
                                                                          fullName: (state.cards[index].fullName)));
                                                                    }
                                                                  } else {
                                                                    if (!state.game.isPlayer2Move! &&
                                                                        state.game.isPlayer1Move!) {
                                                                      context.read<HomeCubit>().selectCard(CardModel(
                                                                          symbol: state.cards[index].symbol,
                                                                          rank: state.cards[index].rank,
                                                                          value: state.cards[index].value,
                                                                          fullName: (state.cards[index].fullName)));
                                                                    }
                                                                  }
                                                                }
                                                              }
                                                            },
                                                            child: AnimatedContainer(
                                                              duration: const Duration(milliseconds: 600),
                                                              curve: Curves.easeInOutCubic,
                                                              margin: EdgeInsets.only(top: isSelectedToSwap ? 0 : 10),
                                                              transform: Matrix4.identity()
                                                                ..translate(0.0, isSelectedToSwap ? -18.0 : 0.0)
                                                                ..scale(isSelectedToSwap ? 1.08 : 1.0),
                                                              decoration: BoxDecoration(
                                                                color: state.game.disabledCards! ==
                                                                        state.cards[index].fullName
                                                                    ? Colors.white.withAlpha(160)
                                                                    : Colors.white,
                                                                borderRadius: BorderRadius.circular(12),
                                                                border: Border.all(
                                                                    color: baseBorderColor, width: baseBorderWidth),
                                                                boxShadow: [
                                                                  if (isSwappedCard || isSelectedToSwap)
                                                                    BoxShadow(
                                                                      color: baseBorderColor.withOpacity(0.9),
                                                                      blurRadius: 25,
                                                                      spreadRadius: 3,
                                                                    ),
                                                                  BoxShadow(
                                                                    color: Colors.black.withOpacity(0.25),
                                                                    blurRadius: 6,
                                                                    offset: const Offset(2, 3),
                                                                  ),
                                                                ],
                                                              ),
                                                              width: 60,
                                                              height: 95,
                                                              child: Stack(
                                                                clipBehavior: Clip.none,
                                                                children: [
                                                                  // --- Kartın Görsel Yapısı ---
                                                                  Positioned(
                                                                    top: 4,
                                                                    left: 4,
                                                                    child: Column(
                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                      children: [
                                                                        Text(
                                                                          state.cards[index].rank,
                                                                          style: TextStyle(
                                                                            fontSize: 20,
                                                                            fontWeight: FontWeight.w900,
                                                                            color: cardSymbolColor,
                                                                            height: 0.9,
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          state.cards[index].symbol,
                                                                          style: TextStyle(
                                                                            fontSize: 20,
                                                                            fontWeight: FontWeight.bold,
                                                                            color: cardSymbolColor,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),

                                                                  Positioned(
                                                                    bottom: 4,
                                                                    right: 4,
                                                                    child: Transform.rotate(
                                                                      angle: math.pi,
                                                                      child: Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                                        children: [
                                                                          Text(
                                                                            state.cards[index].rank,
                                                                            style: TextStyle(
                                                                              fontSize: 20,
                                                                              fontWeight: FontWeight.w900,
                                                                              color: cardSymbolColor,
                                                                              height: 0.9,
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            state.cards[index].symbol,
                                                                            style: TextStyle(
                                                                              fontSize: 20,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: cardSymbolColor,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),

                                                                  // --- Swap / Durum İndikatörleri ---
                                                                  if (isSwappedCard)
                                                                    Positioned(
                                                                      top: -10,
                                                                      right: -10,
                                                                      child: AnimatedOpacity(
                                                                        opacity: 1,
                                                                        duration: const Duration(milliseconds: 400),
                                                                        child: Container(
                                                                          padding: const EdgeInsets.all(3),
                                                                          decoration: const BoxDecoration(
                                                                            color: Color.fromARGB(255, 83, 105, 192),
                                                                            shape: BoxShape.circle,
                                                                            boxShadow: [
                                                                              BoxShadow(
                                                                                blurRadius: 10,
                                                                                color:
                                                                                    Color.fromARGB(255, 83, 105, 192),
                                                                                spreadRadius: 2,
                                                                              )
                                                                            ],
                                                                          ),
                                                                          child: const Icon(Icons.swap_horiz,
                                                                              size: 22, color: Colors.white),
                                                                        ),
                                                                      ),
                                                                    ),

                                                                  if (state.game.disabledCards! ==
                                                                      state.cards[index].fullName)
                                                                    Positioned.fill(
                                                                      child: Container(
                                                                        decoration: BoxDecoration(
                                                                          color: Colors.black38,
                                                                          borderRadius: BorderRadius.circular(8),
                                                                        ),
                                                                        child: Center(
                                                                          child: Icon(
                                                                            Icons.block,
                                                                            size: 40,
                                                                            color: Colors.white.withOpacity(0.8),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),

                                                                  if (state.game.swappedCards!.isNotEmpty &&
                                                                      state.cards[index].fullName == 'Sinek-2')
                                                                    Positioned(
                                                                      top: -22,
                                                                      left: 18,
                                                                      child: Container(
                                                                        padding: const EdgeInsets.all(2),
                                                                        decoration: const BoxDecoration(
                                                                          color: Color.fromARGB(255, 0, 141, 21),
                                                                          shape: BoxShape.circle,
                                                                          boxShadow: [
                                                                            BoxShadow(
                                                                                blurRadius: 8,
                                                                                color: Color.fromARGB(255, 0, 141, 21),
                                                                                spreadRadius: 1)
                                                                          ],
                                                                        ),
                                                                        child: const Icon(Icons.check,
                                                                            size: 18, color: Colors.white),
                                                                      ),
                                                                    ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 20.h,
                                                ),
                                                // 🔹 Tamam Butonu
                                                ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.amberAccent,
                                                    foregroundColor: Colors.black,
                                                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(30),
                                                    ),
                                                  ),
                                                  onPressed: () async {
                                                    Navigator.of(dialogContext).pop();
                                                    context.read<HomeCubit>().setIsMoveFirstTime(true);

                                                    if (!widget.isPlayer1) {
                                                      await context.read<HomeCubit>().handComplete(state.game.id!);
                                                    }

                                                    context.read<HomeCubit>().determineWinner(widget.isPlayer1);
                                                    //! Resetleme işlemleri burada yapılacak Yeni El başlangıcı
                                                    context.read<HomeCubit>().resetHandComplete();
                                                  },
                                                  child: const Text(
                                                    'NEXT ROUND',
                                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }

                                  if (!state.game.isPlayer1Move! && !state.game.isPlayer2Move! && state.game.turn!) {
                                    if (widget.isPlayer1) {
                                      if (state.isMoveFirstTime) {
                                        context.read<HomeCubit>().setIsMoveFirstTime(false);
                                        print('listener MOVE ---- player 1');

                                        for (var element in (state.cards)) {
                                          if (element.isSpecial) {
                                            switch (element.fullName) {
                                              case 'Kupa-K':
                                                if (state.game.disabledCards != 'Kupa-K' ||
                                                    state.game.swappedCards != 'Kupa-K') {
                                                  context.read<HomeCubit>().setPlayerMultipliers(2, 1);
                                                  _appendLog(
                                                      'The Cup of the Priest (K♥) card has been placed on the table! The card value will be 2x.');
                                                } else {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(
                                                      content: Text("player1 için 2x engelleme"),
                                                    ),
                                                  );
                                                }

                                                break;
                                              case 'Karo-2':
                                                context.read<HomeCubit>().setKaroVar(true);
                                                context.read<HomeCubit>().startTimer();
                                                await Future.delayed(const Duration(seconds: 10));
                                                context.read<HomeCubit>().stopTimer();

                                                _appendLog(
                                                    'The 2 of Diamonds (♦2) card has been placed on the table! One card will be rendered ineffective.');

                                                break;

                                              case 'Sinek-2':
                                                context.read<HomeCubit>().setSinekVar(true);
                                                context.read<HomeCubit>().startTimer();

                                                await Future.delayed(const Duration(seconds: 10));
                                                context.read<HomeCubit>().stopTimer();

                                                _appendLog(
                                                    'The 2 of Clubs (♣2) card has been placed on the table! One card will be exchanged.');

                                                break;

                                              default:
                                            }
                                          }
                                        }
                                        context
                                            .read<HomeCubit>()
                                            .swapCards(state.game.id!, state.game.player1Id!, true, '');
                                      }
                                    } else {
                                      for (var element in (state.opponentCards)) {
                                        if (element.isSpecial) {
                                          switch (element.fullName) {
                                            case 'Kupa-K':
                                              if (state.game.disabledCards != 'Kupa-K' ||
                                                  state.game.swappedCards != 'Kupa-K') {
                                                context.read<HomeCubit>().setPlayerMultipliers(
                                                    widget.isPlayer1 ? 1 : 2, widget.isPlayer1 ? 2 : 1);
                                                _appendLog(
                                                    'The Cup of the Priest (K♥) card has been placed on the table by your opponent! The card value will be 2x.');
                                              } else {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(
                                                    content: Text("player2 için 2x engelleme"),
                                                  ),
                                                );
                                              }

                                              break;
                                            case 'Karo-2':
                                              context.read<HomeCubit>().startTimer();
                                              await Future.delayed(const Duration(seconds: 10));
                                              context.read<HomeCubit>().stopTimer();

                                              _appendLog(
                                                  'The 2 of Diamonds (♦2) card has been placed on the table! One card will become ineffective.');

                                              break;
                                            case 'Sinek-2':
                                              context.read<HomeCubit>().startTimer();
                                              await Future.delayed(const Duration(seconds: 10));
                                              context.read<HomeCubit>().stopTimer();

                                              _appendLog(
                                                  'The 2 of Clubs (♣2) card has been placed on the table! One card will be exchanged.');

                                              break;

                                            default:
                                          }
                                        }
                                      }
                                    }
                                  } else if (state.game.isPlayer1Move! &&
                                      !state.game.isPlayer2Move! &&
                                      state.game.turn!) {
                                    if (!widget.isPlayer1) {
                                      if (state.isMoveFirstTime) {
                                        context.read<HomeCubit>().setIsMoveFirstTime(false);
                                        print('listener MOVE ---- player 2');
                                        for (var element in (state.cards)) {
                                          if (element.isSpecial) {
                                            switch (element.fullName) {
                                              case 'Kupa-K':
                                                context.read<HomeCubit>().setPlayerMultipliers(1, 2);

                                                _appendLog(
                                                    'The Cup of the Priest (K♥) card has been placed on the table! The card value will be 2x.');
                                                break;
                                              case 'Karo-2':
                                                context.read<HomeCubit>().setKaroVar(true);
                                                context.read<HomeCubit>().startTimer();

                                                await Future.delayed(Duration(seconds: state.seconds));
                                                context.read<HomeCubit>().stopTimer();
                                                print('SÜRE SONU GELDİ');

                                                _appendLog(
                                                    'The 2 of Diamonds (♦2) card has been placed on the table! One card will become ineffective.');
                                                break;
                                              case 'Sinek-2':
                                                context.read<HomeCubit>().setSinekVar(true);
                                                context.read<HomeCubit>().startTimer();

                                                await Future.delayed(Duration(seconds: state.seconds));
                                                context.read<HomeCubit>().stopTimer();
                                                print('SÜRE SONU GELDİ');

                                                _appendLog(
                                                    'The 2 of Clubs (♣2) card has been placed on the table! One card will be exchanged.');
                                                break;

                                              default:
                                            }
                                          }
                                        }
                                        context
                                            .read<HomeCubit>()
                                            .swapCards(state.game.id!, state.game.player2Id!, true, '');
                                        // context
                                        //     .read<HomeCubit>()
                                        //     .resetIsActiveKupaPapazDialogShown(); // DİALOG SAYACINI SIFIRLA
                                      }
                                    } else {
                                      for (var element in (state.opponentCards)) {
                                        if (element.isSpecial) {
                                          switch (element.fullName) {
                                            case 'Kupa-K':
                                              context.read<HomeCubit>().setPlayerMultipliers(
                                                  widget.isPlayer1 ? 1 : 2, widget.isPlayer1 ? 2 : 1);
                                              _appendLog(
                                                  'The Cup of the Priest (K♥) card has been placed on the table by your opponent! The card value will be 2x.');

                                              break;
                                            case 'Karo-2':
                                              context.read<HomeCubit>().startTimer();
                                              await Future.delayed(Duration(seconds: state.seconds));
                                              context.read<HomeCubit>().stopTimer();

                                              _appendLog(
                                                  'The 2 of Diamonds (♦2) card has been placed on the table! One card will be rendered ineffective.');

                                              break;
                                            case 'Sinek-2':
                                              context.read<HomeCubit>().startTimer();
                                              await Future.delayed(Duration(seconds: state.seconds));
                                              context.read<HomeCubit>().stopTimer();

                                              _appendLog(
                                                  'The 2 of Clubs (♣2) card has been placed on the table! One card will be exchanged.');

                                              break;

                                            default:
                                          }
                                        }
                                      }
                                    }
                                  }
                                }
                              },
                              child: SizedBox(height: 15.h),
                            ),
                            Text('Card exchange: You can select up to 3 cards.',
                                style: TextStyle(color: kWhiteColor, fontSize: 16.sp)),
                            const SizedBox(height: 6),
                            // REVİZE EDİLMİŞ BUTON TASARIMI
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  // Butona hafif bir parlaklık ve derinlik katmak için gölge
                                  BoxShadow(
                                    color: Colors.amberAccent.withOpacity(0.4),
                                    blurRadius: 10,
                                    spreadRadius: 1,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: BlocConsumer<HomeCubit, HomeState>(
                                listenWhen: (previous, current) =>
                                    previous.game.isPlayer1Move != current.game.isPlayer1Move ||
                                    previous.game.isPlayer2Move != current.game.isPlayer2Move ||
                                    previous.game.turn != current.game.turn,
                                listener: (contextt, state) async {
                                  if (state.game.turn! && !state.isDialogShownValue) {
                                    context.read<HomeCubit>().setIsDialogShownValue(true);
                                    for (var element in (state.cards.map((c) => c.fullName).toList())) {
                                      switch (element) {
                                        case 'Kupa-K':
                                          context.read<HomeCubit>().setIsKupaPapazDialogShown(true);
                                          break;
                                        case 'Karo-2':
                                          context.read<HomeCubit>().setIsKaroDialogShown(true);
                                          await Future.delayed(Duration(seconds: state.seconds));

                                          break;
                                        case 'Sinek-2':
                                          context.read<HomeCubit>().setIsSinekDialogShown(true);
                                          await Future.delayed(Duration(seconds: state.seconds));

                                          break;

                                        default:
                                      }
                                    }
                                  }
                                  if (state.game.turn! && !state.isDialog2ShownValue) {
                                    context.read<HomeCubit>().setIsDialog2ShownValue(true);
                                    for (var element in (state.opponentCards.map((c) => c.fullName).toList())) {
                                      switch (element) {
                                        case 'Kupa-K':
                                          context.read<HomeCubit>().setIsKupaPapaz2DialogShown(true);
                                          break;
                                        case 'Karo-2':
                                          context.read<HomeCubit>().setIsKaro2DialogShown(true);
                                          await Future.delayed(Duration(seconds: state.seconds));

                                          break;
                                        case 'Sinek-2':
                                          context.read<HomeCubit>().setIsSinek2DialogShown(true);
                                          await Future.delayed(Duration(seconds: state.seconds));

                                          break;

                                        default:
                                      }
                                    }
                                  }
                                },
                                builder: (context, state) {
                                  if (state.getStatusState == GetStatusStates.completed) {
                                    return ElevatedButton(
                                      onPressed: () {
                                        int? userId = injector.get<LocalStorage>().getInt('userId');
                                        if (!state.game.turn! &&
                                            !(widget.isPlayer1
                                                ? state.game.isPlayer1Move!
                                                : state.game.isPlayer2Move!)) {
                                          context.read<HomeCubit>().swapCards(
                                              gameId!, //! ***
                                              userId!,
                                              true,
                                              state.selectedCardsToSwap.map((c) => c.fullName).toList().join(','));
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: kTableNavy,
                                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(16),
                                          side: const BorderSide(color: Colors.amberAccent, width: 3),
                                        ),
                                        elevation: 0,
                                      ).copyWith(
                                        overlayColor: WidgetStateProperty.all(
                                            Colors.amber.withOpacity(0.15)), // Dokununca altın parlaması
                                        shadowColor: WidgetStateProperty.all(Colors.amber.withOpacity(0.6)),
                                      ),
                                      child: AnimatedContainer(
                                        duration: const Duration(milliseconds: 500),
                                        curve: Curves.easeInOut,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.amberAccent.withOpacity(0.2),
                                              Colors.transparent,
                                              Colors.amberAccent.withOpacity(0.2),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          boxShadow: [
                                            // BoxShadow(
                                            //   color: Colors.amber.withOpacity(0.3),
                                            //   blurRadius: 10,
                                            //   spreadRadius: 1,
                                            //   offset: const Offset(0, 3),
                                            // ),
                                          ],
                                        ),
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              (state.game.isPlayer1Move! && state.game.isPlayer2Move!) ||
                                                      state.game.turn!
                                                  ? Icons.visibility
                                                  : Icons.autorenew_rounded,
                                              color: Colors.amberAccent,
                                              size: 22,
                                            ),
                                            const SizedBox(width: 10),
                                            Flexible(
                                              child: Text(
                                                (state.game.isPlayer1Move! && state.game.isPlayer2Move!) ||
                                                        state.game.turn!
                                                    ? 'CHANGE COMPLETED • CARDS OPENED'
                                                    : widget.isPlayer1
                                                        ? !state.game.isPlayer1Move!
                                                            ? 'CHANGE / SKIP SELECTED CARDS'
                                                            : 'Selecting opponent...'
                                                        : !state.game.isPlayer2Move!
                                                            ? 'CHANGE / SKIP SELECTED CARDS'
                                                            : 'Selecting opponent...',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 0.6,
                                                  shadows: [
                                                    Shadow(
                                                      blurRadius: 6.0,
                                                      color: Colors.amber.withOpacity(0.9),
                                                      offset: const Offset(1, 1),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );

                                    // ElevatedButton(
                                    //   onPressed: () {
                                    //     int? userId = injector.get<LocalStorage>().getInt('userId');
                                    //     if (!state.game.turn! &&
                                    //         !(widget.isPlayer1
                                    //             ? state.game.isPlayer1Move!
                                    //             : state.game.isPlayer2Move!)) {
                                    //       context.read<HomeCubit>().swapCards(
                                    //           gameId!, //! ***
                                    //           userId!,
                                    //           true,
                                    //           state.selectedCardsToSwap.map((c) => c.fullName).toList().join(','));
                                    //     }
                                    //   },
                                    //   style: ElevatedButton.styleFrom(
                                    //     // Arkaplan: Koyu Masa Teması
                                    //     backgroundColor: kTableNavy,
                                    //     // Kenarlık: Altın Sarısı Accent
                                    //     side: const BorderSide(color: Colors.amberAccent, width: 3),
                                    //     // Köşe yuvarlaklığı
                                    //     shape: RoundedRectangleBorder(
                                    //       borderRadius: BorderRadius.circular(12),
                                    //     ),
                                    //     padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                                    //     elevation: 0, // Kendi gölgemizi kullandığımız için default elevation'ı sıfırla
                                    //   ),
                                    //   child: Text(
                                    //     (state.game.isPlayer1Move! && state.game.isPlayer2Move!) || state.game.turn!
                                    //         ? 'Değiştirme işlemleri yapıldı. KARTLAR AÇILDI!'
                                    //         : widget.isPlayer1
                                    //             ? !state.game.isPlayer1Move!
                                    //                 ? 'SEÇİLİ KARTLARI DEĞİŞTİR / ATLA'
                                    //                 : 'Karşı oyuncu seçiyor...'
                                    //             : !state.game.isPlayer2Move!
                                    //                 ? 'SEÇİLİ KARTLARI DEĞİŞTİR / ATLA'
                                    //                 : 'Karşı oyuncu seçiyor...',
                                    //     style: TextStyle(
                                    //       color: Colors.white,
                                    //       fontSize: 17.sp,
                                    //       fontWeight: FontWeight.bold,
                                    //       shadows: [
                                    //         // Yazıya hafif parlaklık
                                    //         Shadow(
                                    //           blurRadius: 4.0,
                                    //           color: Colors.yellow.withOpacity(0.7),
                                    //           offset: const Offset(0.5, 0.5),
                                    //         ),
                                    //       ],
                                    //     ),
                                    //     textAlign: TextAlign.center,
                                    //   ),
                                    // );
                                  } else {
                                    return const SizedBox();
                                  }
                                },
                              ),
                            ),
                          ]),
                      SizedBox(height: 12.h),
                      // _buildHandRow(user, isTop: false),
                      BlocBuilder<HomeCubit, HomeState>(
                        builder: (context, state) {
                          if (state.getStatusState == GetStatusStates.loading) {
                            return const CircularProgressIndicator();
                          } else if (state.getStatusState == GetStatusStates.error) {
                            return Text('Error: ${state.errorMessage}', style: const TextStyle(color: Colors.red));
                          } else if (state.getStatusState == GetStatusStates.completed) {
                            // Kartları gösterme animasyonu
                            return Column(
                              children: [
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 800),
                                  curve: Curves.easeInOut,
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: widget.isPlayer1
                                          ? (!state.game.isPlayer1Move! && !state.game.turn!) || state.sinekVar
                                              ? Colors.yellowAccent
                                              : Colors.transparent
                                          : (!state.game.isPlayer2Move! &&
                                                      state.game.isPlayer1Move! &&
                                                      !state.game.turn!) ||
                                                  state.sinekVar
                                              ? Colors.yellowAccent
                                              : Colors.transparent,
                                      width: widget.isPlayer1
                                          ? (!state.game.isPlayer1Move! && !state.game.turn!) || state.sinekVar
                                              ? 4
                                              : 0
                                          : (!state.game.isPlayer2Move! &&
                                                      state.game.isPlayer1Move! &&
                                                      !state.game.turn!) ||
                                                  state.sinekVar
                                              ? 4
                                              : 0,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: widget.isPlayer1
                                        ? (!state.game.isPlayer1Move! && !state.game.turn!) || state.sinekVar
                                            ? [
                                                BoxShadow(
                                                    color: Colors.yellow.withOpacity(0.7),
                                                    blurRadius: 20,
                                                    spreadRadius: 2)
                                              ]
                                            : []
                                        : (!state.game.isPlayer2Move! &&
                                                    state.game.isPlayer1Move! &&
                                                    !state.game.turn!) ||
                                                state.sinekVar
                                            ? [
                                                BoxShadow(
                                                    color: Colors.yellow.withOpacity(0.7),
                                                    blurRadius: 20,
                                                    spreadRadius: 2)
                                              ]
                                            : [],
                                  ),
                                  child: SizedBox(
                                    height: 130, // 🔹 Kart alanını biraz genişlettik
                                    width: 1.sw,
                                    child: ListView.builder(
                                      padding: EdgeInsets.symmetric(
                                        horizontal:
                                            (1.sw - (state.cards.length * 70 + (state.cards.length - 1) * 10)) / 2,
                                      ),
                                      itemCount: state.cards.length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        // 🔹 Kart renkleri
                                        Color baseBorderColor = state.cards[index].isSpecial
                                            ? state.game.swappedCards!.isNotEmpty &&
                                                    state.cards[index].fullName == 'Sinek-2'
                                                ? const Color.fromARGB(255, 30, 149, 34)
                                                : const Color.fromARGB(255, 255, 0, 157)
                                            : const Color.fromRGBO(0, 0, 0, 0.867);
                                        double baseBorderWidth = state.cards[index].isSpecial ? 3 : 1.6;

                                        // 🔹 Symbol rengi
                                        Color cardSymbolColor =
                                            (state.cards[index].symbol == '♥' || state.cards[index].symbol == '♦')
                                                ? Colors.red.shade800
                                                : Colors.black;

                                        bool isSwappedCard =
                                            state.game.swappedCards!.split(',').contains(state.cards[index].fullName);

                                        bool isSelectedToSwap = swappingCards.contains(state.cards[index].fullName) ||
                                            state.selectedCardsToSwap
                                                .map((c) => c.fullName)
                                                .toList()
                                                .contains(state.cards[index].fullName);

                                        return Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 5.w),
                                          child: AnimatedSwitcher(
                                            duration: const Duration(milliseconds: 400),
                                            transitionBuilder: (child, anim) =>
                                                ScaleTransition(scale: anim, child: child),
                                            child: GestureDetector(
                                              onTap: () {
                                                // 🔹 Kart seçimi / takası
                                                // if (state.sinekVar) {
                                                //   if (swappingCards.isNotEmpty) {
                                                //     swappingCards.remove(state.cards[index].fullName);
                                                //     swappingCards.add(state.cards[index].fullName);
                                                //   } else {
                                                //     swappingCards.add(state.cards[index].fullName);
                                                //   }

                                                if (state.sinekVar) {
                                                  // Sinek-2 (Takas) özel kartı aktifse
                                                  // setState kullanmalıyız ki kartın görseli (isSelectedToSwap) güncellensin
                                                  setState(() {
                                                    if (swappingCards.contains(state.cards[index].fullName)) {
                                                      // Eğer aynı karta tekrar tıklarsa: Seçimi kaldır (swappingCards boşalır)
                                                      swappingCards.clear();
                                                    } else {
                                                      // Yeni bir kart seçerse:
                                                      swappingCards
                                                          .clear(); // Önceki seçimi temizle (1 kart kuralı garanti edilir)
                                                      swappingCards.add(state.cards[index].fullName); // Yeni kartı ekle
                                                    }
                                                  });
                                                } else {
                                                  if ((state.game.isPlayer1Move! && state.game.isPlayer2Move!) ||
                                                      state.game.turn!) {
                                                    print('KART SEÇİMİ ENGELLENDİ');
                                                  } else {
                                                    print('KART SEÇİMİ YAPILDI:  ${state.game.turn!}');
                                                    if (widget.isPlayer1) {
                                                      if (!state.game.isPlayer1Move!) {
                                                        context.read<HomeCubit>().selectCard(CardModel(
                                                            symbol: state.cards[index].symbol,
                                                            rank: state.cards[index].rank,
                                                            value: state.cards[index].value,
                                                            fullName: (state.cards[index].fullName)));
                                                      }
                                                    } else {
                                                      if (!state.game.isPlayer2Move! && state.game.isPlayer1Move!) {
                                                        context.read<HomeCubit>().selectCard(CardModel(
                                                            symbol: state.cards[index].symbol,
                                                            rank: state.cards[index].rank,
                                                            value: state.cards[index].value,
                                                            fullName: (state.cards[index].fullName)));
                                                      }
                                                    }
                                                  }
                                                }
                                              },
                                              child: AnimatedContainer(
                                                duration: const Duration(milliseconds: 600),
                                                curve: Curves.easeInOutCubic,
                                                margin: EdgeInsets.only(top: isSelectedToSwap ? 0 : 10),
                                                transform: Matrix4.identity()
                                                  ..translate(0.0, isSelectedToSwap ? -18.0 : 0.0)
                                                  ..scale(isSelectedToSwap ? 1.08 : 1.0),
                                                decoration: BoxDecoration(
                                                  color: state.game.disabledCards! == state.cards[index].fullName
                                                      ? Colors.white.withAlpha(160)
                                                      : Colors.white,
                                                  borderRadius: BorderRadius.circular(12),
                                                  border: Border.all(color: baseBorderColor, width: baseBorderWidth),
                                                  boxShadow: [
                                                    if (isSwappedCard || isSelectedToSwap)
                                                      BoxShadow(
                                                        color: baseBorderColor.withOpacity(0.9),
                                                        blurRadius: 25,
                                                        spreadRadius: 3,
                                                      ),
                                                    BoxShadow(
                                                      color: Colors.black.withOpacity(0.25),
                                                      blurRadius: 6,
                                                      offset: const Offset(2, 3),
                                                    ),
                                                  ],
                                                ),
                                                width: 60,
                                                height: 95,
                                                child: Stack(
                                                  clipBehavior: Clip.none,
                                                  children: [
                                                    // --- Kartın Görsel Yapısı ---
                                                    Positioned(
                                                      top: 4,
                                                      left: 4,
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Text(
                                                            state.cards[index].rank,
                                                            style: TextStyle(
                                                              fontSize: 20,
                                                              fontWeight: FontWeight.w900,
                                                              color: cardSymbolColor,
                                                              height: 0.9,
                                                            ),
                                                          ),
                                                          Text(
                                                            state.cards[index].symbol,
                                                            style: TextStyle(
                                                              fontSize: 20,
                                                              fontWeight: FontWeight.bold,
                                                              color: cardSymbolColor,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),

                                                    Positioned(
                                                      bottom: 4,
                                                      right: 4,
                                                      child: Transform.rotate(
                                                        angle: math.pi,
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            Text(
                                                              state.cards[index].rank,
                                                              style: TextStyle(
                                                                fontSize: 20,
                                                                fontWeight: FontWeight.w900,
                                                                color: cardSymbolColor,
                                                                height: 0.9,
                                                              ),
                                                            ),
                                                            Text(
                                                              state.cards[index].symbol,
                                                              style: TextStyle(
                                                                fontSize: 20,
                                                                fontWeight: FontWeight.bold,
                                                                color: cardSymbolColor,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),

                                                    // --- Swap / Durum İndikatörleri ---
                                                    if (isSwappedCard)
                                                      Positioned(
                                                        top: -10,
                                                        right: -10,
                                                        child: AnimatedOpacity(
                                                          opacity: 1,
                                                          duration: const Duration(milliseconds: 400),
                                                          child: Container(
                                                            padding: const EdgeInsets.all(3),
                                                            decoration: const BoxDecoration(
                                                              color: Color.fromARGB(255, 83, 105, 192),
                                                              shape: BoxShape.circle,
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  blurRadius: 10,
                                                                  color: Color.fromARGB(255, 83, 105, 192),
                                                                  spreadRadius: 2,
                                                                )
                                                              ],
                                                            ),
                                                            child: const Icon(Icons.swap_horiz,
                                                                size: 22, color: Colors.white),
                                                          ),
                                                        ),
                                                      ),

                                                    if (state.game.disabledCards! == state.cards[index].fullName)
                                                      Positioned.fill(
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            color: Colors.black38,
                                                            borderRadius: BorderRadius.circular(8),
                                                          ),
                                                          child: Center(
                                                            child: Icon(
                                                              Icons.block,
                                                              size: 40,
                                                              color: Colors.white.withOpacity(0.8),
                                                            ),
                                                          ),
                                                        ),
                                                      ),

                                                    if (state.game.swappedCards!.isNotEmpty &&
                                                        state.cards[index].fullName == 'Sinek-2')
                                                      Positioned(
                                                        top: -22,
                                                        left: 18,
                                                        child: Container(
                                                          padding: const EdgeInsets.all(2),
                                                          decoration: const BoxDecoration(
                                                            color: Color.fromARGB(255, 0, 141, 21),
                                                            shape: BoxShape.circle,
                                                            boxShadow: [
                                                              BoxShadow(
                                                                  blurRadius: 8,
                                                                  color: Color.fromARGB(255, 0, 141, 21),
                                                                  spreadRadius: 1)
                                                            ],
                                                          ),
                                                          child: const Icon(Icons.check, size: 18, color: Colors.white),
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      ),

                      Expanded(
                        child: Container(
                          width: 0.8.sw,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.black.withOpacity(0.95),
                                Colors.grey.shade900,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white24, width: 1),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: SingleChildScrollView(
                            controller: _logController,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: log.split('\n').map((line) {
                                Color textColor = Colors.white;
                                if (line.toLowerCase().contains("kullanıcı") || line.toLowerCase().contains("siz")) {
                                  textColor = Colors.cyanAccent;
                                } else if (line.toLowerCase().contains("bot")) {
                                  textColor = Colors.pinkAccent;
                                } else if (line.toLowerCase().contains("kazanan")) {
                                  textColor = Colors.greenAccent;
                                }

                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 2),
                                  child: Text(
                                    line,
                                    style: TextStyle(
                                      fontFamily: 'monospace',
                                      fontSize: 13,
                                      height: 1.3,
                                      color: textColor,
                                      shadows: [
                                        Shadow(
                                          blurRadius: 6,
                                          color: textColor.withOpacity(0.6),
                                          offset: const Offset(0, 0),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30.h), // Butonun kapladığı alanı koru
                      BlocBuilder<HomeCubit, HomeState>(
                        builder: (context, state) {
                          if (state.getStatusState == GetStatusStates.completed && state.cards.isNotEmpty) {
                            return InfoProfile(
                              //  image: state.game.player2Image ?? '',
                              image: widget.isPlayer1
                                  ? state.game.player1Image! // P1 ise kendi resmi
                                  : state.game.player2Image!, // P2 ise kendi resmi

                              isPlayer1: widget.isPlayer1,
                              point: (state.cards
                                      .where((card) => card.fullName != state.game.disabledCards)
                                      .toList()
                                      .map((c) => c.value)
                                      .toList()
                                      .reduce((a, b) => a + b)) *
                                  (widget.isPlayer1 ? state.player1Multiplier : state.player2Multiplier),
                              userWins: widget.isPlayer1
                                  ? state.player1WinCount // Cihaz P1 ise, userWins P1 skorudur.
                                  : state.player2WinCount, // Cihaz P2 ise, userWins P2 skorudur.
                              content: widget.isPlayer1
                                  ? 'Round ${state.game.currentTurnId! + 1} / ${3}  • Score: Oppoinment ${state.player2WinCount} - You ${state.player1WinCount}'
                                  : 'Round ${state.game.currentTurnId! + 1} / ${3}  • Score: Oppoinment ${state.player1WinCount} - You ${state.player2WinCount}',
                              oppWins: widget.isPlayer1
                                  ? state.player2WinCount // Cihaz P1 ise, oppWins P2 skorudur.
                                  : state.player1WinCount, // Cihaz P2 ise, oppWins P1 skorudur.
                              name: widget.isPlayer1
                                  ? '${state.game.player1Name!} ${state.game.player1Surname!} ${state.player1Multiplier > 1 ? '(x${state.player1Multiplier})' : ''}'
                                  : '${state.game.player2Name!} ${state.game.player2Surname!} ${state.player2Multiplier > 1 ? '(x${state.player2Multiplier})' : ''}',
                            );
                          } else {
                            return InfoProfile(
                                isPlayer1: widget.isPlayer1,
                                image: '',
                                point: 0,
                                content: widget.isPlayer1
                                    ? 'Round ${state.game.currentTurnId! + 1} / ${3}  • Score: Oppoinment ${state.player2WinCount} - You ${state.player1WinCount}'
                                    : 'Round ${state.game.currentTurnId! + 1} / ${3}  • Score: Oppoinment ${state.player1WinCount} - You ${state.player2WinCount}',
                                userWins: state.player1WinCount,
                                oppWins: state.player2WinCount);
                          }
                        },
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ),

            //* USER ANIMATIONS
            Positioned(
              bottom: 0.1.sh,
              child: BlocConsumer<HomeCubit, HomeState>(
                listenWhen: (previous, current) =>
                    previous.isKupaPapazDialogShown != current.isKupaPapazDialogShown ||
                    previous.isKaroDialogShown != current.isKaroDialogShown ||
                    previous.isSinekDialogShown != current.isSinekDialogShown,
                listener: (context, state) {
                  if (state.isKupaPapazDialogShown) {
                    Future.delayed(const Duration(seconds: 3), () {}).then((_) {
                      context.read<HomeCubit>().setIsKupaPapazDialogShown(false);
                      // Dialog gösterimi tamamlandıktan sonra Cubit'i güncelle
                    });
                  } else if (state.isKaroDialogShown) {
                    Future.delayed(const Duration(seconds: 3), () {}).then((_) {
                      context.read<HomeCubit>().setIsKaroDialogShown(false);
                      // Dialog gösterimi tamamlandıktan sonra Cubit'i güncelle
                    });
                  } else if (state.isSinekDialogShown) {
                    Future.delayed(const Duration(seconds: 3), () {}).then((_) {
                      context.read<HomeCubit>().setIsSinekDialogShown(false);

                      // Dialog gösterimi tamamlandıktan sonra Cubit'i güncelle
                    });
                  }
                },
                builder: (context, state) {
                  if (state.isKupaPapazDialogShown) {
                    return Center(
                      child: Lottie.asset(
                        'assets/lottie/2x.json',
                        width: 0.5.sw,
                        repeat: true,
                      ),
                    );
                  } else if (state.isSinekDialogShown) {
                    return Center(
                      child: Lottie.asset(
                        'assets/lottie/swap.json',
                        width: 0.5.sw,
                        repeat: true,
                      ),
                    );
                  } else if (state.isKaroDialogShown) {
                    return Center(
                      child: Lottie.asset(
                        'assets/lottie/disabled.json',
                        width: 0.5.sw,
                        repeat: true,
                      ),
                    );
                  } else
                    return const SizedBox();
                },
              ),
            ),
            //* OPPONENT ANIMATIONS
            Positioned(
              top: 0.1.sh,
              child: BlocConsumer<HomeCubit, HomeState>(
                listenWhen: (previous, current) =>
                    previous.isKupaPapaz2DialogShown != current.isKupaPapaz2DialogShown ||
                    previous.isKaro2DialogShown != current.isKaro2DialogShown ||
                    previous.isSinek2DialogShown != current.isSinek2DialogShown,
                listener: (context, state) {
                  if (state.isKupaPapaz2DialogShown) {
                    Future.delayed(const Duration(seconds: 3), () {}).then((_) {
                      context.read<HomeCubit>().setIsKupaPapaz2DialogShown(false);

                      // Dialog gösterimi tamamlandıktan sonra Cubit'i güncelle
                    });
                  } else if (state.isKaro2DialogShown) {
                    Future.delayed(const Duration(seconds: 3), () {}).then((_) {
                      context.read<HomeCubit>().setIsKaro2DialogShown(false);

                      // Dialog gösterimi tamamlandıktan sonra Cubit'i güncelle
                    });
                  } else if (state.isSinek2DialogShown) {
                    Future.delayed(const Duration(seconds: 3), () {}).then((_) {
                      context.read<HomeCubit>().setIsSinek2DialogShown(false);

                      // Dialog gösterimi tamamlandıktan sonra Cubit'i güncelle
                    });
                  }
                },
                builder: (context, state) {
                  if (state.isKupaPapaz2DialogShown) {
                    return Center(
                      child: Lottie.asset(
                        'assets/lottie/2x.json',
                        width: 0.5.sw,
                        repeat: true,
                      ),
                    );
                  } else if (state.isSinek2DialogShown) {
                    return Center(
                      child: Lottie.asset(
                        'assets/lottie/swap.json',
                        width: 0.5.sw,
                        repeat: true,
                      ),
                    );
                  } else if (state.isKaro2DialogShown) {
                    return Center(
                      child: Lottie.asset(
                        'assets/lottie/disabled.json',
                        width: 0.5.sw,
                        repeat: true,
                      ),
                    );
                  } else
                    return const SizedBox();
                },
              ),
            ),

            // Yeni: El başlangıcı hazır olma overlay'i
            _buildReadyOverlay(),

            // YENİ: Info Mesaj Overlay'i
            _buildInfoMessageOverlay(),
          ],
        ),
      ),
    );
  }
}

class InfoProfile extends StatelessWidget {
  InfoProfile({
    super.key,
    required this.point,
    this.userWins = 0,
    this.oppWins = 0,
    this.name = '',
    required this.content,
    required this.image,
    required this.isPlayer1,
  });

  int? point;
  int userWins;
  int oppWins;
  String name;
  String content;
  String image;
  bool isPlayer1;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 0.9.sw,
        height: 80.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          gradient: const LinearGradient(
            colors: [kBlackColor, kTableNavy],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: Colors.amberAccent.withOpacity(0.9),
            width: 2.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.amber.withOpacity(0.3),
              blurRadius: 16,
              spreadRadius: 2,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        clipBehavior: Clip.hardEdge,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                // 🧍 Avatar
                image.isEmpty
                    ? Container(
                        width: 60,
                        height: 60,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [Colors.grey, Colors.black54],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: const Icon(Icons.person, color: Colors.white, size: 36),
                      )
                    : Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.amberAccent, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.amber.withOpacity(0.5),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.network(
                            'https://btkgameapi.linsabilisim.com/$image',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                const SizedBox(width: 14),

                // 📄 Kullanıcı Bilgileri
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 👤 İsim + Puan
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              '$name ',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 0.6,
                              ),
                            ),
                          ),
                          const SizedBox(width: 2),
                          point != null
                              ? Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.amber.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.amberAccent, width: 1),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.monetization_on, size: 16, color: Colors.amberAccent),
                                      const SizedBox(width: 2),
                                      Text(
                                        '$point',
                                        style: TextStyle(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.amberAccent,
                                          shadows: [
                                            Shadow(
                                              blurRadius: 10,
                                              color: Colors.amberAccent.withOpacity(0.8),
                                              offset: const Offset(0, 1),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Image.asset('assets/asset/lock.png', height: 28),
                        ],
                      ),

                      const SizedBox(height: 4),

                      // 💬 Kullanıcı Açıklaması
                      BlocBuilder<HomeCubit, HomeState>(
                        builder: (context, state) {
                          print("Contetn: $content");
                          return Text(
                            content,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.white70,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.4,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                // 🏆 Kazanma Bilgisi
                if (userWins > 0 || oppWins > 0)
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.amberAccent.withOpacity(0.8)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.emoji_events, size: 18, color: Colors.amberAccent),
                          const SizedBox(width: 4),
                          Text(
                            '$userWins - $oppWins',
                            //  isPlayer1 == true ? '$userWins - $oppWins' : '$oppWins - $userWins',
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 0.4,
                            ),
                          ),
                        ],
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
// class InfoProfile extends StatelessWidget {
//   InfoProfile({
//     super.key,
//     required this.point,
//     this.userWins = 0,
//     this.oppWins = 0,
//     this.name = '',
//     required this.content,
//     required this.image,
//   });
//   int? point;
//   int userWins;
//   int oppWins;
//   String name;
//   String content;
//   String image;
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Container(
//         width: 0.9.sw,
//         height: 60.h,
//         padding: const EdgeInsets.symmetric(horizontal: 6),
//         decoration: BoxDecoration(
//           color: Colors.black.withOpacity(0.6),
//           borderRadius: BorderRadius.circular(30),
//           border: Border.all(color: Colors.yellowAccent, width: 2),
//         ),
//         child: Row(
//           children: [
//             // CircleAvatar(
//             //   radius: 22.sp,
//             //   backgroundColor: Colors.white,
//             //   child: const Icon(Icons.person, color: Colors.grey),
//             // ),
//             image.isEmpty
//                 ? const Padding(
//                     padding: EdgeInsets.all(8.0),
//                     child: Icon(Icons.person, color: Colors.white, size: 50),
//                   )
//                 : ClipOval(
//                     child: Image.network(
//                       'https://btkgameapi.linsabilisim.com/$image',
//                       width: 60,
//                       height: 60,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//             const SizedBox(width: 8),
//             Expanded(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       // YENİ: Toplamı finalTotal() ile büyüt ve renklendir
//                       Text('$name — ',
//                           style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.white)),
//                       point != null
//                           ? Text('$point', // *** DÜZELTİLDİ: finalTotal kullanılıyor
//                               style: TextStyle(
//                                   fontSize: 22.sp, // *** BÜYÜTÜLDÜ
//                                   fontWeight: FontWeight.w900,
//                                   color: Colors.amberAccent, // *** SOFT RENK
//                                   shadows: [
//                                     Shadow(
//                                       blurRadius: 5.0,
//                                       color: Colors.amber.withOpacity(0.8),
//                                       offset: const Offset(1.0, 1.0),
//                                     ),
//                                   ]))
//                           : Image.asset(
//                               'assets/asset/lock.png',
//                               height: 32,
//                             ),
//                     ],
//                   ),
//                   const SizedBox(height: 2),
//                   BlocBuilder<HomeCubit, HomeState>(
//                     //! Gel bi
//                     builder: (context, state) {
//                       //'El ${state.game.currentTurnId! + 1} / ${3}  • Skor: Siz $userWins - Rakip $oppWins',
//                       return Text(content.toString(), style: TextStyle(fontSize: 12.sp, color: Colors.white70));
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
