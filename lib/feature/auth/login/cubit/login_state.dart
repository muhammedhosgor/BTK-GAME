import 'package:equatable/equatable.dart';
import 'package:flutter_base_app/feature/auth/login/model/game_model.dart';
import 'package:flutter_base_app/feature/auth/login/model/user_model.dart';

class LoginState extends Equatable {
  LoginState({
    required this.loginState,
    required this.getUserState,
    required this.lobbyState,
    required this.joinRoomState,
    required this.createRoomState,
    required this.errorMessage,
    required this.message,
    required this.userList,
    required this.isLogin,
    required this.gameList,
    required String? gameStatus,
  });
  factory LoginState.initial() {
    return LoginState(
      loginState: LoginStates.initial,
      getUserState: GetUserStates.initial,
      joinRoomState: JoinRoomStates.initial,
      createRoomState: CreateRoomStates.initial,
      lobbyState: LobbyStates.initial,
      errorMessage: '',
      message: '',
      userList: [],
      isLogin: false,
      gameList: [],
      gameStatus: null,
    );
  }
  final LoginStates loginState;
  final GetUserStates getUserState;
  final LobbyStates lobbyState;
  final JoinRoomStates joinRoomState;
  final CreateRoomStates createRoomState;
  final String errorMessage;
  final String message;
  List<UserModel> userList;
  bool isLogin;
  List<GameModel> gameList;
  String? gameStatus;

  @override
  List<Object?> get props => [
        loginState,
        getUserState,
        lobbyState,
        joinRoomState,
        createRoomState,
        errorMessage,
        message,
        userList,
        isLogin,
        gameList,
        gameStatus,
      ];

  LoginState copyWith({
    LoginStates? loginState,
    GetUserStates? getUserState,
    LobbyStates? lobbyState,
    JoinRoomStates? joinRoomState,
    CreateRoomStates? createRoomState,
    String? errorMessage,
    String? message,
    List<UserModel>? userList,
    bool? isLogin,
    List<GameModel>? gameList,
    String? gameStatus,
  }) {
    return LoginState(
      loginState: loginState ?? this.loginState,
      getUserState: getUserState ?? this.getUserState,
      lobbyState: lobbyState ?? this.lobbyState,
      joinRoomState: joinRoomState ?? this.joinRoomState,
      createRoomState: createRoomState ?? this.createRoomState,
      errorMessage: errorMessage ?? this.errorMessage,
      message: message ?? this.message,
      userList: userList ?? this.userList,
      isLogin: isLogin ?? this.isLogin,
      gameList: gameList ?? this.gameList,
      gameStatus: gameStatus ?? this.gameStatus,
    );
  }
}

enum LoginStates {
  initial,
  loading,
  completed,
  error,
}

enum GetUserStates {
  initial,
  loading,
  completed,
  error,
}

enum LobbyStates {
  initial,
  loading,
  completed,
  error,
}

enum JoinRoomStates {
  initial,
  loading,
  completed,
  error,
}

enum CreateRoomStates {
  initial,
  loading,
  completed,
  error,
}
