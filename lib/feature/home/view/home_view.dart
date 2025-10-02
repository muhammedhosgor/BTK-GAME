import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_base_app/product/components/button/image_button.dart';
import 'package:flutter_base_app/product/constant/color_constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum Suit { hearts, diamonds, clubs, spades }

class PlayingCard {
  final Suit suit;
  final String rank; // 'A', '2'..'10', 'J', 'Q', 'K'
  bool disabled = false; // Karo 2 ile etkisizleştirilirse true

  PlayingCard(this.suit, this.rank);

  String get suitSymbol {
    switch (suit) {
      case Suit.hearts:
        return '♥';
      case Suit.diamonds:
        return '♦';
      case Suit.clubs:
        return '♣';
      case Suit.spades:
        return '♠';
    }
  }

  int get value {
    if (disabled) return 0;
    if (rank == 'A') return 1;
    if (rank == 'J') return 11;
    if (rank == 'Q') return 12;
    if (rank == 'K') return 13;
    return int.tryParse(rank) ?? 0;
  }

  bool get isKingOfHearts => suit == Suit.hearts && rank == 'K';
  bool get isClubs2 => suit == Suit.clubs && rank == '2';
  bool get isDiamonds2 => suit == Suit.diamonds && rank == '2';

  @override
  String toString() => '$rank${suitSymbol}';
}

class Deck {
  final List<PlayingCard> _cards = [];
  final Random _rnd = Random();

  Deck() {
    final ranks = ['A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K'];
    for (var s in Suit.values) {
      for (var r in ranks) {
        _cards.add(PlayingCard(s, r));
      }
    }
    shuffle();
  }

  void shuffle() => _cards.shuffle(_rnd);

  PlayingCard drawCard() {
    if (_cards.isEmpty) throw Exception('Deck is empty');
    return _cards.removeLast();
  }

  int remaining() => _cards.length;
}

class PlayerState {
  List<PlayingCard> hand = [];
  int selectionCount = 0; // seçim ekranında seçilenler
  double multiplier = 1.0; // kupa papaz etkisi için
  String name;
  bool isBot;

  PlayerState({required this.name, this.isBot = false});

  int currentTotal() => hand.fold<int>(0, (p, c) => p + c.value);

  int finalTotal() => (currentTotal() * multiplier).round();
}

class CardGamePage extends StatefulWidget {
  const CardGamePage({super.key});

  @override
  State<CardGamePage> createState() => _CardGamePageState();
}

class _CardGamePageState extends State<CardGamePage> {
  late Deck deck;
  late PlayerState user;
  late PlayerState opponent;
  bool selectionPhase = true;
  bool userTurnToSelect = true; // kullanıcı önce seçer
  List<bool> userSelected = List.filled(5, false);
  List<bool> oppSelected = List.filled(5, false);
  String log = '';

  // Yeni: maç/elde sayacı
  int currentHand = 1;
  final int maxHands = 3; // 3 el oynanacak
  int userHandWins = 0;
  int oppHandWins = 0;

  @override
  void initState() {
    super.initState();
    _startNewMatch();
  }

  void _startNewMatch() {
    currentHand = 1;
    userHandWins = 0;
    oppHandWins = 0;
    log = '';
    _appendLog('=== Yeni Maç Başladı ===');

    _startNewHand();
  }

  void _startNewHand() {
    deck = Deck();
    user = PlayerState(name: 'Siz', isBot: false);
    opponent = PlayerState(name: 'Bot', isBot: true);
    userSelected = List.filled(5, false);
    oppSelected = List.filled(5, false);
    selectionPhase = true;
    userTurnToSelect = true;
    // Hand-specific flags
    log = '--- El $currentHand başlıyor (Toplam $maxHands el) ---\n' + log;
    _dealInitial();
  }

  void _dealInitial() {
    user.hand.clear();
    opponent.hand.clear();
    for (int i = 0; i < 5; i++) {
      user.hand.add(deck.drawCard());
      opponent.hand.add(deck.drawCard());
    }
    setState(() {});
  }

  void _toggleSelectUser(int idx) {
    if (!selectionPhase || !userTurnToSelect) return;
    int currentlySelected = userSelected.where((e) => e).length;
    if (!userSelected[idx] && currentlySelected >= 3) return; // en fazla 3
    setState(() {
      userSelected[idx] = !userSelected[idx];
    });
  }

  void _applyUserReplacement() {
    // seçili olanları deck'ten rastgele kartlarla değiştir
    List<int> indices = [];
    for (int i = 0; i < userSelected.length; i++) {
      if (userSelected[i]) indices.add(i);
    }
    for (var i in indices) {
      user.hand[i] = deck.drawCard();
    }
    userSelected = List.filled(5, false);
    userTurnToSelect = false; // şimdi bot seçer
    setState(() {});
    // Bot seçimini hemen çalıştır
    Future.delayed(const Duration(milliseconds: 350), () => _botReplace());
  }

