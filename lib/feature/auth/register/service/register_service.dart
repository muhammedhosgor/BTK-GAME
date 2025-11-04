import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_app/core/model/api_result.dart';
import 'package:flutter_base_app/feature/auth/login/model/user_model.dart';

import 'package:flutter_base_app/product/constant/app_constants.dart';

import 'i_register_service.dart';

class RegisterService extends IRegisterService {
  RegisterService(super.dio);

  @override
  Future<ApiResult?> insert(UserModel userModel, File? imageFile) async {
    try {
      // Dio ayarları
      final dio = Dio(BaseOptions(
        baseUrl: 'https://btkgameapi.linsabilisim.com/', // 🔹 kendi API adresin
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      ));

      // 📸 FormData oluştur
      final formData = FormData.fromMap({
        'KeyGen': KeyGen, // API güvenlik anahtarın

        // Text alanları
        'Name': userModel.name,
        'Surname': userModel.surname,
        'Email': userModel.email,
        'Password': userModel.password,
        'Point': 0,
        'Platform': Platform.isAndroid ? 'Android' : 'IOS',
        'CreatedDate': DateTime.now().toIso8601String(),
        'Status': 'Yeni Kayıt',
        'IsActive': true,

        // 🖼️ Dosya alanı (isteğe bağlı)
        if (imageFile != null)
          'ImageFile': await MultipartFile.fromFile(
            imageFile.path,
            filename: imageFile.path.split('/').last,
          ),
      });

      // 🔹 POST isteği
      final response = await dio.post(
        '/api/User/Insert',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      debugPrint('📨 Join Room Response : ${response.data}');

      if (response.statusCode == HttpStatus.ok) {
        return ApiResult.fromJson(response.data as Map<String, dynamic>);
      } else {
        return null;
      }
    } catch (e, stack) {
      debugPrint('❌ Insert error: $e');
      debugPrint(stack.toString());
      return null;
    }
  }

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
}
