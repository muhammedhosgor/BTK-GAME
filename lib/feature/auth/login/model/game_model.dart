class GameModel {
  int? id;
  String? guid;
  int? player1Id;
  int? player2Id;
  String? status;
  int? currentTurnId;
  String? player1Hand;
  String? player2Hand;
  String? playedCards;
  int? player1Score;
  int? player2Score;
  String? createdDate;
  bool? isActive;
  bool? isPlayer1Ready;
  bool? isPlayer2Ready;
  bool? isPlayer1Move;
  bool? isPlayer2Move;
  bool? turn;
  String? disabledCards;
  String? swappedCards;
  String? player1Name;
  String? player1Surname;
  String? player2Name;
  String? player2Surname;

  GameModel({
    this.id,
    this.guid,
    this.player1Id,
    this.player2Id,
    this.status,
    this.currentTurnId = 0,
    this.player1Hand,
    this.player2Hand,
    this.playedCards,
    this.player1Score,
    this.player2Score,
    this.createdDate,
    this.isActive,
    this.isPlayer1Ready,
    this.isPlayer2Ready,
    this.isPlayer1Move,
    this.isPlayer2Move,
    this.turn,
    this.disabledCards,
    this.swappedCards,
    this.player1Name,
    this.player1Surname,
    this.player2Name,
    this.player2Surname,
  });

  GameModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    guid = json['guid'];
    player1Id = json['player1Id'];
    player2Id = json['player2Id'];
    status = json['status'];
    currentTurnId = json['currentTurnId'] ?? 0;
    player1Hand = json['player1Hand'];
    player2Hand = json['player2Hand'];
    playedCards = json['playedCards'];
    player1Score = json['player1Score'];
    player2Score = json['player2Score'];
    createdDate = json['createdDate'];
    isActive = json['isActive'];
    isPlayer1Ready = json['isPlayer1Ready'];
    isPlayer2Ready = json['isPlayer2Ready'];
    isPlayer1Move = json['isPlayer1Move'];
    isPlayer2Move = json['isPlayer2Move'];
    turn = json['turn'];
    disabledCards = json['disabledCards'];
    swappedCards = json['swappedCards'];
    player1Name = json['player1Name'];
    player1Surname = json['player1Surname'];
    player2Name = json['player2Name'];
    player2Surname = json['player2Surname'];
  }
}