  void _botReplace() {
    // Bot rastgele 0-3 kart seçer ve değiştirir
    final rnd = Random();
    int toReplace = rnd.nextInt(4); // 0..3
    Set<int> chosen = {};
    while (chosen.length < toReplace) chosen.add(rnd.nextInt(5));
    for (var idx in chosen) {
      opponent.hand[idx] = deck.drawCard();
      oppSelected[idx] = true;
    }
    // kısa süre sonra oppSelected'i temizle (sadece gösterim amaçlı değil)
    Future.delayed(const Duration(milliseconds: 600), () {
      oppSelected = List.filled(5, false);
      selectionPhase = false; // seçimler bitti
      setState(() {});
    });
    setState(() {});
  }

  // Reveal ve özel kart işleme
  void _revealAndResolve() async {
    if (selectionPhase) return; // önce seçimler tamamlanmalı

    // İlk olarak eller açılmadan önce kim başlayacak onu belirleyelim: "eller ilk açıldığında"ki toplam
    int userInitial = user.currentTotal();
    int oppInitial = opponent.currentTotal();
    bool userStarts = userInitial >= oppInitial; // eşitlikte kullanıcı başlar

    _appendLog(
        'Eller açıldı. Başlangıç toplamları: Siz=$userInitial, Bot=$oppInitial. ${userStarts ? 'Siz' : 'Bot'} başlıyor.');

    // Özel kartların uygulanması sırası
    if (userStarts) {
      await _applySpecialsForPlayer(user, opponent);
      await _applySpecialsForPlayer(opponent, user);
    } else {
      await _applySpecialsForPlayer(opponent, user);
      await _applySpecialsForPlayer(user, opponent);
    }

    // Son toplamı hesapla
    int userFinal = user.finalTotal();
    int oppFinal = opponent.finalTotal();

    _appendLog('Son durum: Siz=${userFinal}, Bot=${oppFinal}.');

    String result;
    if (userFinal > oppFinal) {
      result = 'Kazanan bu el: Siz!';
      userHandWins++;
    } else if (oppFinal > userFinal) {
      result = 'Kazanan bu el: Bot!';
      oppHandWins++;
    } else {
      result = 'Bu el berabere!';
    }

    _appendLog(result);

    setState(() {});

    // Maçın 3 el olarak oynanması: eğer en son else toplam kazananı göster
    if (currentHand >= maxHands) {
      await Future.delayed(const Duration(milliseconds: 400));
      _showMatchResultDialog();
    } else {
      // Sonraki ele geçiş: round++ ve yeni el başlat
      currentHand++;
      await Future.delayed(const Duration(seconds: 1));
      _startNewHand();
    }
  }

