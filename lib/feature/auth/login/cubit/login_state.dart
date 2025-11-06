import 'package:equatable/equatable.dart';
import 'package:flutter_base_app/feature/auth/login/model/game_model.dart';
import 'package:flutter_base_app/feature/auth/login/model/user_model.dart';

class LoginState extends Equatable {
  LoginState({
    required this.loginState,
    required this.getUserState,
    required this.pointState,
    required this.lobbyState,
    required this.joinRoomState,
    required this.createRoomState,
    required this.leaveRoomState,
    required this.statusState,
    required this.errorMessage,
    required this.message,
    required this.userList,
    required this.isLogin,
    required this.gameList,
    required this.gameStatus,
    required this.countDownWaitingRoom,
    required this.countDownJoinRoom,
    required this.userPoint,
  });
  factory LoginState.initial() {
    return LoginState(
      loginState: LoginStates.initial,
      getUserState: GetUserStates.initial,
      pointState: PointStates.initial,
      joinRoomState: JoinRoomStates.initial,
      createRoomState: CreateRoomStates.initial,
      leaveRoomState: LeaveRoomStates.initial,
      statusState: StatusStates.initial,
      lobbyState: LobbyStates.initial,
      errorMessage: '',
      message: '',
      userList: [],
      isLogin: false,
      gameList: [],
      gameStatus: null,
      countDownWaitingRoom: 5,
      countDownJoinRoom: 5,
      userPoint: 0,
    );
  }
  final LoginStates loginState;
  final GetUserStates getUserState;
  final PointStates pointState;
  final LobbyStates lobbyState;
  final JoinRoomStates joinRoomState;
  final CreateRoomStates createRoomState;
  final LeaveRoomStates leaveRoomState;
  final StatusStates statusState;
  final String errorMessage;
  final String message;
  List<UserModel> userList;
  bool isLogin;
  List<GameModel> gameList;
  String? gameStatus;
  int countDownWaitingRoom;
  int countDownJoinRoom;
  int userPoint;

  @override
  List<Object?> get props => [
        loginState,
        getUserState,
        pointState,
        lobbyState,
        joinRoomState,
        createRoomState,
        leaveRoomState,
        statusState,
        errorMessage,
        message,
        userList,
        isLogin,
        gameList,
        gameStatus,
        countDownWaitingRoom,
        countDownJoinRoom,
        userPoint,
      ];

  LoginState copyWith({
    LoginStates? loginState,
    GetUserStates? getUserState,
    PointStates? pointState,
    LobbyStates? lobbyState,
    JoinRoomStates? joinRoomState,
    CreateRoomStates? createRoomState,
    LeaveRoomStates? leaveRoomState,
    StatusStates? statusState,
    String? errorMessage,
    String? message,
    List<UserModel>? userList,
    bool? isLogin,
    List<GameModel>? gameList,
    String? gameStatus,
    int? countDownWaitingRoom,
    int? countDownJoinRoom,
    int? userPoint,
  }) {
    return LoginState(
      loginState: loginState ?? this.loginState,
      getUserState: getUserState ?? this.getUserState,
      pointState: pointState ?? this.pointState,
      lobbyState: lobbyState ?? this.lobbyState,
      joinRoomState: joinRoomState ?? this.joinRoomState,
      createRoomState: createRoomState ?? this.createRoomState,
      leaveRoomState: leaveRoomState ?? this.leaveRoomState,
      statusState: statusState ?? this.statusState,
      errorMessage: errorMessage ?? this.errorMessage,
      message: message ?? this.message,
      userList: userList ?? this.userList,
      isLogin: isLogin ?? this.isLogin,
      gameList: gameList ?? this.gameList,
      gameStatus: gameStatus ?? this.gameStatus,
      countDownWaitingRoom: countDownWaitingRoom ?? this.countDownWaitingRoom,
      countDownJoinRoom: countDownJoinRoom ?? this.countDownJoinRoom,
      userPoint: userPoint ?? this.userPoint,
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

enum LeaveRoomStates {
  initial,
  loading,
  completed,
  error,
}

enum StatusStates {
  initial,
  loading,
  completed,
  error,
}

enum PointStates {
  initial,
  loading,
  completed,
  error,
}
