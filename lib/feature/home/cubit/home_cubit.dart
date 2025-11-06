import 'dart:async';

import 'package:flutter_base_app/core/network/network_manager/network_manager.dart';
import 'package:flutter_base_app/feature/auth/login/model/game_model.dart';
import 'package:flutter_base_app/feature/home/model/card_model.dart';
import 'package:flutter_base_app/feature/home/service/home_service.dart';
import 'package:flutter_base_app/feature/home/service/i_home_service.dart';
import 'package:flutter_base_app/product/injector/injector.dart';
import 'package:flutter_base_app/product/storage/local_get_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState.initial()) {
    init();
  }

  final IHomeService _homeService = HomeService(NetworkManager.instance);
  Timer? timer;

  Future<void> init() async {}

  void setStateToLoading() {
    emit(state.copyWith(getStatusState: GetStatusStates.loading));
  }

  bool isFirstTime = true;

  Future<void> getInitialStatusGame() async {
    injector.get<LocalStorage>().getInt('userId'); //?
    LocalStorage localStorage = injector.get<LocalStorage>();

    int? gameId = localStorage.getInt('createGameId') ?? localStorage.getInt('joinGameId');
    print("GAME ID HOME CUBIT: $gameId");

    final response = await _homeService.status(gameId!);
    // final response = await _homeService.status(1);

    if (response == null) {
      emit(
        state.copyWith(
          getStatusState: GetStatusStates.error,
          message: 'Veriler yüklenemedi. Lütfen internet bağlantınızı kontrol ediniz...',
        ),
      );
    } else {
      if (response.success!) {
        int? userId = await injector.get<LocalStorage>().getInt('userId');
        GameModel.fromJson(response.data as Map<String, dynamic>).player1Id;
        bool isPlayer1 = false;
        if (userId == GameModel.fromJson(response.data as Map<String, dynamic>).player1Id) {
          isPlayer1 = true;
        } else {
          isPlayer1 = false;
        }
        List<CardModel> playerCards = [];
        List<CardModel> opponentCards = [];

        for (var element in (isPlayer1
            ? GameModel.fromJson(response.data as Map<String, dynamic>).player1Hand!.split(',')
            : GameModel.fromJson(response.data as Map<String, dynamic>).player2Hand!.split(','))) {
          String symbol = '';
          switch (element.split('-')[0]) {
            case 'Karo':
              symbol = '♦';
              break;
            case 'Kupa':
              symbol = '♥';
              break;
            case 'Maça':
              symbol = '♠';
              break;
            case 'Sinek':
              symbol = '♣';
            default:
          }
          bool isSpecialCard = element == 'Kupa-K' || element == 'Sinek-2' || element == 'Karo-2';

          print('symbol: $symbol');
          print(element);
          print('isSpecialCard: $isSpecialCard');
          String rank = element.split('-')[1];
          print('rank: $rank');
          int value = 0;
          switch (element.split('-')[1]) {
            case 'A':
              value = 11;
              break;
            case '2':
              value = 2;
              break;
            case '3':
              value = 3;
              break;
            case '4':
              value = 4;
              break;
            case '5':
              value = 5;
              break;
            case '6':
              value = 6;
              break;
            case '7':
              value = 7;
              break;
            case '8':
              value = 8;
              break;
            case '9':
              value = 9;
              break;
            case '10':
              value = 10;
              break;
            case 'J':
              value = 10;
              break;
            case 'Q':
              value = 10;
              break;
            case 'K':
              value = 10;
              break;

            default:
          }
          playerCards.add(
            CardModel(
              fullName: element,
              symbol: symbol,
              rank: rank,
              value: value,
              isSpecial: isSpecialCard,
            ),
          );
        }

        for (var element in (isPlayer1
            ? GameModel.fromJson(response.data as Map<String, dynamic>).player2Hand!.split(',')
            : GameModel.fromJson(response.data as Map<String, dynamic>).player1Hand!.split(','))) {
          String symbol = '';
          switch (element.split('-')[0]) {
            case 'Karo':
              symbol = '♦';
              break;
            case 'Kupa':
              symbol = '♥';
              break;
            case 'Maça':
              symbol = '♠';
              break;
            case 'Sinek':
              symbol = '♣';
            default:
          }
          bool isSpecialCard = element == 'Kupa-K' || element == 'Sinek-2' || element == 'Karo-2';
          print('symbol: $symbol');
          print(element);
          print('isSpecialCard: $isSpecialCard');
          String rank = element.split('-')[1];
          print('rank: $rank');
          int value = 0;
          switch (element.split('-')[1]) {
            case 'A':
              value = 11;
              break;
            case '2':
              value = 2;
              break;
            case '3':
              value = 3;
              break;
            case '4':
              value = 4;
              break;
            case '5':
              value = 5;
              break;
            case '6':
              value = 6;
              break;
            case '7':
              value = 7;
              break;
            case '8':
              value = 8;
              break;
            case '9':
              value = 9;
              break;
            case '10':
              value = 10;
              break;
            case 'J':
              value = 10;
              break;
            case 'Q':
              value = 10;
              break;
            case 'K':
              value = 10;
              break;

            default:
          }
          opponentCards.add(
            CardModel(
              fullName: element,
              symbol: symbol,
              rank: rank,
              value: value,
              isSpecial: isSpecialCard,
            ),
          );
        }
        emit(
          state.copyWith(
            getStatusState: GetStatusStates.completed,
            game: GameModel.fromJson(response.data as Map<String, dynamic>),
            cards: playerCards,
            opponentCards: opponentCards,
          ),
        );
      } else {
        emit(state.copyWith(
          getStatusState: GetStatusStates.error,
          message: response.errorMessage ?? 'Bir Hata Oluştu!',
        ));
      }
    }
  }

  void selectCard(CardModel card) {
    if (state.selectedCardsToSwap.map((c) => c.fullName).toList().contains((card.fullName))) {
      print('İÇERİYOR');

      List<CardModel> updatedList = List.from(state.selectedCardsToSwap);
      updatedList.removeWhere((c) => c.fullName == card.fullName);
      print('SİLİNDİ');

      emit(state.copyWith(
        selectedCardsToSwap: updatedList,
      ));
      return;
    } else {
      print('İÇERMİYOR');
      if (state.selectedCardsToSwap.length < 3) {
        print('3 DEN KÜÇÜK - EKLENDİ');

        emit(state.copyWith(
          selectedCardsToSwap: [...state.selectedCardsToSwap, card],
        ));
      }
    }
  }

  void clearSelectedCards() {
    emit(state.copyWith(
      selectedCardsToSwap: [],
    ));
  }

  void cancelTimer() {
    timer!.cancel();
  }

  Future<void> setPlayerReady(int gameId, bool isPlayer1) async {
    emit(state.copyWith(homeState: HomeStates.loading));
    final response = await _homeService.setPlayerReady(gameId, isPlayer1);

    if (response == null) {
      emit(
        state.copyWith(
          homeState: HomeStates.error,
          message: 'Veriler yüklenemedi. Lütfen internet bağlantınızı kontrol ediniz...',
        ),
      );
    } else {
      if (response.success!) {
        emit(state.copyWith(homeState: HomeStates.completed, message: response.data.toString()));
      } else {
        emit(state.copyWith(
          homeState: HomeStates.error,
          errorMessage: response.message ?? 'Bir Hata Oluştu!',
        ));
      }
    }
  }

  Future<void> swapCards(int gameId, int playerId, bool move, String cardValue) async {
    print('SWAPLIYORUM $cardValue');
    emit(state.copyWith(makeMoveState: MakeMoveStates.loading));
    final response = await _homeService.makeMove(gameId, playerId, move, cardValue);

    if (response == null) {
      emit(
        state.copyWith(
          makeMoveState: MakeMoveStates.error,
          message: 'Veriler yüklenemedi. Lütfen internet bağlantınızı kontrol ediniz...',
        ),
      );
    } else {
      if (response.success!) {
        int? userId = await injector.get<LocalStorage>().getInt('userId');
        GameModel.fromJson(response.data as Map<String, dynamic>).player1Id;
        bool isPlayer1 = false;
        if (userId == GameModel.fromJson(response.data['tblVeri'] as Map<String, dynamic>).player1Id) {
          isPlayer1 = true;
        } else {
          isPlayer1 = false;
        }
        List<CardModel> playerCards = [];
        List<CardModel> opponentCards = [];

        for (var element in (isPlayer1
            ? GameModel.fromJson(response.data['tblVeri'] as Map<String, dynamic>).player1Hand!.split(',')
            : GameModel.fromJson(response.data['tblVeri'] as Map<String, dynamic>).player2Hand!.split(','))) {
          String symbol = '';
          switch (element.split('-')[0]) {
            case 'Karo':
              symbol = '♦';
              break;
            case 'Kupa':
              symbol = '♥';
              break;
            case 'Maça':
              symbol = '♠';
              break;
            case 'Sinek':
              symbol = '♣';
            default:
          }
          bool isSpecialCard = element == 'Kupa-K' || element == 'Sinek-2' || element == 'Karo-2';
          print('symbol: $symbol');
          print(element);
          print('isSpecialCard: $isSpecialCard');
          String rank = element.split('-')[1];
          print('rank: $rank');
          int value = 0;
          switch (element.split('-')[1]) {
            case 'A':
              value = 11;
              break;
            case '2':
              value = 2;
              break;
            case '3':
              value = 3;
              break;
            case '4':
              value = 4;
              break;
            case '5':
              value = 5;
              break;
            case '6':
              value = 6;
              break;
            case '7':
              value = 7;
              break;
            case '8':
              value = 8;
              break;
            case '9':
              value = 9;
              break;
            case '10':
              value = 10;
              break;
            case 'J':
              value = 10;
              break;
            case 'Q':
              value = 10;
              break;
            case 'K':
              value = 10;
              break;

            default:
          }
          playerCards.add(
            CardModel(
              fullName: element,
              symbol: symbol,
              rank: rank,
              value: value,
              isSpecial: isSpecialCard,
            ),
          );
        }

        for (var element in (isPlayer1
            ? GameModel.fromJson(response.data['tblVeri'] as Map<String, dynamic>).player2Hand!.split(',')
            : GameModel.fromJson(response.data['tblVeri'] as Map<String, dynamic>).player1Hand!.split(','))) {
          String symbol = '';
          switch (element.split('-')[0]) {
            case 'Karo':
              symbol = '♦';
              break;
            case 'Kupa':
              symbol = '♥';
              break;
            case 'Maça':
              symbol = '♠';
              break;
            case 'Sinek':
              symbol = '♣';
            default:
          }
          bool isSpecialCard = element == 'Kupa-K' || element == 'Sinek-2' || element == 'Karo-2';
          print('symbol: $symbol');
          print(element);
          print('isSpecialCard: $isSpecialCard');
          String rank = element.split('-')[1];
          print('rank: $rank');
          int value = 0;
          switch (element.split('-')[1]) {
            case 'A':
              value = 11;
              break;
            case '2':
              value = 2;
              break;
            case '3':
              value = 3;
              break;
            case '4':
              value = 4;
              break;
            case '5':
              value = 5;
              break;
            case '6':
              value = 6;
              break;
            case '7':
              value = 7;
              break;
            case '8':
              value = 8;
              break;
            case '9':
              value = 9;
              break;
            case '10':
              value = 10;
              break;
            case 'J':
              value = 10;
              break;
            case 'Q':
              value = 10;
              break;
            case 'K':
              value = 10;
              break;

            default:
          }
          opponentCards.add(
            CardModel(
              fullName: element,
              symbol: symbol,
              rank: rank,
              value: value,
              isSpecial: isSpecialCard,
            ),
          );
        }
        emit(
          state.copyWith(
            getStatusState: GetStatusStates.completed,
            game: GameModel.fromJson(response.data['tblVeri'] as Map<String, dynamic>),
            cards: playerCards,
            opponentCards: opponentCards,
          ),
        );
      } else {
        emit(state.copyWith(
          makeMoveState: MakeMoveStates.error,
          errorMessage: response.message ?? 'Bir Hata Oluştu!',
        ));
      }
    }
  }

  Future<void> disableCards(int gameId, String disabledCards) async {
    await _homeService.disableCards(gameId, disabledCards);
  }

  Future<void> sinekle(int gameId, String swappedCards) async {
    await _homeService.sinekle(gameId, swappedCards);
  }

  void setPlayerMultipliers(int player1Multiplier, int player2Multiplier) {
    emit(state.copyWith(
      player1Multiplier: player1Multiplier,
      player2Multiplier: player2Multiplier,
    ));
  }

  void setSinekVar(bool value) {
    emit(state.copyWith(
      sinekVar: value,
    ));
  }

  void setKaroVar(bool value) {
    emit(state.copyWith(
      karoVar: value,
    ));
  }

  //!Player 2 Dialogs

  void setIsKupaPapazDialogShown(bool value) {
    emit(state.copyWith(
      isKupaPapazDialogShown: value,
    ));
  }

  void setIsSinekDialogShown(bool value) {
    emit(state.copyWith(
      isSinekDialogShown: value,
    ));
  }

  void setIsKaroDialogShown(bool value) {
    emit(state.copyWith(
      isKaroDialogShown: value,
    ));
  }

  void setIsDialogShownValue(bool value) {
    emit(state.copyWith(
      isDialogShownValue: value,
    ));
  }

  //! Player 2 Dialogs
  void setIsKupaPapaz2DialogShown(bool value) {
    emit(state.copyWith(
      isKupaPapaz2DialogShown: value,
    ));
  }

  void setIsSinek2DialogShown(bool value) {
    emit(state.copyWith(
      isSinek2DialogShown: value,
    ));
  }

  void setIsKaro2DialogShown(bool value) {
    emit(state.copyWith(
      isKaro2DialogShown: value,
    ));
  }

  void setIsDialog2ShownValue(bool value) {
    emit(state.copyWith(
      isDialog2ShownValue: value,
    ));
  }

  Future<void> handComplete(int gameId) async {
    await _homeService.handComplete(gameId);
  }

  void setIsMoveFirstTime(bool value) {
    emit(state.copyWith(isMoveFirstTime: value));
  }

  void resetHandComplete() {
    emit(state.copyWith(
      sinekVar: false,
      karoVar: false,
      player1Multiplier: 1,
      player2Multiplier: 1,
      isKaroDialogShown: false,
      isKaro2DialogShown: false,
      isSinekDialogShown: false,
      isSinek2DialogShown: false,
      isKupaPapazDialogShown: false,
      isKupaPapaz2DialogShown: false,
      isDialogShownValue: false,
      isDialog2ShownValue: false,
      selectedCardsToSwap: [],
    ));
  }

  void determineWinner(bool isPlayer1) {
    int player1Score = 0;
    int player2Score = 0;

    // 🧮 Player 1 Skoru Hesapla
    if (isPlayer1) {
      for (var card in state.cards) {
        // Eğer kart devre dışı değilse, değerini ekle
        if (card.fullName != state.game.disabledCards) {
          player1Score += card.value;
        }
        // Eğer kart devre dışıysa (örneğin özel kart tarafından iptal edildiyse)
        else {
          // Devre dışı kartın değeri kadar eksilt (puan düş)
          player1Score -= card.value;
        }
        print("Player 1 cards: ${card.fullName}");
      }

      // 🧮 Player 2 Skoru Hesapla
      for (var card in state.opponentCards) {
        if (card.fullName != state.game.disabledCards) {
          player2Score += card.value;
        } else {
          player2Score -= card.value;
        }
        print("Player 2 cards: ${card.fullName}");
      }
    } else {
      for (var card in state.cards) {
        // Eğer kart devre dışı değilse, değerini ekle
        if (card.fullName != state.game.disabledCards) {
          player2Score += card.value;
        }
        // Eğer kart devre dışıysa (örneğin özel kart tarafından iptal edildiyse)
        else {
          // Devre dışı kartın değeri kadar eksilt (puan düş)
          player2Score -= card.value;
        }
        print("Player 2 cards: ${card.fullName}");
      }

      // 🧮 Player 2 Skoru Hesapla
      for (var card in state.opponentCards) {
        if (card.fullName != state.game.disabledCards) {
          player1Score += card.value;
        } else {
          player1Score -= card.value;
        }
        print("Player 1 cards: ${card.fullName}");
      }
    }

    emit(state.copyWith(
        player1Score: state.player1Score + player1Score, player2Score: state.player2Score + player2Score));
    if (player1Score > player2Score) {
      emit(state.copyWith(player1WinCount: state.player1WinCount + 1));
      print("wincount player 1: ${state.player1WinCount}}");
    } else {
      emit(state.copyWith(player2WinCount: state.player2WinCount + 1));
      print("wincount player 2: ${state.player1WinCount}}");
    }

    // 🔍 Konsola log bas (debug amaçlı)
    print('🎯 Player 1 Score: $player1Score | Player 2 Score: $player2Score');
  }

  Future<void> startNewRound(int gameId) async {
    await _homeService.startNewRound(gameId);
  }

  void setIsSpecialEffectPlaying(bool value) {
    emit(state.copyWith(isSpecialEffectPlaying: value));
  }

  Timer? timerPer;

  void startTimer() {
    emit(state.copyWith(seconds: 15, isSpecialEffectPlaying: true));
    timerPer = Timer.periodic(const Duration(seconds: 1), (v) {
      if (state.seconds > 0) {
        emit(state.copyWith(seconds: state.seconds - 1));
      }
    });
  }

  void stopTimer() {
    timerPer!.cancel();
    emit(state.copyWith(isSpecialEffectPlaying: false, seconds: 15));
  }

  Future<void> finish(int gameId, bool isPlayer1, int playerId, int point) async {
    emit(state.copyWith(finishState: FinishStates.loading, errorMessage: ''));
    //)
    final response = await _homeService.finish(gameId, isPlayer1, playerId, point);

    if (response != null) {
      if (response.success == true) {
        emit(state.copyWith(
          finishState: FinishStates.completed,
          message: response.data.toString(),
        ));
      } else {
        emit(state.copyWith(
          finishState: FinishStates.error,
          errorMessage: response.message ?? 'Error',
        ));
      }
    }
  }
}
