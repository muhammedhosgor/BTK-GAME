import 'package:equatable/equatable.dart';
import 'package:flutter_base_app/feature/auth/login/model/game_model.dart';
import 'package:flutter_base_app/feature/home/model/card_model.dart';

class HomeState extends Equatable {
  HomeState({
    required this.homeState,
    required this.getStatusState,
    required this.makeMoveState,
    required this.errorMessage,
    required this.message,
    required this.game,
    required this.selectedCardsToSwap,
    required this.swapTurnFinished,
    required this.cards,
    required this.player1Multiplier,
    required this.player2Multiplier,
    required this.opponentCards,
    required this.sinekVar,
    required this.karoVar,
  });

  factory HomeState.initial() {
    return HomeState(
      homeState: HomeStates.initial,
      makeMoveState: MakeMoveStates.initial,
      getStatusState: GetStatusStates.initial,
      errorMessage: '',
      message: '',
      game: GameModel(),
      selectedCardsToSwap: [],
      swapTurnFinished: false,
      cards: [],
      player1Multiplier: 1,
      player2Multiplier: 1,
      opponentCards: [],
      sinekVar: false,
      karoVar: false,
    );
  }

  final HomeStates homeState;
  final GetStatusStates getStatusState;
  final MakeMoveStates makeMoveState;
  final String errorMessage;
  final String message;
  final List<CardModel> selectedCardsToSwap;
  final List<CardModel> cards;

  final bool swapTurnFinished;

  GameModel game;
  final int player1Multiplier;
  final int player2Multiplier;
  final List<CardModel> opponentCards;
  final bool sinekVar;
  final bool karoVar;

  @override
  List<Object?> get props => [
        homeState,
        getStatusState,
        makeMoveState,
        errorMessage,
        message,
        game,
        selectedCardsToSwap,
        swapTurnFinished,
        cards,
        player1Multiplier,
        player2Multiplier,
        opponentCards,
        sinekVar,
        karoVar,
      ];

  HomeState copyWith({
    HomeStates? homeState,
    GetStatusStates? getStatusState,
    MakeMoveStates? makeMoveState,
    String? errorMessage,
    String? message,
    GameModel? game,
    List<CardModel>? selectedCardsToSwap,
    bool? swapTurnFinished,
    List<CardModel>? cards,
    int? player1Multiplier,
    int? player2Multiplier,
    List<CardModel>? opponentCards,
    bool? sinekVar,
    bool? karoVar,
  }) {
    return HomeState(
      homeState: homeState ?? this.homeState,
      getStatusState: getStatusState ?? this.getStatusState,
      makeMoveState: makeMoveState ?? this.makeMoveState,
      errorMessage: errorMessage ?? this.errorMessage,
      message: message ?? this.message,
      game: game ?? this.game,
      selectedCardsToSwap: selectedCardsToSwap ?? this.selectedCardsToSwap,
      swapTurnFinished: swapTurnFinished ?? this.swapTurnFinished,
      cards: cards ?? this.cards,
      player1Multiplier: player1Multiplier ?? this.player1Multiplier,
      player2Multiplier: player2Multiplier ?? this.player2Multiplier,
      opponentCards: opponentCards ?? this.opponentCards,
      sinekVar: sinekVar ?? this.sinekVar,
      karoVar: karoVar ?? this.karoVar,
    );
  }
}

enum HomeStates {
  initial,
  loading,
  completed,
  error,
}

enum GetStatusStates {
  initial,
  loading,
  completed,
  error,
}

enum MakeMoveStates {
  initial,
  loading,
  completed,
  error,
}
