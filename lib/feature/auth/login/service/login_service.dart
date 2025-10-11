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
  Future<ApiResult?> joinRoom(int roomId) async {
    int? userId = injector.get<LocalStorage>().getInt('userId');
    try {
      final response = await dio.post(
        path: '/api/Game/Join',
        queryParameters: {
          'KeyGen': KeyGen,
          'gameId': roomId,
          'Player2Id': userId,
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
    try {
      final response = await dio.post(path: '/api/Game/Create', queryParameters: {
        'KeyGen': KeyGen,
        'Player1Id': userId,
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
}
