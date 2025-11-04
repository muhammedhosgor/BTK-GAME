import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_base_app/feature/auth/login/model/game_model.dart';
import 'package:flutter_base_app/feature/home/model/card_model.dart';

class HomeState extends Equatable {
  HomeState({
    required this.homeState,
    required this.getStatusState,
    required this.makeMoveState,
    required this.finishState,
    required this.errorMessage,
    required this.message,
    required this.game,
    required this.selectedCardsToSwap,
    required this.cards,
    required this.player1Multiplier,
    required this.player2Multiplier,
    required this.opponentCards,
    required this.sinekVar,
    required this.karoVar,
    required this.isKupaPapazDialogShown,
    required this.isSinekDialogShown,
    required this.isKaroDialogShown,
    required this.isDialogShownValue,
    //! Player 2 Dialogs
    required this.isKupaPapaz2DialogShown,
    required this.isSinek2DialogShown,
    required this.isKaro2DialogShown,
    required this.isDialog2ShownValue,
    //!
    required this.isMoveFirstTime,
    required this.player1WinCount,
    required this.player2WinCount,
    required this.isSpecialEffectPlaying,
    required this.seconds,
  });

  factory HomeState.initial() {
    return HomeState(
      homeState: HomeStates.initial,
      makeMoveState: MakeMoveStates.initial,
      finishState: FinishStates.initial,
      getStatusState: GetStatusStates.initial,
      errorMessage: '',
      message: '',
      game: GameModel(),
      selectedCardsToSwap: [],
      cards: [],
      player1Multiplier: 1,
      player2Multiplier: 1,
      opponentCards: [],
      sinekVar: false,
      karoVar: false,
      isKupaPapazDialogShown: false,
      isSinekDialogShown: false,
      isKaroDialogShown: false,
      isDialogShownValue: false,
      //! Player 2 Dialogs
      isKupaPapaz2DialogShown: false,
      isSinek2DialogShown: false,
      isKaro2DialogShown: false,
      isDialog2ShownValue: false,
      //!
      isMoveFirstTime: true,
      player1WinCount: 0,
      player2WinCount: 0,
      isSpecialEffectPlaying: false,
      seconds: 15,
    );
  }

  final HomeStates homeState;
  final GetStatusStates getStatusState;
  final MakeMoveStates makeMoveState;
  final FinishStates finishState;
  final String errorMessage;
  final String message;
  final List<CardModel> selectedCardsToSwap;
  final List<CardModel> cards;

  GameModel game;
  final int player1Multiplier;
  final int player2Multiplier;
  final List<CardModel> opponentCards;
  final bool sinekVar;
  final bool karoVar;
  bool isKupaPapazDialogShown;
  bool isSinekDialogShown;
  bool isKaroDialogShown;
  bool isDialogShownValue;
  //! Player 2 Dialogs
  bool isKupaPapaz2DialogShown;
  bool isSinek2DialogShown;
  bool isKaro2DialogShown;
  bool isDialog2ShownValue;
  //!
  bool isMoveFirstTime;
  int player1WinCount;
  int player2WinCount;
  //
  final bool isSpecialEffectPlaying;
  int seconds;
  @override
  List<Object?> get props => [
        homeState,
        getStatusState,
        makeMoveState,
        finishState,
        errorMessage,
        message,
        game,
        selectedCardsToSwap,
        cards,
        player1Multiplier,
        player2Multiplier,
        opponentCards,
        sinekVar,
        karoVar,
        isKupaPapazDialogShown,
        isSinekDialogShown,
        isKaroDialogShown,
        isDialogShownValue,
        //! Player 2 Dialogs
        isKupaPapaz2DialogShown,
        isSinek2DialogShown,
        isKaro2DialogShown,
        isDialog2ShownValue,
        //!
        isMoveFirstTime,
        player1WinCount,
        player2WinCount,
        isSpecialEffectPlaying,
        seconds,
      ];

  HomeState copyWith({
    HomeStates? homeState,
    GetStatusStates? getStatusState,
    MakeMoveStates? makeMoveState,
    FinishStates? finishState,
    String? errorMessage,
    String? message,
    GameModel? game,
    List<CardModel>? selectedCardsToSwap,
    List<CardModel>? cards,
    int? player1Multiplier,
    int? player2Multiplier,
    List<CardModel>? opponentCards,
    bool? sinekVar,
    bool? karoVar,
    bool? isKupaPapazDialogShown,
    bool? isSinekDialogShown,
    bool? isKaroDialogShown,
    bool? isDialogShownValue,
    //! Player 2 Dialogs
    bool? isKupaPapaz2DialogShown,
    bool? isSinek2DialogShown,
    bool? isKaro2DialogShown,
    bool? isDialog2ShownValue,
    //!
    bool? isMoveFirstTime,
    int? player1WinCount,
    int? player2WinCount,
    bool? isSpecialEffectPlaying,
    int? seconds,
    //
  }) {
    return HomeState(
      homeState: homeState ?? this.homeState,
      getStatusState: getStatusState ?? this.getStatusState,
      makeMoveState: makeMoveState ?? this.makeMoveState,
      finishState: finishState ?? this.finishState,
      errorMessage: errorMessage ?? this.errorMessage,
      message: message ?? this.message,
      game: game ?? this.game,
      selectedCardsToSwap: selectedCardsToSwap ?? this.selectedCardsToSwap,
      cards: cards ?? this.cards,
      player1Multiplier: player1Multiplier ?? this.player1Multiplier,
      player2Multiplier: player2Multiplier ?? this.player2Multiplier,
      opponentCards: opponentCards ?? this.opponentCards,
      sinekVar: sinekVar ?? this.sinekVar,
      karoVar: karoVar ?? this.karoVar,
      isKupaPapazDialogShown: isKupaPapazDialogShown ?? this.isKupaPapazDialogShown,
      isSinekDialogShown: isSinekDialogShown ?? this.isSinekDialogShown,
      isKaroDialogShown: isKaroDialogShown ?? this.isKaroDialogShown,
      isDialogShownValue: isDialogShownValue ?? this.isDialogShownValue,
      //! Player 2 Dialogs
      isKupaPapaz2DialogShown: isKupaPapaz2DialogShown ?? this.isKupaPapaz2DialogShown,
      isSinek2DialogShown: isSinek2DialogShown ?? this.isSinek2DialogShown,
      isKaro2DialogShown: isKaro2DialogShown ?? this.isKaro2DialogShown,
      isDialog2ShownValue: isDialog2ShownValue ?? this.isDialog2ShownValue,
      //!
      isMoveFirstTime: isMoveFirstTime ?? this.isMoveFirstTime,
      player1WinCount: player1WinCount ?? this.player1WinCount,
      player2WinCount: player2WinCount ?? this.player2WinCount,
      isSpecialEffectPlaying: isSpecialEffectPlaying ?? this.isSpecialEffectPlaying,
      seconds: seconds ?? this.seconds,
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

enum FinishStates {
  initial,
  loading,
  completed,
  error,
}
