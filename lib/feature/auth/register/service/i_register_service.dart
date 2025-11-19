import 'dart:io';

import 'package:flutter_base_app/core/model/api_result.dart';
import 'package:flutter_base_app/core/network/network_manager/network_manager.dart';
import 'package:flutter_base_app/feature/auth/login/model/user_model.dart';

abstract class IRegisterService {
  IRegisterService(this.dio);
  final NetworkManager dio;
  Future<ApiResult?> insert(UserModel userModel, File? imageFile);
  Future<ApiResult?> userLogin(String email, String password);
  Future<ApiResult?> sendOTP(String email);
  Future<ApiResult?> checkOTP(String email, String code);
  Future<ApiResult?> resetPassword(String email, String newPassword);
}
