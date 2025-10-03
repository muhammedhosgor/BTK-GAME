import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_base_app/product/components/button/image_button.dart';
import 'package:flutter_base_app/product/constant/color_constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

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
  int selectionCount = 0; // seçim ekranında seçilenler (kullanılmadı ama bırakıldı)
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

// TickerProviderStateMixin eklendi — overlay animasyonlar için gerekli
class _CardGamePageState extends State<CardGamePage> with TickerProviderStateMixin {
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

  // Hazır mekanizması
  bool userReady = false;
  bool botReady = false;

  // Card keys for animation overlay
  late List<GlobalKey> userCardKeys;
  late List<GlobalKey> oppCardKeys;

  // Log scroll controller
  final ScrollController _logController = ScrollController();

  @override
  void initState() {
    super.initState();
    // initialize keys
    userCardKeys = List.generate(5, (_) => GlobalKey());
    oppCardKeys = List.generate(5, (_) => GlobalKey());
    _startNewMatch();
  }

  // --- MATCH START: Deck oluşturulur sadece burada (maç boyunca aynı desteden çekilir)
  void _startNewMatch() {
    currentHand = 1;
    userHandWins = 0;
    oppHandWins = 0;
    log = '';
    _appendLog('=== Yeni Maç Başladı ===');

    deck = Deck(); // sadece maç başında oluşturuldu (önemli revize)
    // Oyuncuları bir kere oluştur (eller maç boyunca aynı elden çekilecek)
    user = PlayerState(name: 'Siz', isBot: false);
    opponent = PlayerState(name: 'Bot', isBot: true);

    // İlk el için kartları dağıt
    _dealInitial();

    // Hazırlık (ready) sürecini başlat
    _prepareHandStart();
  }

  // Yeni el hazırlığı (her elde çağrılır). ÖNEMLİ: oyuncu/opp nesnelerini yeniden oluşturma! (eller saklanır)
  void _startNewHand() {
    // sıfırlamalar: multiplier el başında sıfırlanır, seçilenler sıfırlanır
    user.multiplier = 1.0;
    opponent.multiplier = 1.0;
    userSelected = List.filled(5, false);
    oppSelected = List.filled(5, false);

    selectionPhase = false; // hazır-olduktan sonra true olacak
    userTurnToSelect = true;
    _appendLog('--- El $currentHand başlıyor (Toplam $maxHands el) ---');

    _prepareHandStart();
  }

  // Her el başında hazır-durumu kur
  void _prepareHandStart() {
    userReady = false;
    botReady = false;
    setState(() {});
    // Bot otomatik hazır olur (rastgele 700-1400 ms)
    Future.delayed(Duration(milliseconds: 700 + Random().nextInt(700)), () {
      botReady = true;
      _appendLog('Bot hazır oldu.');
      setState(() {});
      _checkStartHand();
    });
  }

  // Her iki taraf da hazırsa el başlar (seçim fazı açılır)
  void _checkStartHand() {
    if (userReady && botReady) {
      _appendLog('Her iki taraf da hazır. Seçim fazı başlıyor.');
      // Küçük bir görsel gecikme ver
      Future.delayed(const Duration(milliseconds: 700), () {
        selectionPhase = true;
        userTurnToSelect = true;
        setState(() {});
      });
    }
  }

  void _dealInitial() {
    // Eğer eller zaten doluysa, tekrardan dağıtma (maç başındaki ilk deal için çalışır)
    if (user.hand.isNotEmpty || opponent.hand.isNotEmpty) return;
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
    if (indices.isEmpty) {
      _appendLog('Hiç kart seçilmedi.');
      return;
    }
    // limit: eğer destede kart kalmamışsa hata vermez, sadece kalan kadar değiştirir
    for (var i in indices) {
      if (deck.remaining() == 0) {
        _appendLog('Destede kart kalmadığı için daha fazla değişim yapılamıyor.');
        break;
      }
      user.hand[i] = deck.drawCard();
    }
    userSelected = List.filled(5, false);
    userTurnToSelect = false; // şimdi bot seçer
    setState(() {});
    // Bot seçimini hemen çalıştır (daha yavaş)
    Future.delayed(const Duration(milliseconds: 900), () => _botReplace());
  }

