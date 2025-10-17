class CardModel {
  String symbol;
  String rank;
  String fullName;
  int value;
  bool isSpecial;
  bool isDisabled;

  CardModel({
    required this.symbol,
    required this.rank,
    required this.fullName,
    required this.value,
    this.isSpecial = false,
    this.isDisabled = false,
  });
}
