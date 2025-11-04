import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_base_app/core/model/api_result.dart';
import 'package:flutter_base_app/product/constant/app_constants.dart';

import 'i_home_service.dart';

class HomeService extends IHomeService {
  HomeService(super.dio);

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
  Future<ApiResult?> setPlayerReady(int gameId, bool isPlayer1) async {
    try {
      final response = await dio.post(
        path: '/api/Game/SetPlayerReady',
        queryParameters: {
          'KeyGen': KeyGen,
          'isPlayer1': isPlayer1,
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
  Future<ApiResult?> makeMove(int gameId, int playerId, bool move, String cardValue) async {
    try {
      final response = await dio.post(
        path: '/api/Game/MakeMove',
        queryParameters: {
          'KeyGen': KeyGen,
          'gameId': gameId,
          'playerId': playerId,
          'cardValue': cardValue,
          'move': move,
        },
      );

      print('Make Move Response : $response');

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
  Future<ApiResult?> disableCards(int gameId, String disabledCards) async {
    try {
      final response = await dio.post(
        path: '/api/Game/DisableCard',
        queryParameters: {
          'KeyGen': KeyGen,
          'gameId': gameId,
          'disabledCards': disabledCards,
        },
      );

      print('Disable Cards Response : $response');

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
  Future<ApiResult?> sinekle(int gameId, String swappedCards) async {
    try {
      final response = await dio.post(
        path: '/api/Game/Sinekle',
        queryParameters: {
          'KeyGen': KeyGen,
          'gameId': gameId,
          'swappedCards': swappedCards,
        },
      );

      print('Sinekle Response : $response');

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
  Future<ApiResult?> handComplete(int gameId) async {
    try {
      final response = await dio.post(
        path: '/api/Game/HandComplete',
        queryParameters: {
          'KeyGen': KeyGen,
          'gameId': gameId,
        },
      );

      print('HandComplete Response : $response');

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
  Future<ApiResult?> startNewRound(int gameId) async {
    try {
      final response = await dio.post(
        path: '/api/Game/StartNewRound',
        queryParameters: {
          'KeyGen': KeyGen,
          'gameId': gameId,
        },
      );

      print('HandComplete Response : $response');

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
  Future<ApiResult?> finish(int gameId, bool isPlayer1, int playerId, int point) async {
    try {
      final response = await dio.post(
        path: '/api/Game/Finish',
        queryParameters: {
          'KeyGen': KeyGen,
          'gameId': gameId,
          'isPlayer1': isPlayer1,
          'playerId': playerId,
          'point': point,
        },
      );

      print('Finish Response : $response');

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
