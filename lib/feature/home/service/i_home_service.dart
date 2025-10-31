import 'package:flutter_base_app/core/model/api_result.dart';
import 'package:flutter_base_app/core/network/network_manager/network_manager.dart';

abstract class IHomeService {
  IHomeService(this.dio);
  final NetworkManager dio;
  Future<ApiResult?> status(int gameId);
  Future<ApiResult?> setPlayerReady(int gameId, bool isPlayer1);
  Future<ApiResult?> makeMove(int gameId, int playerId, bool move, String cardValue);
  Future<ApiResult?> sinekle(int gameId, String swappedCards);
  Future<ApiResult?> disableCards(int gameId, String disabledCards);
  Future<ApiResult?> handComplete(int gameId);
  Future<ApiResult?> startNewRound(int gameId);
}
