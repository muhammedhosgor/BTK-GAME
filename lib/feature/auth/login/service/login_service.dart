import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_base_app/core/model/api_result.dart';
import 'package:flutter_base_app/feature/auth/login/service/i_login_service.dart';
import 'package:flutter_base_app/product/constant/app_constants.dart';

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
}
