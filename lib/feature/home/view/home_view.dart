import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_base_app/feature/home/cubit/home_cubit.dart';
import 'package:flutter_base_app/feature/home/cubit/home_state.dart';
import 'package:flutter_base_app/feature/home/model/card_model.dart';
import 'package:flutter_base_app/product/constant/color_constants.dart';
import 'package:flutter_base_app/product/injector/injector.dart';
import 'package:flutter_base_app/product/storage/local_get_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
  int currentHand = 1;
  final int maxHands = 3; // 3 el oynanacak
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
  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().setStateToLoading();

    timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      context.read<HomeCubit>().getInitialStatusGame();
    });
    // initialize keys
    userCardKeys = List.generate(5, (_) => GlobalKey());
    oppCardKeys = List.generate(5, (_) => GlobalKey());
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

  // Yeni: El sonu sonuç overlay'i
  Widget _buildHandResultOverlay() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return ScaleTransition(scale: animation, child: child);
      },
      child: showHandResultOverlay
          ? Container(
              color: Colors.black.withOpacity(0.5),
              alignment: Alignment.center,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.green.shade800,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.white, width: 3),
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
                      handResultText,
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.yellowAccent,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    //* SONRAKİ ELE GEÇ BUTONU (ŞİMDİLİK DEVRE DIŞI)
                    // ElevatedButton(
                    //   onPressed: _continueToNextHand,
                    //   style: ElevatedButton.styleFrom(
                    //     backgroundColor: Colors.white,
                    //     padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    //   ),
                    //   child: Text(
                    //     'DEVAM',
                    //     style: TextStyle(fontSize: 18.sp, color: Colors.green.shade900, fontWeight: FontWeight.bold),
                    //   ),
                    // ),
                  ],
                ),
              ),
            )
          : const SizedBox.shrink(),
    );
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
                            '${currentHand}. El Başlıyor...',
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
                                        ? 'Karşı oyuncu hazır. Bekleniyor...'
                                        : 'Karşı oyuncu bekleniyor...'
                                    : state.game.isPlayer1Ready!
                                        ? 'Karşı oyuncu hazır. Bekleniyor...'
                                        : 'Karşı oyuncu bekleniyor...',
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
                                _appendLog('Her iki oyuncu das hazır. El başlıyor!');
                                print('İKİ OYUNCU DA HAZIR, EL BAŞLIYOR...');
                              } else if (widget.isPlayer1 && state.game.isPlayer2Ready!) {
                                // Kullanıcı 1 ve rakip hazırsa
                                _appendLog('Rakip oyuncu hazır. Siz de hazırsanız el başlayacak.');
                                print('PLAYER 1 siniz RAKİP HAZIR, KULLANICI BEKLENİYOR...');
                              } else if (!widget.isPlayer1 && state.game.isPlayer1Ready!) {
                                // Kullanıcı 2 ve rakip hazırsa
                                _appendLog('Rakip oyuncu hazır. Siz de hazırsanız el başlayacak.');
                                print('PLAYER 2 siniz RAKİP HAZIR, KULLANICI BEKLENİYOR...');
                              }
                            },
                            builder: (context, state) {
                              return ElevatedButton(
                                onPressed: () {
                                  if (widget.isPlayer1) {
                                    context.read<HomeCubit>().setPlayerReady(1, true);
                                  } else {
                                    context.read<HomeCubit>().setPlayerReady(1, false);
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
                                          ? 'HAZIR'
                                          : 'HAZIRIM'
                                      : state.game.isPlayer2Ready!
                                          ? 'HAZIR'
                                          : 'HAZIRIM',
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
    return Scaffold(
      backgroundColor: kTableGreen,
      drawer: Drawer(
        elevation: 16,
        child: SafeArea(
          child: Column(
            children: [
              const ListTile(title: Text('Oyun Logları')),
              const Divider(),
              Expanded(
                child: SingleChildScrollView(
                  reverse: true,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(log, style: const TextStyle(fontFamily: 'monospace')),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
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
                          Text('El $currentHand / $maxHands', style: TextStyle(color: Colors.white, fontSize: 14.sp)),
                          Row(
                            children: [
                              Chip(
                                backgroundColor: botReady ? Colors.green[400] : Colors.grey[600],
                                label: Text('Bot: ${botReady ? "" : "BeHazırkliyor"}'),
                              ),
                              const SizedBox(width: 8),
                              // Buradaki 'Hazırım' butonu artık _buildReadyOverlay'e taşındı.
                              // Sadece seçim aşamasında değilken ve hazır değilken görünüyor.
                              if (!selectionPhase && !userReady)
                                ElevatedButton(
                                  onPressed: null, // Pasif bırak
                                  child: Text(userReady ? 'Hazır' : 'Bekleniyor...'),
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
                            point: (state.game.isPlayer1Move! && state.game.isPlayer2Move!) || state.game.turn!
                                ? (state.opponentCards
                                        .where((oc) => oc.fullName != state.game.disabledCards)
                                        .toList()
                                        .map((c) => c.value)
                                        .toList()
                                        .reduce((a, b) => a + b) *
                                    (widget.isPlayer1 ? state.player2Multiplier : state.player1Multiplier))
                                : null,
                            currentHand: currentHand,
                            maxHands: maxHands,
                            userWins: userHandWins,
                            oppWins: oppHandWins,
                            name: widget.isPlayer1
                                ? '${state.game.player2Name!} ${state.game.player2Surname!} ${state.player2Multiplier > 1 ? '(x${state.player2Multiplier})' : ''}'
                                : '${state.game.player1Name!} ${state.game.player1Surname!} ${state.player1Multiplier > 1 ? '(x${state.player1Multiplier})' : ''}',
                          );
                        } else {
                          return SizedBox();
                        }
                      },
                    ),
                    const Spacer(),

                    // _buildHandRow(opponent, isTop: true),

                    BlocBuilder<HomeCubit, HomeState>(
                      builder: (context, state) {
                        if (state.getStatusState == GetStatusStates.loading) {
                          return const CircularProgressIndicator();
                        } else if (state.getStatusState == GetStatusStates.error) {
                          return Text('Hata: ${state.errorMessage}', style: const TextStyle(color: Colors.red));
                        } else if (state.getStatusState == GetStatusStates.completed) {
                          // Kartları gösterme animasyonu
                          if ((state.game.isPlayer1Move! && state.game.isPlayer2Move!) || state.game.turn!) {
                            return Container(
                                height: 110,
                                width: 1.sw,
                                child: ListView.builder(
                                  itemCount: state.opponentCards.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    Color baseBorderColor = state.opponentCards[index].isSpecial
                                        ? state.game.swappedCards!.isNotEmpty &&
                                                state.opponentCards[index].fullName == 'Sinek-2'
                                            ? const Color.fromARGB(255, 30, 149, 34)
                                            : const Color.fromARGB(255, 255, 0, 157)
                                        : (state.sinekVar && swappingCards.length == 1) || state.karoVar
                                            ? const Color.fromARGB(255, 255, 203, 15)
                                            : const Color.fromRGBO(0, 0, 0, 0.867);
                                    double baseBorderWidth = state.opponentCards[index].isSpecial
                                        ? 3
                                        : (state.sinekVar && swappingCards.length == 1) || state.karoVar
                                            ? 3
                                            : 2;
                                    return AnimatedSwitcher(
                                      duration: const Duration(milliseconds: 400),
                                      transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
                                      child: GestureDetector(
                                        onTap: () {},
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(horizontal: 6),
                                          child: TweenAnimationBuilder<Color?>(
                                            tween: ColorTween(
                                              // Takas edilmiş kartlar için mor ve beyaz arasında titreşim
                                              begin: state.opponentCards[index].isSpecial
                                                  ? baseBorderColor
                                                  : Colors.black26, //wasSwapped
                                              end: state.opponentCards[index].isSpecial
                                                  ? baseBorderColor
                                                  : Colors.black26,
                                            ),
                                            duration: const Duration(milliseconds: 700),
                                            curve: Curves.easeInOut,
                                            // Tekrarlı animasyon için dışarıda bir Controller ve AnimatedBuilder daha iyi olurdu,
                                            // ancak burada basit bir "titreşim" etkisi için TweenAnimationBuilder'ı kullanıyoruz.
                                            builder: (context, color, child) {
                                              return GestureDetector(
                                                onTap: () {
                                                  if (state.sinekVar && swappingCards.length == 1) {
                                                    swappingCards.add(state.opponentCards[index].fullName);

                                                    context.read<HomeCubit>().sinekle(1, swappingCards.join(','));
                                                    context.read<HomeCubit>().setSinekVar(false);
                                                    swappingCards.clear();
                                                    _appendLog(
                                                        'Takas için kart seçildi: ${state.opponentCards[index].fullName}');
                                                  } else if (state.karoVar) {
                                                    context
                                                        .read<HomeCubit>()
                                                        .disableCards(1, state.opponentCards[index].fullName);
                                                    context.read<HomeCubit>().setKaroVar(false);
                                                    _appendLog(
                                                        'Etkisiz hale getirilen kart seçildi: ${state.opponentCards[index].fullName}');
                                                  }
                                                },
                                                child: AnimatedContainer(
                                                  duration: const Duration(milliseconds: 600),
                                                  curve: Curves.easeInOut,
                                                  margin: EdgeInsets.only(
                                                    top: state.selectedCardsToSwap
                                                                .map((c) => c.fullName)
                                                                .toList()
                                                                .contains(state.opponentCards[index].fullName) ||
                                                            swappingCards.contains(state.opponentCards[index].fullName)
                                                        ? 0
                                                        : 8,
                                                  ),
                                                  transform: Matrix4.translationValues(
                                                      0,
                                                      state.selectedCardsToSwap
                                                              .map((c) => c.fullName)
                                                              .toList()
                                                              .contains(state.opponentCards[index].fullName)
                                                          ? -14
                                                          : 0,
                                                      0),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        state.game.disabledCards! == state.opponentCards[index].fullName
                                                            ? Colors.white.withAlpha(160)
                                                            : Colors.white,
                                                    borderRadius: BorderRadius.circular(8),
                                                    border: Border.all(color: baseBorderColor, width: baseBorderWidth),
                                                    boxShadow: [
                                                      BoxShadow(
                                                          blurRadius: state.opponentCards[index].isSpecial ? 32 : 4,
                                                          color: baseBorderColor,
                                                          offset: Offset(1, 2)),
                                                      // Kupa Papaz (K♥) için Altın Parlaklık efekti (Sadece özel kart ve etkisiz değilse)
                                                    ],
                                                  ),
                                                  width: 60,
                                                  height: 92,
                                                  child: Stack(
                                                    clipBehavior: Clip.none,
                                                    children: [
                                                      // Kart içeriği
                                                      Center(
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Text(state.opponentCards[index].rank,
                                                                style: const TextStyle(
                                                                    fontSize: 18, fontWeight: FontWeight.bold)),
                                                            const SizedBox(height: 6),
                                                            Text(state.opponentCards[index].symbol,
                                                                style: TextStyle(
                                                                    fontSize: 18,
                                                                    color: (state.opponentCards[index].symbol == '♥' ||
                                                                            state.opponentCards[index].symbol == '♦')
                                                                        ? Colors.red
                                                                        : Colors.black)),
                                                            const SizedBox(height: 6),
                                                            // Etkisiz kart değeri "0" olarak daha belirgin
                                                            Text(
                                                              '${state.opponentCards[index].value}',
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                fontWeight: FontWeight.w900,
                                                                color: Colors.red.shade800,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      // Etkisiz (Disabled) Overlay - Karo 2 (♦2) etkisi
                                                      // if (c.disabled)
                                                      //   // Mevcut sallanma animasyonunu koru ve üzerine X işareti ekle
                                                      //   TweenAnimationBuilder<double>(
                                                      //     tween: Tween(begin: -0.05, end: 0.05),
                                                      //     duration: const Duration(milliseconds: 400),
                                                      //     curve: Curves.easeInOut,
                                                      //     onEnd: () {
                                                      //       // Animasyonu sürekli ters yöne doğru tetiklemek için setState (basit bir loop)
                                                      //       if (mounted) setState(() {});
                                                      //     },
                                                      //     builder: (context, angle, child) {
                                                      //       return Transform.rotate(
                                                      //         angle: angle,
                                                      //         child: Container(
                                                      //           decoration: BoxDecoration(
                                                      //             color: Colors.grey
                                                      //                 .withOpacity(0.6), // Daha opak hale getir
                                                      //             borderRadius: BorderRadius.circular(8),
                                                      //             border: Border.all(color: Colors.redAccent, width: 3),
                                                      //           ),
                                                      //           child: Center(
                                                      //               child: Icon(Icons.close_rounded,
                                                      //                   size: 40,
                                                      //                   color: Colors.red.shade800)), // Kırmızı X
                                                      //         ),
                                                      //       );
                                                      //     },
                                                      //   ),
                                                      // Sinek 2 (♣2) - Takas Edilmiş İşareti
                                                      if (state.game.swappedCards!
                                                          .split(',')
                                                          .contains(state.opponentCards[index].fullName))
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

                                                      if (state.game.disabledCards! ==
                                                          state.opponentCards[index].fullName)
                                                        Positioned(
                                                          child: Container(
                                                            width: 60,
                                                            height: 92,
                                                            padding: const EdgeInsets.all(2),
                                                            decoration: const BoxDecoration(
                                                              shape: BoxShape.circle,
                                                            ),
                                                            child: Placeholder(
                                                              color: Colors.black26,
                                                            ),
                                                          ),
                                                        ),

                                                      state.game.swappedCards!.isNotEmpty &&
                                                              state.opponentCards[index].fullName == 'Sinek-2'
                                                          ? Positioned(
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
                                                            )
                                                          : SizedBox.shrink(),
                                                      // Kupa Papaz (K♥) - Çarpan İşareti
                                                      // if (c.isKingOfHearts && !c.disabled)
                                                      //   const Positioned(
                                                      //     bottom: 4,
                                                      //     left: 4,
                                                      //     child: Text('x2',
                                                      //         style: TextStyle(
                                                      //             fontSize: 16,
                                                      //             fontWeight: FontWeight.w900,
                                                      //             color: Colors.redAccent,
                                                      //             shadows: [
                                                      //               Shadow(
                                                      //                   blurRadius: 4,
                                                      //                   color: Colors.red,
                                                      //                   offset: Offset(1, 1))
                                                      //             ])),
                                                      //   )
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ));
                          } else {
                            return Container(
                              width: 55, // Kart genişliği ile uyumlu hale getirildi
                              height: 85, // Kart yüksekliği ile uyumlu hale getirildi
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
                        image: DecorationImage(image: Image.asset('assets/asset/deck.png').image, fit: BoxFit.cover),
                      ),
                      child: Center(
                          child: Container(
                        margin: const EdgeInsets.all(1),
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: kTableNavy, width: 2),
                        ),
                        child: BlocBuilder<HomeCubit, HomeState>(
                          builder: (context, state) {
                            if (state.getStatusState != GetStatusStates.completed) {
                              return SizedBox();
                            } else {
                              return Text('${state.game.playedCards!.split(',').length} kart',
                                  style: TextStyle(color: kTableNavy, fontSize: 20.sp, fontWeight: FontWeight.bold));
                            }
                          },
                        ),
                      )),
                    ),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 15.h),
                          Text('Kart değişimi: En fazla 3 kart seçebilirsiniz.',
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
                              listener: (context, state) {
                                if (state.game.isPlayer1Move! && state.game.isPlayer2Move! && state.game.turn!) {
                                  // MOVE'LARI FALSE YAP
                                  context.read<HomeCubit>().swapCards(state.game.id!, state.game.player1Id!, false, '');
                                  context.read<HomeCubit>().swapCards(state.game.id!, state.game.player2Id!, false, '');
                                }
                                print('listener -- player : ${widget.isPlayer1}');

                                if (!state.game.isPlayer1Move! && !state.game.isPlayer2Move! && state.game.turn!) {
                                  if (widget.isPlayer1) {
                                    print('listener ---- player 1');
                                    for (var element in (state.cards)) {
                                      if (element.isSpecial) {
                                        switch (element.fullName) {
                                          case 'Kupa-K':
                                            context.read<HomeCubit>().setPlayerMultipliers(2, 1);
                                            _appendLog('Kupa Papaz (K♥) kartı masaya konuldu! Kart değeri 2x olacak.');
                                            break;
                                          case 'Sinek-2':
                                            context.read<HomeCubit>().setSinekVar(true);
                                            // Todo: Delay

                                            _appendLog('Sinek 2 (♣2) kartı masaya konuldu! Bir kart takas edilecek.');
                                            break;
                                          case 'Karo-2':
                                            context.read<HomeCubit>().setKaroVar(true);
                                            // Todo: Delay

                                            _appendLog(
                                                'Karo 2 (♦2) kartı masaya konuldu! Bir kart etkisiz hale gelecek.');
                                            break;
                                          default:
                                        }
                                      }
                                    }
                                    context
                                        .read<HomeCubit>()
                                        .swapCards(state.game.id!, state.game.player1Id!, true, '');
                                  }
                                } else if (state.game.isPlayer1Move! &&
                                    !state.game.isPlayer2Move! &&
                                    state.game.turn!) {
                                  if (!widget.isPlayer1) {
                                    print('listener ---- player 2');
                                    for (var element in (state.cards)) {
                                      if (element.isSpecial) {
                                        switch (element.fullName) {
                                          case 'Kupa-K':
                                            context.read<HomeCubit>().setPlayerMultipliers(1, 2);
                                            _appendLog('Kupa Papaz (K♥) kartı masaya konuldu! Kart değeri 2x olacak.');
                                            break;
                                          case 'Sinek-2':
                                            context.read<HomeCubit>().setSinekVar(true);
                                            _appendLog('Sinek 2 (♣2) kartı masaya konuldu! Bir kart takas edilecek.');
                                            // Todo: Delay
                                            break;
                                          case 'Karo-2':
                                            context.read<HomeCubit>().setKaroVar(true);
                                            // Todo: Delay
                                            _appendLog(
                                                'Karo 2 (♦2) kartı masaya konuldu! Bir kart etkisiz hale gelecek.');
                                            break;
                                          default:
                                        }
                                      }
                                    }
                                    context
                                        .read<HomeCubit>()
                                        .swapCards(state.game.id!, state.game.player2Id!, true, '');
                                  }
                                }
                                for (var element in state.opponentCards) {
                                  if (element.isSpecial && element.fullName == 'Kupa-K') {
                                    context
                                        .read<HomeCubit>()
                                        .setPlayerMultipliers(widget.isPlayer1 ? 1 : 2, widget.isPlayer1 ? 2 : 1);
                                    _appendLog(
                                        'Kupa Papaz (K♥) kartı rakip tarafından masaya konuldu! Kart değeri 2x olacak.');
                                  }
                                }
                              },
                              builder: (context, state) {
                                if (state.getStatusState == GetStatusStates.completed) {
                                  return ElevatedButton(
                                    onPressed: () {
                                      int? userId = injector.get<LocalStorage>().getInt('userId');
                                      if (!state.game.turn! &&
                                          !(widget.isPlayer1 ? state.game.isPlayer1Move! : state.game.isPlayer2Move!)) {
                                        context.read<HomeCubit>().swapCards(1, userId!, true,
                                            state.selectedCardsToSwap.map((c) => c.fullName).toList().join(','));
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      // Arkaplan: Koyu Masa Teması
                                      backgroundColor: kTableNavy,
                                      // Kenarlık: Altın Sarısı Accent
                                      side: const BorderSide(color: Colors.amberAccent, width: 3),
                                      // Köşe yuvarlaklığı
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                                      elevation: 0, // Kendi gölgemizi kullandığımız için default elevation'ı sıfırla
                                    ),
                                    child: Text(
                                      (state.game.isPlayer1Move! && state.game.isPlayer2Move!) || state.game.turn!
                                          ? 'Değiştirme işlemleri yapıldı. KARTLAR AÇILDI!'
                                          : widget.isPlayer1
                                              ? !state.game.isPlayer1Move!
                                                  ? 'SEÇİLİ KARTLARI DEĞİŞTİR / ATLA'
                                                  : 'Karşı oyuncu seçiyor...'
                                              : !state.game.isPlayer2Move!
                                                  ? 'SEÇİLİ KARTLARI DEĞİŞTİR / ATLA'
                                                  : 'Karşı oyuncu seçiyor...',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17.sp,
                                        fontWeight: FontWeight.bold,
                                        shadows: [
                                          // Yazıya hafif parlaklık
                                          Shadow(
                                            blurRadius: 4.0,
                                            color: Colors.yellow.withOpacity(0.7),
                                            offset: const Offset(0.5, 0.5),
                                          ),
                                        ],
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  );
                                } else {
                                  return SizedBox();
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
                          return Text('Hata: ${state.errorMessage}', style: const TextStyle(color: Colors.red));
                        } else if (state.getStatusState == GetStatusStates.completed) {
                          // Kartları gösterme animasyonu

                          return Column(
                            children: [
                              AnimatedContainer(
                                  duration: const Duration(milliseconds: 800),
                                  curve: Curves.easeInOut,
                                  padding: const EdgeInsets.all(6),
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
                                  child: Container(
                                    height: 110,
                                    width: 1.sw,
                                    child: ListView.builder(
                                      itemCount: state.cards.length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        Color baseBorderColor = state.cards[index].isSpecial
                                            ? state.game.swappedCards!.isNotEmpty &&
                                                    state.cards[index].fullName == 'Sinek-2'
                                                ? const Color.fromARGB(255, 30, 149, 34)
                                                : const Color.fromARGB(255, 255, 0, 157)
                                            : const Color.fromRGBO(0, 0, 0, 0.867);
                                        double baseBorderWidth = state.cards[index].isSpecial ? 3 : 1.6;
                                        return AnimatedSwitcher(
                                          duration: const Duration(milliseconds: 400),
                                          transitionBuilder: (child, anim) =>
                                              ScaleTransition(scale: anim, child: child),
                                          child: GestureDetector(
                                            onTap: () {
                                              print('object tapped');
                                              // if (p == user) _toggleSelectUser(i);
                                            },
                                            child: Container(
                                              margin: const EdgeInsets.symmetric(horizontal: 6),
                                              child: TweenAnimationBuilder<Color?>(
                                                tween: ColorTween(
                                                  // Takas edilmiş kartlar için mor ve beyaz arasında titreşim
                                                  begin: state.cards[index].isSpecial
                                                      ? baseBorderColor
                                                      : Colors.black26, //wasSwapped
                                                  end: state.cards[index].isSpecial ? baseBorderColor : Colors.black26,
                                                ),
                                                duration: const Duration(milliseconds: 700),
                                                curve: Curves.easeInOut,
                                                // Tekrarlı animasyon için dışarıda bir Controller ve AnimatedBuilder daha iyi olurdu,
                                                // ancak burada basit bir "titreşim" etkisi için TweenAnimationBuilder'ı kullanıyoruz.
                                                builder: (context, color, child) {
                                                  // Color finalBorderColor = selected ? Colors.blue : color ?? baseBorderColor;
                                                  // double finalBorderWidth = selected
                                                  //     ? 3
                                                  //     : wasSwapped
                                                  //         ? 4 // Daha kalın ve mor/beyaz arasında titreşen sınır
                                                  //         : baseBorderWidth;

                                                  return GestureDetector(
                                                    onTap: () {
                                                      if (state.sinekVar) {
                                                        if (swappingCards.isNotEmpty) {
                                                          swappingCards.remove(state.cards[index].fullName);
                                                          swappingCards.add(state.cards[index].fullName);
                                                        } else {
                                                          swappingCards.add(state.cards[index].fullName);
                                                        }
                                                      } else {
                                                        if ((state.game.isPlayer1Move! && state.game.isPlayer2Move!) ||
                                                            state.game.turn!) {
                                                          print('KART SEÇİMİ ENGELLENDİ');
                                                          // Her iki oyuncu da hamlesini yaptıktan sonra kart seçimi engellensin
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
                                                      curve: Curves.easeInOut,
                                                      margin: EdgeInsets.only(
                                                        top: state.selectedCardsToSwap
                                                                    .map((c) => c.fullName)
                                                                    .toList()
                                                                    .contains(state.cards[index].fullName) ||
                                                                swappingCards.contains(state.cards[index].fullName)
                                                            ? 0
                                                            : 8,
                                                      ),
                                                      transform: Matrix4.translationValues(
                                                          0,
                                                          state.selectedCardsToSwap
                                                                  .map((c) => c.fullName)
                                                                  .toList()
                                                                  .contains(state.cards[index].fullName)
                                                              ? -14
                                                              : 0,
                                                          0),
                                                      decoration: BoxDecoration(
                                                        color: state.game.disabledCards! == state.cards[index].fullName
                                                            ? Colors.white.withAlpha(160)
                                                            : Colors.white,
                                                        borderRadius: BorderRadius.circular(8),
                                                        border:
                                                            Border.all(color: baseBorderColor, width: baseBorderWidth),
                                                        boxShadow: [
                                                          BoxShadow(
                                                              blurRadius: state.cards[index].isSpecial ? 32 : 4,
                                                              color: baseBorderColor,
                                                              offset: Offset(1, 2)),
                                                          // Kupa Papaz (K♥) için Altın Parlaklık efekti (Sadece özel kart ve etkisiz değilse)
                                                        ],
                                                      ),
                                                      width: 60,
                                                      height: 92,
                                                      child: Stack(
                                                        clipBehavior: Clip.none,
                                                        children: [
                                                          // Kart içeriği
                                                          Center(
                                                            child: Column(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                Text(state.cards[index].rank,
                                                                    style: const TextStyle(
                                                                        fontSize: 18, fontWeight: FontWeight.bold)),
                                                                const SizedBox(height: 6),
                                                                Text(state.cards[index].symbol,
                                                                    style: TextStyle(
                                                                        fontSize: 18,
                                                                        color: (state.cards[index].symbol == '♥' ||
                                                                                state.cards[index].symbol == '♦')
                                                                            ? Colors.red
                                                                            : Colors.black)),
                                                                const SizedBox(height: 6),
                                                                // Etkisiz kart değeri "0" olarak daha belirgin
                                                                Text(
                                                                  '${state.cards[index].value}',
                                                                  style: TextStyle(
                                                                    fontSize: 12,
                                                                    fontWeight: FontWeight.w900,
                                                                    color: Colors.red.shade800,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          // Etkisiz (Disabled) Overlay - Karo 2 (♦2) etkisi
                                                          // if (c.disabled)
                                                          //   // Mevcut sallanma animasyonunu koru ve üzerine X işareti ekle
                                                          //   TweenAnimationBuilder<double>(
                                                          //     tween: Tween(begin: -0.05, end: 0.05),
                                                          //     duration: const Duration(milliseconds: 400),
                                                          //     curve: Curves.easeInOut,
                                                          //     onEnd: () {
                                                          //       // Animasyonu sürekli ters yöne doğru tetiklemek için setState (basit bir loop)
                                                          //       if (mounted) setState(() {});
                                                          //     },
                                                          //     builder: (context, angle, child) {
                                                          //       return Transform.rotate(
                                                          //         angle: angle,
                                                          //         child: Container(
                                                          //           decoration: BoxDecoration(
                                                          //             color: Colors.grey
                                                          //                 .withOpacity(0.6), // Daha opak hale getir
                                                          //             borderRadius: BorderRadius.circular(8),
                                                          //             border: Border.all(color: Colors.redAccent, width: 3),
                                                          //           ),
                                                          //           child: Center(
                                                          //               child: Icon(Icons.close_rounded,
                                                          //                   size: 40,
                                                          //                   color: Colors.red.shade800)), // Kırmızı X
                                                          //         ),
                                                          //       );
                                                          //     },
                                                          //   ),
                                                          // Sinek 2 (♣2) - Takas Edilmiş İşareti
                                                          if (state.game.swappedCards!
                                                              .split(',')
                                                              .contains(state.cards[index].fullName))
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
                                                          if (state.game.disabledCards! == state.cards[index].fullName)
                                                            Positioned(
                                                              child: Container(
                                                                width: 60,
                                                                height: 92,
                                                                padding: const EdgeInsets.all(2),
                                                                decoration: const BoxDecoration(
                                                                  shape: BoxShape.circle,
                                                                ),
                                                                child: Placeholder(
                                                                  color: Colors.black26,
                                                                ),
                                                              ),
                                                            ),

                                                          state.game.swappedCards!.isNotEmpty &&
                                                                  state.cards[index].fullName == 'Sinek-2'
                                                              ? Positioned(
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
                                                                )
                                                              : SizedBox.shrink(),
                                                          // Kupa Papaz (K♥) - Çarpan İşareti
                                                          // if (c.isKingOfHearts && !c.disabled)
                                                          //   const Positioned(
                                                          //     bottom: 4,
                                                          //     left: 4,
                                                          //     child: Text('x2',
                                                          //         style: TextStyle(
                                                          //             fontSize: 16,
                                                          //             fontWeight: FontWeight.w900,
                                                          //             color: Colors.redAccent,
                                                          //             shadows: [
                                                          //               Shadow(
                                                          //                   blurRadius: 4,
                                                          //                   color: Colors.red,
                                                          //                   offset: Offset(1, 1))
                                                          //             ])),
                                                          //   )
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  )),
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
                    // Yorum Satırı: Eller Aç ve Özel Kartları Uygula butonu kaldırıldı ve otomatikleştirildi.
                    // if (!selectionPhase && !showHandResultOverlay && !showReadyOverlay) ...[
                    //   const SizedBox(height: 8),
                    //   ElevatedButton(
                    //       onPressed: _revealAndResolve, child: const Text('Eller Aç ve Özel Kartları Uygula')),
                    //   SizedBox(height: 30.h),
                    // ],
                    SizedBox(height: 30.h), // Butonun kapladığı alanı koru
                    BlocBuilder<HomeCubit, HomeState>(
                      builder: (context, state) {
                        if (state.getStatusState == GetStatusStates.completed && state.cards.isNotEmpty) {
                          return InfoProfile(
                            point: (state.cards
                                    .where((card) => card.fullName != state.game.disabledCards)
                                    .toList()
                                    .map((c) => c.value)
                                    .toList()
                                    .reduce((a, b) => a + b)) *
                                (widget.isPlayer1 ? state.player1Multiplier : state.player2Multiplier),
                            currentHand: currentHand,
                            maxHands: maxHands,
                            userWins: userHandWins,
                            oppWins: oppHandWins,
                            name: widget.isPlayer1
                                ? '${state.game.player1Name!} ${state.game.player1Surname!} ${state.player1Multiplier > 1 ? '(x${state.player1Multiplier})' : ''}'
                                : '${state.game.player2Name!} ${state.game.player2Surname!} ${state.player2Multiplier > 1 ? '(x${state.player2Multiplier})' : ''}',
                          );
                        } else {
                          return InfoProfile(
                              point: 0,
                              currentHand: currentHand,
                              maxHands: maxHands,
                              userWins: userHandWins,
                              oppWins: oppHandWins);
                        }
                      },
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ),

          // Yeni: El sonu sonuç overlay'i
          _buildHandResultOverlay(),

          // Yeni: El başlangıcı hazır olma overlay'i
          _buildReadyOverlay(),

          // YENİ: Info Mesaj Overlay'i
          _buildInfoMessageOverlay(),
        ],
      ),
    );
  }
}

class InfoProfile extends StatelessWidget {
  InfoProfile({
    super.key,
    required this.point,
    this.currentHand = 1,
    this.maxHands = 3,
    this.userWins = 0,
    this.oppWins = 0,
    this.name = '',
  });
  int? point;
  int currentHand;
  int maxHands;
  int userWins;
  int oppWins;
  String name;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 0.9.sw,
        height: 60.h,
        padding: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.yellowAccent, width: 2),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22.sp,
              backgroundColor: Colors.white,
              child: const Icon(Icons.person, color: Colors.grey),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // YENİ: Toplamı finalTotal() ile büyüt ve renklendir
                      Text('$name — ',
                          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.white)),
                      point != null
                          ? Text('$point', // *** DÜZELTİLDİ: finalTotal kullanılıyor
                              style: TextStyle(
                                  fontSize: 22.sp, // *** BÜYÜTÜLDÜ
                                  fontWeight: FontWeight.w900,
                                  color: Colors.amberAccent, // *** SOFT RENK
                                  shadows: [
                                    Shadow(
                                      blurRadius: 5.0,
                                      color: Colors.amber.withOpacity(0.8),
                                      offset: const Offset(1.0, 1.0),
                                    ),
                                  ]))
                          : Image.asset(
                              'assets/asset/lock.png',
                              height: 32,
                            ),
                      // Kupa Papaz x2 İşareti
                      // if (p.multiplier > 1.0)
                      //   Padding(
                      //     padding: const EdgeInsets.only(left: 8.0),
                      //     child: Text('x${p.multiplier.toInt()}',
                      //         style: TextStyle(
                      //           fontSize: 24.sp,
                      //           fontWeight: FontWeight.w900,
                      //           color: Colors.redAccent,
                      //           shadows: [
                      //             Shadow(
                      //               blurRadius: 5.0,
                      //               color: Colors.red.withOpacity(0.8),
                      //               offset: const Offset(1.0, 1.0),
                      //             ),
                      //           ],
                      //         )),
                      //   ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text('El $currentHand / $maxHands  • Skor: Siz $userWins - Bot $oppWins',
                      style: TextStyle(fontSize: 12.sp, color: Colors.white70)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
