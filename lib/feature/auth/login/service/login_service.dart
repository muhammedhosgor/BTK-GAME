import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_base_app/core/model/api_result.dart';
import 'package:flutter_base_app/feature/auth/login/service/i_login_service.dart';

class LoginService extends ILoginService {
  LoginService(super.dio);
  @override
  Future<ApiResult?> userLogin(String emailOrPhone, String password) async {
    try {
      final response = await dio.post(
        path: '/Student/Login',
        queryParameters: {
          'emailOrPhone': emailOrPhone,
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
}
