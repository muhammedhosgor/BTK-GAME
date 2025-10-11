import 'dart:math';

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

//! DESTE
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