  Future<void> _applySpecialsForPlayer(PlayerState actor, PlayerState target) async {
    // actor sahip olduğu özel kartları tespit et ve sırayla uygula
    // Uygulama sırası: Kupa Papaz (King hearts) -> Sinek 2 (Clubs 2) -> Karo 2 (Diamonds 2)
    List<int> kingIndices = [];
    List<int> clubs2Indices = [];
    List<int> diamonds2Indices = [];

    for (int i = 0; i < actor.hand.length; i++) {
      var c = actor.hand[i];
      if (c.isKingOfHearts) kingIndices.add(i);
      if (c.isClubs2) clubs2Indices.add(i);
      if (c.isDiamonds2) diamonds2Indices.add(i);
    }

    // King of Hearts: oyuncunun elindeki kartların toplamını 2 ile çarpar
    for (var idx in kingIndices) {
      actor.multiplier *= 2;
      _appendLog('${actor.name} Kupa Papaz (K♥) kullandı. Toplamı 2 ile çarpıldı.');
      await Future.delayed(const Duration(milliseconds: 400));
    }

    // Clubs 2: oyuncu kendi elinden seçtiği bir kart ile karşı oyuncunun elinden seçtiği bir kartı değiştirir
    for (var idx in clubs2Indices) {
      if (actor.isBot) {
        // bot rastgele seçer
        var rnd = Random();
        int myIdx = rnd.nextInt(actor.hand.length);
        int oppIdx = rnd.nextInt(target.hand.length);
        var myCard = actor.hand[myIdx];
        var oppCard = target.hand[oppIdx];
        actor.hand[myIdx] = oppCard;
        target.hand[oppIdx] = myCard;
        _appendLog('Bot Sinek 2 (♣2) kullandı: Bot elindeki ${myCard} ile sizin ${oppCard} ile yer değiştirdi.');
      } else {
        // kullanıcıdan seçim iste
        _appendLog('Sinek 2 (♣2) kullanıldı. Lütfen elinizden bir kart ve rakibin elinden bir kart seçin.');
        var pair = await _askUserToPickTwoCards(actor.hand, target.hand, 'Sinek 2: Kendi ve rakibin kartını seçin');
        if (pair != null) {
          int myIdx = pair[0];
          int oppIdx = pair[1];
          var myCard = actor.hand[myIdx];
          var oppCard = target.hand[oppIdx];
          actor.hand[myIdx] = oppCard;
          target.hand[oppIdx] = myCard;
          _appendLog('Sinek 2 uygulandı: Siz ${myCard} ile Botun ${oppCard} ile yer değiştirdiniz.');
        } else {
          _appendLog('Sinek 2 atlandı (seçim yapılmadı).');
        }
      }
      await Future.delayed(const Duration(milliseconds: 400));
    }

    // Diamonds 2: oyuncu rakip oyuncunun elinden seçtiği bir kartı etkisiz hale getirir.
    for (var idx in diamonds2Indices) {
      if (actor.isBot) {
        var rnd = Random();
        int oppIdx = rnd.nextInt(target.hand.length);
        target.hand[oppIdx].disabled = true;
        _appendLog('Bot Karo 2 (♦2) kullandı: Sizin ${target.hand[oppIdx]} etkisiz hale getirildi.');
      } else {
        _appendLog('Karo 2 (♦2) kullanıldı. Lütfen rakibin elinden etkisizleştirmek istediğiniz kartı seçin.');
        int? oppIdx = await _askUserToPickOneCard(target.hand, 'Karo 2: Rakibin etkisiz olacak kartını seçin');
        if (oppIdx != null) {
          target.hand[oppIdx].disabled = true;
          _appendLog('Karo 2 uygulandı: Botun ${target.hand[oppIdx]} etkisiz hale getirildi.');
        } else {
          _appendLog('Karo 2 atlandı (seçim yapılmadı).');
        }
      }
      await Future.delayed(const Duration(milliseconds: 400));
    }

    setState(() {});
  }

  Future<List<int>?> _askUserToPickTwoCards(List<PlayingCard> myHand, List<PlayingCard> oppHand, String title) async {
    // Basit dialog: iki aşamada seçim alınır
    int? myPick;
    int? oppPick;

    // Kullanıcının kendi kartını seçmesi
    myPick = await showDialog<int>(
        context: context,
        builder: (ctx) {
          return SimpleDialog(
            title: Text('$title — Kendi kartınızdan seçin'),
            children: List.generate(myHand.length, (i) {
              return SimpleDialogOption(
                onPressed: () => Navigator.pop(ctx, i),
                child: Text('[$i] ${myHand[i]} ${myHand[i].disabled ? '(etkisiz)' : ''}'),
              );
            }),
          );
        });
    if (myPick == null) return null;

    oppPick = await showDialog<int>(
        context: context,
        builder: (ctx) {
          return SimpleDialog(
            title: Text('$title — Rakibin kartından seçin'),
            children: List.generate(oppHand.length, (i) {
              return SimpleDialogOption(
                onPressed: () => Navigator.pop(ctx, i),
                child: Text('[$i] ${oppHand[i]} ${oppHand[i].disabled ? '(etkisiz)' : ''}'),
              );
            }),
          );
        });
    if (oppPick == null) return null;

    return [myPick, oppPick];
  }

  Future<int?> _askUserToPickOneCard(List<PlayingCard> hand, String title) async {
    int? pick = await showDialog<int>(
        context: context,
        builder: (ctx) {
          return SimpleDialog(
            title: Text(title),
            children: List.generate(hand.length, (i) {
              return SimpleDialogOption(
                onPressed: () => Navigator.pop(ctx, i),
                child: Text('[$i] ${hand[i]} ${hand[i].disabled ? '(etkisiz)' : ''}'),
              );
            }),
          );
        });
    return pick;
  }

  void _appendLog(String s) {
    setState(() {
      log = '${DateTime.now().toIso8601String().split('T').last.substring(0, 8)} - $s\n' + log;
    });
  }

