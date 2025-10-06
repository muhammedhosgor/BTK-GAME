import 'package:flutter/material.dart';
import 'package:flutter_base_app/core/network/network_manager/network_manager.dart';
import 'package:flutter_base_app/feature/auth/login/cubit/login_state.dart';
import 'package:flutter_base_app/feature/auth/login/model/user_model.dart';
import 'package:flutter_base_app/feature/auth/login/service/i_login_service.dart';
import 'package:flutter_base_app/feature/auth/login/service/login_service.dart';
import 'package:flutter_base_app/product/injector/injector.dart';
import 'package:flutter_base_app/product/storage/local_get_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginState.initial()) {
    init();
  }

  final ILoginService _loginService = LoginService(NetworkManager.instance);
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  init() async {
    await getUserList();
  }

  Future<void> userLogin(String email, String password) async {
    emit(state.copyWith(loginState: LoginStates.loading, errorMessage: ''));
    final response = await _loginService.userLogin(email, password);

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
        emit(
          state.copyWith(
            loginState: LoginStates.completed,
            message: response.message,
          ),
        );
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

  Future<void> getUserList() async {
    emit(state.copyWith(getUserState: GetUserStates.loading, errorMessage: ''));
    final response = await _loginService.getUserAll();

    if (response == null) {
      emit(
        state.copyWith(
          getUserState: GetUserStates.error,
          errorMessage: 'Veriler yüklenemedi. Lütfen internet bağlantınızı kontrol ediniz...',
        ),
      );
    } else {
      if (response.success!) {
        final dataList = response.data as List<dynamic>;
        emit(
          state.copyWith(
              getUserState: GetUserStates.completed,
              userList: dataList.map((dynamic item) => UserModel.fromJson(item as Map<String, dynamic>)).toList()),
        );
      } else {
        emit(state.copyWith(
          getUserState: GetUserStates.error,
          errorMessage: response.errorMessage ?? 'Bir Hata Oluştu!',
        ));
      }
    }
  }
}
