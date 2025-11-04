import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_base_app/core/network/network_manager/network_manager.dart';
import 'package:flutter_base_app/feature/auth/login/model/user_model.dart';
import 'package:flutter_base_app/feature/auth/register/service/i_register_service.dart';
import 'package:flutter_base_app/feature/auth/register/service/register_service.dart';
import 'package:flutter_base_app/product/injector/injector.dart';
import 'package:flutter_base_app/product/storage/local_get_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterState.initial()) {
    init();
  }

  final IRegisterService _registerService = RegisterService(NetworkManager.instance);
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> init() async {
    // TODO: implement init logic
  }
  Future<void> userLogin(String email, String password) async {
    emit(state.copyWith(loginState: LoginStates.loading, errorMessage: ''));
    final response = await _registerService.userLogin(email, password);

    if (response == null) {
      emit(
        state.copyWith(
          loginState: LoginStates.error,
          errorMessage: 'Veriler yüklenemedi. Lütfen internet bağlantınızı kontrol ediniz...',
        ),
      );
    } else {
      if (response.data != null) {
        //  injector.get<LocalStorage>().saveString('token', 'token Değeri');

        userModel = UserModel.fromJson(response.data as Map<String, dynamic>);
        injector.get<LocalStorage>().saveInt('userId', userModel.id ?? 0);
        injector.get<LocalStorage>().saveString('userName', userModel.name ?? '');
        injector.get<LocalStorage>().saveString('userSurname', userModel.surname ?? '');
        // changeLoginStatus(true);
        emit(
          state.copyWith(
            loginState: LoginStates.completed,
            message: response.message,
          ),
        );
        nameController.clear();
        surnameController.clear();
        emailController.clear();
        passwordController.clear();
      } else {
        emit(state.copyWith(
          loginState: LoginStates.error,
          errorMessage: response.errorMessage ?? 'Bir Hata Oluştu!',
        ));
      }
    }
  }

  // void changeLoginStatus(bool status) {
  //   emit(state.copyWith(isLogin: status));
  // }

  Future<void> insertUser(UserModel userModel, File? imageFile) async {
    emit(state.copyWith(registerState: RegisterStates.loading, errorMessage: ''));
    final response = await _registerService.insert(userModel, imageFile);

    if (response == null) {
      emit(
        state.copyWith(
          registerState: RegisterStates.error,
          errorMessage: 'Error }',
        ),
      );
    } else {
      if (response.success!) {
        emit(state.copyWith(registerState: RegisterStates.completed, message: response.message));
        // await lobby(); // Oda oluşturduktan sonra lobi listesini güncelle
      } else {
        emit(state.copyWith(
          registerState: RegisterStates.error,
          errorMessage: response.errorMessage ?? 'Oda oluşturulamadı!',
        ));
      }
    }
  }

  void changeObscureText() {
    emit(state.copyWith(obscureText: !state.obscureText));
  }

  void setImage(File imageFile) {
    emit(state.copyWith(imageFile: imageFile));
  }
}
