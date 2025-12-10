import 'package:flutter_base_app/core/model/api_result.dart';
import 'package:flutter_base_app/core/network/network_manager/network_manager.dart';

abstract class ILoginService {
  ILoginService(this.dio);
  NetworkManager dio;
  Future<ApiResult?> userLogin(String email, String password);
  Future<ApiResult?> getUserAll();
  Future<ApiResult?> lobby();
  Future<ApiResult?> joinRoom(
      int roomId, String name, String surname, String player2Image);
  Future<ApiResult?> createRoom();
  Future<ApiResult?> leaveRoom(int gameId);
  Future<ApiResult?> status(int gameId);
  Future<ApiResult?> getUserPoint(int userId);
  Future<ApiResult?> deleteAccount(int userId);
  //!
  Future<ApiResult?> getGifts();
  Future<ApiResult?> claimGift(
      String email, String type, int userId, int userPoint, int giftId);
  Future<ApiResult?> visible();
}