  void _botReplace() {
    // Bot rastgele 0-3 kart seçer ve değiştirir
    final rnd = Random();
    int toReplace = rnd.nextInt(4); // 0..3
    Set<int> chosen = {};
    while (chosen.length < toReplace) chosen.add(rnd.nextInt(5));
    for (var idx in chosen) {
      if (deck.remaining() == 0) break;
      opponent.hand[idx] = deck.drawCard();
      oppSelected[idx] = true;
    }
    // kısa süre sonra oppSelected'i temizle (sadece gösterim amaçlı değil)
    Future.delayed(const Duration(milliseconds: 900), () {
      oppSelected = List.filled(5, false);
      selectionPhase = false; // seçimler bitti
      setState(() {});
    });
    setState(() {});
  }

  // Reveal ve özel kart işleme
  void _revealAndResolve() async {
    if (selectionPhase) {
      _appendLog('Önce seçimler tamamlanmalı.');
      return; // önce seçimler tamamlanmalı
    }

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
      await Future.delayed(const Duration(milliseconds: 900));
      _showMatchResultDialog();
    } else {
      // Sonraki ele geçiş: round++ ve yeni el başlat
      currentHand++;
      await Future.delayed(const Duration(seconds: 1));
      _startNewHand(); // ÖNEMLİ: eller sıfırlanmıyor — sadece multipliers ve seçimler resetleniyor
    }
  }

  // ----- ÖZEL KART UYGULAMALARI -----
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
      await Future.delayed(const Duration(milliseconds: 900));
    }

    // Clubs 2: oyuncu kendi elinden seçtiği bir kart ile karşı oyuncunun elinden seçtiği bir kartı değiştirir
    for (var idx in clubs2Indices) {
      if (actor.isBot) {
        // bot rastgele seçer
        var rnd = Random();
        int myIdx = rnd.nextInt(actor.hand.length);
        int oppIdx = rnd.nextInt(target.hand.length);

        // Bot'un yaptığı değişimi animasyonlu göster (rakibin kartının bot eline doğru hareketi)
        await _animateCardTake(
            fromKey: oppCardKeyForIndex(oppIdx), // rakibin kartından alınıyor
            toKey: userCardKeyForIndex(myIdx), // bot kendi kartına koyuyormuş gibi göster (gösterim amaçlı)
            card: target.hand[oppIdx]);

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

          // Animasyon: rakibin kartı kullanıcının yerine doğru hareket etsin (görsel)
          await _animateCardTake(
              fromKey: oppCardKeyForIndex(oppIdx), toKey: userCardKeyForIndex(myIdx), card: target.hand[oppIdx]);

          var myCard = actor.hand[myIdx];
          var oppCard = target.hand[oppIdx];
          actor.hand[myIdx] = oppCard;
          target.hand[oppIdx] = myCard;
          _appendLog('Sinek 2 uygulandı: Siz ${myCard} ile Botun ${oppCard} ile yer değiştirdiniz.');
        } else {
          _appendLog('Sinek 2 atlandı (seçim yapılmadı).');
        }
      }
      await Future.delayed(const Duration(milliseconds: 900));
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
      await Future.delayed(const Duration(milliseconds: 900));
    }

    setState(() {});
  }

  // --- Kart alma animasyonu (overlay ile) ---
  // fromKey/toKey: GlobalKey'ler ile widget pozisyonları alınır, card gösterimi overlay'de hareket eder.
  Future<void> _animateCardTake(
      {required GlobalKey? fromKey, required GlobalKey? toKey, required PlayingCard card}) async {
    // Eğer key'ler yoksa model değişimini yapıp geri dön
    if (fromKey == null || toKey == null) return;

    final fromContext = fromKey.currentContext;
    final toContext = toKey.currentContext;
    if (fromContext == null || toContext == null) return;

    final fromBox = fromContext.findRenderObject() as RenderBox?;
    final toBox = toContext.findRenderObject() as RenderBox?;
    if (fromBox == null || toBox == null) return;

    final fromPos = fromBox.localToGlobal(Offset.zero);
    final toPos = toBox.localToGlobal(Offset.zero);

    final overlay = Overlay.of(context);
    if (overlay == null) return;

    final controller = AnimationController(duration: const Duration(milliseconds: 900), vsync: this);
    final animation = CurvedAnimation(parent: controller, curve: Curves.easeInOut);

    OverlayEntry? entry;
    entry = OverlayEntry(builder: (ctx) {
      return AnimatedBuilder(
        animation: animation,
        builder: (_, __) {
          final dx = lerpDouble(fromPos.dx, toPos.dx, animation.value)!;
          final dy = lerpDouble(fromPos.dy, toPos.dy, animation.value)!;
          return Positioned(
            left: dx,
            top: dy,
            child: Material(
              color: Colors.transparent,
              child: Opacity(
                opacity: 1.0 - (animation.value * 0.05),
                child: _overlayCardWidget(card),
              ),
            ),
          );
        },
      );
    });

    overlay.insert(entry);
    try {
      await controller.forward();
    } finally {
      entry.remove();
      controller.dispose();
    }
  }

  // Overlay'de gösterilecek basit kart widget
  Widget _overlayCardWidget(PlayingCard c) {
    return Container(
      width: 60,
      height: 90,
      decoration: BoxDecoration(
        color: c.disabled ? Colors.grey[300] : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black26, width: 1),
        boxShadow: const [BoxShadow(blurRadius: 6, color: Colors.black26, offset: Offset(2, 4))],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(c.rank, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(c.suitSymbol, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 6),
            Text('${c.disabled ? 0 : c.value}', style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
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

  // --- Kullanıcı seçim dialogları (aynı kod yapısı korunarak) ---
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
      final time = DateTime.now().toIso8601String().split('T').last.substring(0, 8);
      log = '$time - $s\n' + log;
    });
  }

  // Kart widget (orijinal yapıyı koruyarak)
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
                SizedBox(height: 6.h),

                // Hazır durumu göstergesi
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
                            label: Text('Bot: ${botReady ? "Hazır" : "Bekliyor"}'),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () {
                              if (!userReady) {
                                setState(() {
                                  userReady = true;
                                  _appendLog('Siz hazır oldunuz.');
                                });
                                _checkStartHand();
                              }
                            },
                            child: Text(userReady ? 'Hazır' : 'Hazırım'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 18.h),
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

              // container'a global key ver (animasyon için)
              final gw = p == user ? userCardKeys[i] : oppCardKeys[i];

              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
                child: GestureDetector(
                  key: ValueKey('${c.rank}${c.suitSymbol}${c.disabled}${p == user ? "u" : "o"}$i'),
                  onTap: () {
                    if (p == user) _toggleSelectUser(i);
                  },
                  child: Container(
                    key: gw,
                    margin: const EdgeInsets.symmetric(horizontal: 6),
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
    String lottiePath;
    if (userHandWins > oppHandWins) {
      overall = 'Maçın kazananı: Siz!';
      lottiePath = 'assets/lottie/win.json'; // konfeti, kupa animasyonu
    } else if (oppHandWins > userHandWins) {
      overall = 'Maçın kazananı: Bot!';
      lottiePath = 'assets/lottie/lose.json'; // üzgün surat, kırık kalp animasyonu
    } else {
      overall = 'Maç berabere!';
      lottiePath = 'assets/lottie/draw.json'; // el sıkışma vb.
    }

    await showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: "Result",
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (_, __, ___) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.6),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "3 El Tamamlandı",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: Lottie.asset(lottiePath, repeat: true),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '$overall\n\nSkor — Siz: $userHandWins  Bot: $oppHandWins',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          _startNewMatch();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.refresh, color: Colors.white),
                        label: const Text("Yeniden Başlat", style: TextStyle(color: Colors.white)),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.close, color: Colors.white),
                        label: const Text("Kapat", style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return Transform.scale(
          scale: Curves.easeOutBack.transform(anim.value),
          child: Opacity(
            opacity: anim.value,
            child: child,
          ),
        );
      },
    );
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