  Widget _buildCardWidget(PlayingCard c, bool selected, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
        margin: EdgeInsets.only(top: selected ? 0 : 8),
        transform: Matrix4.translationValues(0, selected ? -14 : 0, 0),
        decoration: BoxDecoration(
          color: c.disabled ? Colors.grey[300] : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: selected ? Colors.blue : Colors.black26, width: selected ? 2 : 1),
          boxShadow: const [BoxShadow(blurRadius: 4, color: Colors.black12, offset: Offset(1, 2))],
        ),
        width: 55,
        height: 85,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(c.rank, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text(c.suitSymbol,
                  style: TextStyle(
                      fontSize: 18,
                      color: (c.suit == Suit.hearts || c.suit == Suit.diamonds) ? Colors.red : Colors.black)),
              const SizedBox(height: 6),
              Text('${c.disabled ? 0 : c.value}', style: const TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }

  final ScrollController _logController = ScrollController();
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
      body: Container(
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ImageButton(onTap: _startNewMatch, imagePath: 'assets/asset/refresh.png'),
                    SizedBox(width: 10.w),
                  ],
                ),
                SizedBox(height: 30.h),
                InfoProfile(
                    p: opponent,
                    currentHand: currentHand,
                    maxHands: maxHands,
                    userWins: userHandWins,
                    oppWins: oppHandWins),
                const Spacer(),
                _buildHandRow(opponent, isTop: true),
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
                    child: Text('${deck.remaining()} kart',
                        style: TextStyle(color: kTableNavy, fontSize: 20.sp, fontWeight: FontWeight.bold)),
                  )),
                ),
                if (selectionPhase && userTurnToSelect)
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 15.h),
                        Text('Kart değişimi: En fazla 3 kart seçebilirsiniz.',
                            style: TextStyle(color: kWhiteColor, fontSize: 16.sp)),
                        const SizedBox(height: 6),
                        ElevatedButton(
                          onPressed: () {
                            _applyUserReplacement();
                          },
                          child: const Text('Seçili kartları değiştir'),
                        ),
                      ]),
                _buildHandRow(user, isTop: false),
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
                          if (line.toLowerCase().contains("kullanıcı")) {
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
                if (!selectionPhase) ...[
                  const SizedBox(height: 8),
                  ElevatedButton(onPressed: _revealAndResolve, child: const Text('Eller Aç ve Özel Kartları Uygula')),
                  SizedBox(height: 30.h),
                ],
                InfoProfile(
                    p: user,
                    currentHand: currentHand,
                    maxHands: maxHands,
                    userWins: userHandWins,
                    oppWins: oppHandWins),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHandRow(PlayerState p, {required bool isTop}) {
    bool showFace = !selectionPhase;
    bool isCurrentTurn =
        (p == user && userTurnToSelect && selectionPhase) || (p == opponent && !userTurnToSelect && selectionPhase);

    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            border: Border.all(
              color: isCurrentTurn ? Colors.yellowAccent : Colors.transparent,
              width: isCurrentTurn ? 4 : 0,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: isCurrentTurn
                ? [BoxShadow(color: Colors.yellow.withOpacity(0.7), blurRadius: 20, spreadRadius: 2)]
                : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(p.hand.length, (i) {
              var c = p.hand[i];
              bool selected = p == user ? userSelected[i] : oppSelected[i];
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
                child: GestureDetector(
                  key: ValueKey('${c.rank}${c.suitSymbol}${c.disabled}'),
                  onTap: () {
                    if (p == user) _toggleSelectUser(i);
                  },
                  child: showFace || p == user
                      ? _buildCardWidget(c, selected, onTap: () {
                          if (p == user) _toggleSelectUser(i);
                        })
                      : Container(
                          width: 50,
                          height: 70,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: const DecorationImage(
                              image: AssetImage('assets/asset/lock.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Future<void> _showMatchResultDialog() async {
    String overall;
    if (userHandWins > oppHandWins)
      overall = 'Maçın kazananı: Siz!';
    else if (oppHandWins > userHandWins)
      overall = 'Maçın kazananı: Bot!';
    else
      overall = 'Maç berabere!';

    await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (ctx) {
          return AlertDialog(
            title: const Text('3 El Tamamlandı'),
            content: Text('$overall\n\nSkor — Siz: $userHandWins  Bot: $oppHandWins'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    // Maçı sıfırla ve yeni maç başlat

                    _startNewMatch();
                  },
                  child: const Text('Yeniden Başlat')),
              TextButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    // sadece yeni el başlatmak istemiyorsak maçı sonlandırılmış bırakabiliriz
                    // burada yeni el başlatma yerine mevcut durumu tutuyoruz
                  },
                  child: const Text('Kapat')),
            ],
          );
        });
  }
}

class InfoProfile extends StatelessWidget {
  InfoProfile({
    super.key,
    required this.p,
    this.currentHand = 1,
    this.maxHands = 3,
    this.userWins = 0,
    this.oppWins = 0,
  });
  PlayerState p;
  int currentHand;
  int maxHands;
  int userWins;
  int oppWins;
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
                  Text('${p.name} — Toplam: ${p.currentTotal()}  (multiplier: ${p.multiplier}x)',
                      style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.white)),
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
