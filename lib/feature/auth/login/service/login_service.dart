import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_base_app/core/model/api_result.dart';
import 'package:flutter_base_app/feature/auth/login/model/user_model.dart';
import 'package:flutter_base_app/feature/auth/login/service/i_login_service.dart';
import 'package:flutter_base_app/product/constant/app_constants.dart';
import 'package:flutter_base_app/product/injector/injector.dart';
import 'package:flutter_base_app/product/storage/local_get_storage.dart';

class LoginService extends ILoginService {
  LoginService(super.dio);
  @override
  Future<ApiResult?> userLogin(String email, String password) async {
    try {
      final response = await dio.get(
        path: '/api/User/Login',
        queryParameters: {
          'KeyGen': KeyGen,
          'email': email,
          'password': password,
        },
      );

      print('Login Response : $response');

      if (response.statusCode == HttpStatus.ok) {
        return ApiResult.fromJson(response.data as Map<String, dynamic>);
      } else {
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      print('error : $e');
      return null;
    }
  }

  @override
  Future<ApiResult?> getUserAll() async {
    try {
      final response = await dio.get(
        path: '/api/User/GetAll',
        queryParameters: {
          'KeyGen': KeyGen,
        },
      );

      print('Login Response : $response');

      if (response.statusCode == HttpStatus.ok) {
        return ApiResult.fromJson(response.data as Map<String, dynamic>);
      } else {
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      print('error : $e');
      return null;
    }
  }

  @override
  Future<ApiResult?> lobby() async {
    try {
      final response = await dio.get(
        path: '/api/Game/Lobby',
        queryParameters: {
          'KeyGen': KeyGen,
        },
      );

      print('Login Response : $response');

      if (response.statusCode == HttpStatus.ok) {
        return ApiResult.fromJson(response.data as Map<String, dynamic>);
      } else {
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      print('error : $e');
      return null;
    }
  }

  @override
  Future<ApiResult?> joinRoom(
      int roomId, String name, String surname, String player2Image) async {
    int? userId = injector.get<LocalStorage>().getInt('userId');
    try {
      final response = await dio.post(
        path: '/api/Game/Join',
        queryParameters: {
          'KeyGen': KeyGen,
          'gameId': roomId,
          'Player2Id': userId,
          'player2Image': player2Image,
          'name': name,
          'surname': surname,
        },
      );

      print('Join Room Response : $response');

      if (response.statusCode == HttpStatus.ok) {
        return ApiResult.fromJson(response.data as Map<String, dynamic>);
      } else {
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      print('error : $e');
      return null;
    }
  }

  @override
  Future<ApiResult?> createRoom() async {
    int? userId = injector.get<LocalStorage>().getInt('userId');
    String? player1Name = injector.get<LocalStorage>().getString('userName');
    String? player1Surname =
        injector.get<LocalStorage>().getString('userSurname');
    String? image = injector.get<LocalStorage>().getString('image');

    try {
      final response =
          await dio.post(path: '/api/Game/Create', queryParameters: {
        'KeyGen': KeyGen,
        'Player1Id': userId,
        'name': player1Name,
        'surname': player1Surname,
        'player1Image': image,
      }, data: {
        'Player1Id': userId,
        'CreatedDate': DateTime.now().toIso8601String(),
        'IsActive': true,
      });

      print('Create Room Response : $response');

      if (response.statusCode == HttpStatus.ok) {
        return ApiResult.fromJson(response.data as Map<String, dynamic>);
      } else {
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      print('error : $e');
      return null;
    }
  }

  @override
  Future<ApiResult?> leaveRoom(int gameId) async {
    int? userId = injector.get<LocalStorage>().getInt('userId');
    try {
      final response = await dio.post(
        path: '/api/Game/Leave',
        queryParameters: {
          'KeyGen': KeyGen,
          'gameId': gameId,
          'Player1Id': userId,
        },
      );

      print('Leave Room Response : $response');

      if (response.statusCode == HttpStatus.ok) {
        return ApiResult.fromJson(response.data as Map<String, dynamic>);
      } else {
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      print('error : $e');
      return null;
    }
  }

  @override
  Future<ApiResult?> status(int gameId) async {
    try {
      final response = await dio.get(
        path: '/api/Game/Status',
        queryParameters: {
          'KeyGen': KeyGen,
          'gameId': gameId,
        },
      );

      print('Join Room Response : $response');

      if (response.statusCode == HttpStatus.ok) {
        return ApiResult.fromJson(response.data as Map<String, dynamic>);
      } else {
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      print('error : $e');
      return null;
    }
  }

  @override
  Future<ApiResult?> getUserPoint(int userId) async {
    try {
      final response = await dio.get(
        path: '/api/User/GetUserPoint',
        queryParameters: {
          'KeyGen': KeyGen,
          'userId': userId,
        },
      );

      print('Join Room Response : $response');

      if (response.statusCode == HttpStatus.ok) {
        return ApiResult.fromJson(response.data as Map<String, dynamic>);
      } else {
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      print('error : $e');
      return null;
    }
  }

  @override
  Future<ApiResult?> deleteAccount(int userId) async {
    try {
      final response = await dio.post(
        path: '/api/User/SoftDelete',
        queryParameters: {
          'KeyGen': KeyGen,
          'Id': userId,
        },
      );

      print('Delete Response : $response');

      if (response.statusCode == HttpStatus.ok) {
        return ApiResult.fromJson(response.data as Map<String, dynamic>);
      } else {
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      print('error : $e');
      return null;
    }
  }

  @override
  Future<ApiResult?> getGifts() async {
    try {
      final response = await dio.get(
        path: '/api/Gifts/GetAll',
        queryParameters: {
          'KeyGen': KeyGen,
        },
      );

      print('Login Response : $response');

      if (response.statusCode == HttpStatus.ok) {
        return ApiResult.fromJson(response.data as Map<String, dynamic>);
      } else {
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      print('error : $e');
      return null;
    }
  }

  @override
  Future<ApiResult?> claimGift(
      String email, String type, int userId, int userPoint, int giftId) async {
    try {
      final response = await dio.get(
        path: '/api/Codes/SendGiftCode',
        queryParameters: {
          'KeyGen': KeyGen,
          'email': email,
          'type': type,
          'userId': userId,
          'userPoint': userPoint,
          'giftId': giftId,
        },
      );

      print('Login Response : $response');

      if (response.statusCode == HttpStatus.ok) {
        return ApiResult.fromJson(response.data as Map<String, dynamic>);
      } else {
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      print('error : $e');
      return null;
    }
  }

  @override
  Future<ApiResult?> visible() async {
    try {
      final response = await dio.post(
        path: '/api/User/Visible',
        queryParameters: {
          'KeyGen': KeyGen,
        },
      );

      print('Login Response : $response');

      if (response.statusCode == HttpStatus.ok) {
        return ApiResult.fromJson(response.data as Map<String, dynamic>);
      } else {
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      print('error : $e');
      return null;
    }
  }

  @override
  Future<ApiResult?> giftsMove(int userId, int giftId) async {
    try {
      final response = await dio.post(
        path: '/api/Gifts/GiftInsertMove',
        data: {
          'userId': userId,
          'giftId': giftId,
          'useDate': DateTime.now().toIso8601String(),
        },
        queryParameters: {
          'KeyGen': KeyGen,
        },
      );

      print('Login Response : $response');

      if (response.statusCode == HttpStatus.ok) {
        return ApiResult.fromJson(response.data as Map<String, dynamic>);
      } else {
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      print('error : $e');
      return null;
    }
  }
}
