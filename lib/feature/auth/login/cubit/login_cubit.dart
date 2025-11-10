import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base_app/core/network/network_manager/network_manager.dart';
import 'package:flutter_base_app/feature/auth/login/cubit/login_state.dart';
import 'package:flutter_base_app/feature/auth/login/model/game_model.dart';
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
  Timer? waitingRoomTimer;
  Timer? joinRoomTimer;
  int? userId = injector<LocalStorage>().getInt('userId');

  init() async {
    await getUserList();
    if (userId != null) {
      getUserPoint(userId!);
    }
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
        injector.get<LocalStorage>().saveString('email', userModel.email ?? '');
        injector.get<LocalStorage>().saveString('password', userModel.password ?? '');
        injector.get<LocalStorage>().saveString('image', userModel.image ?? '');
        changeLoginStatus(true);
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

  void changeLoginStatus(bool status) {
    emit(state.copyWith(isLogin: status));
  }

  Future<void> lobby() async {
    emit(state.copyWith(lobbyState: LobbyStates.loading, errorMessage: ''));
    final response = await _loginService.lobby();

    if (response == null) {
      emit(
        state.copyWith(
          lobbyState: LobbyStates.error,
          errorMessage: 'Veriler yüklenemedi. Lütfen internet bağlantınızı kontrol ediniz...',
        ),
      );
    } else {
      if (response.success!) {
        final dataList = response.data as List<dynamic>;
        emit(
          state.copyWith(
              lobbyState: LobbyStates.completed,
              gameList: dataList.map((dynamic item) => GameModel.fromJson(item as Map<String, dynamic>)).toList()),
        );
      } else {
        emit(state.copyWith(
          lobbyState: LobbyStates.error,
          errorMessage: response.errorMessage ?? 'Bir Hata Oluştu!',
        ));
      }
    }
  }

  Future<bool> joinRoom(int roomId, String name, String surname, String player2Image) async {
    emit(state.copyWith(joinRoomState: JoinRoomStates.loading, errorMessage: ''));
    final response = await _loginService.joinRoom(roomId, name, surname, player2Image);

    if (response == null) {
      emit(
        state.copyWith(
          joinRoomState: JoinRoomStates.error,
          errorMessage: 'Odaya katılım sağlanamadı. Lütfen internet bağlantınızı kontrol ediniz...',
        ),
      );
      return false;
    } else {
      if (response.success!) {
        //await lobby(); // Odaya katıldıktan sonra lobi listesini güncelle
        emit(state.copyWith(joinRoomState: JoinRoomStates.completed, message: response.message));
        return true;
      } else {
        emit(state.copyWith(
          joinRoomState: JoinRoomStates.error,
          errorMessage: response.errorMessage ?? 'Odaya katılım sağlanamadı!',
        ));
        return false;
      }
    }
  }

  Future<bool> createRoom() async {
    emit(state.copyWith(createRoomState: CreateRoomStates.loading, errorMessage: ''));
    final response = await _loginService.createRoom();

    if (response == null) {
      emit(
        state.copyWith(
          joinRoomState: JoinRoomStates.error,
          errorMessage: 'Oda oluşturulamadı. Lütfen internet bağlantınızı kontrol ediniz...',
        ),
      );
      return false;
    } else {
      if (response.success!) {
        await lobby(); // Oda oluşturduktan sonra lobi listesini güncelle
        LocalStorage localStorage = injector.get<LocalStorage>();
        localStorage.remove('createGameId');
        int createGameId = response.data['id'];
        localStorage.saveInt('createGameId', createGameId);
        emit(state.copyWith(createRoomState: CreateRoomStates.completed, message: response.message));
        return true;
      } else {
        emit(state.copyWith(
          createRoomState: CreateRoomStates.error,
          errorMessage: response.errorMessage ?? 'Oda oluşturulamadı!',
        ));
        return false;
      }
    }
  }

  Future<void> setGameStatus(int gameId) async {
    emit(state.copyWith(statusState: StatusStates.loading, errorMessage: ''));
    final response = await _loginService.status(gameId);

    if (response == null) {
      emit(
        state.copyWith(
          statusState: StatusStates.error,
          errorMessage: 'Veriler yüklenemedi. Lütfen internet bağlantınızı kontrol ediniz...',
        ),
      );
    } else {
      if (response.success!) {
        final dataMap = response.data as Map<String, dynamic>;
        emit(
          state.copyWith(
            statusState: StatusStates.completed,
            gameStatus: dataMap["status"] as String?,
          ),
        );
        print("Game Status: ${dataMap["status"]}");
      } else {
        emit(state.copyWith(
          statusState: StatusStates.error,
          errorMessage: response.errorMessage ?? 'Bir Hata Oluştu!',
        ));
      }
    }
  }

  Future<bool> leaveRoom(int gameId) async {
    emit(state.copyWith(leaveRoomState: LeaveRoomStates.loading, errorMessage: ''));
    final response = await _loginService.leaveRoom(gameId);

    if (response == null) {
      emit(
        state.copyWith(
          leaveRoomState: LeaveRoomStates.error,
          errorMessage: 'Oda oluşturulamadı. Lütfen internet bağlantınızı kontrol ediniz...',
        ),
      );
      return false;
    } else {
      if (response.success!) {
        await lobby(); // Oda oluşturduktan sonra lobi listesini güncelle
        emit(state.copyWith(leaveRoomState: LeaveRoomStates.completed, message: response.message));
        return true;
      } else {
        emit(state.copyWith(
          leaveRoomState: LeaveRoomStates.error,
          errorMessage: response.errorMessage ?? 'Oda oluşturulamadı!',
        ));
        return false;
      }
    }
  }

  void setGameStatusToStarted() {
    emit(state.copyWith(gameStatus: 'OYUN BAŞLADI'));
  }

  void setCountDownWaitingRoom() {
    waitingRoomTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.countDownWaitingRoom == 0) {
        timer.cancel();
      } else {
        emit(state.copyWith(countDownWaitingRoom: state.countDownWaitingRoom - 1));
      }
    });
  }

  void setCountDownJoinRoom() {
    joinRoomTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.countDownJoinRoom == 0) {
        timer.cancel();
      } else {
        emit(state.copyWith(countDownJoinRoom: state.countDownJoinRoom - 1));
      }
    });
  }

  void cancelJoinRoomTimer() {
    joinRoomTimer?.cancel();
    joinRoomTimer = null;
  }

  void cancelWaitingRoomTimer() {
    waitingRoomTimer?.cancel();
    waitingRoomTimer = null;
  }

  Future<void> getUserPoint(int userId) async {
    emit(state.copyWith(pointState: PointStates.loading, errorMessage: ''));
    final response = await _loginService.getUserPoint(userId);

    if (response == null) {
      emit(
        state.copyWith(
          pointState: PointStates.error,
          errorMessage: 'Veriler yüklenemedi. Lütfen internet bağlantınızı kontrol ediniz...',
        ),
      );
    } else {
      if (response.success!) {
        final dataMap = response.data as Map<String, dynamic>;
        emit(
          state.copyWith(
            pointState: PointStates.completed,
            userPoint: dataMap["point"] as int?,
          ),
        );
        print("User Point: ${dataMap["point"]}");
      } else {
        emit(state.copyWith(
          pointState: PointStates.error,
          errorMessage: response.errorMessage ?? 'Bir Hata Oluştu!',
        ));
      }
    }
  }

  void closeApp() {
    // Kullanıcı verilerini temizle
    userModel = UserModel();
    final storage = injector.get<LocalStorage>();
    storage.remove('userId');
    storage.remove('userName');
    storage.remove('userSurname');
    storage.remove('email');
    storage.remove('password');
    storage.remove('image');

    //* Android ve iOS ayrımı
    if (Platform.isAndroid) {
      //* Tamamen uygulamayı kapat
      exit(0);
    } else if (Platform.isIOS) {
      //* iOS'te uygulamayı kapatamazsın, kullanıcı ana ekrana döner
      SystemNavigator.pop();
    }
  }
}
