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

  GameModel(
      {this.id,
      this.guid,
      this.player1Id,
      this.player2Id,
      this.status,
      this.currentTurnId,
      this.player1Hand,
      this.player2Hand,
      this.playedCards,
      this.player1Score,
      this.player2Score,
      this.createdDate,
      this.isActive});

  GameModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    guid = json['guid'];
    player1Id = json['player1Id'];
    player2Id = json['player2Id'];
    status = json['status'];
    currentTurnId = json['currentTurnId'];
    player1Hand = json['player1Hand'];
    player2Hand = json['player2Hand'];
    playedCards = json['playedCards'];
    player1Score = json['player1Score'];
    player2Score = json['player2Score'];
    createdDate = json['createdDate'];
    isActive = json['isActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['guid'] = this.guid;
    data['player1Id'] = this.player1Id;
    data['player2Id'] = this.player2Id;
    data['status'] = this.status;
    data['currentTurnId'] = this.currentTurnId;
    data['player1Hand'] = this.player1Hand;
    data['player2Hand'] = this.player2Hand;
    data['playedCards'] = this.playedCards;
    data['player1Score'] = this.player1Score;
    data['player2Score'] = this.player2Score;
    data['createdDate'] = this.createdDate;
    data['isActive'] = this.isActive;
    return data;
  }
}
