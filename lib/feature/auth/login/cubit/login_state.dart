import 'package:equatable/equatable.dart';
import 'package:flutter_base_app/feature/auth/login/model/game_model.dart';
import 'package:flutter_base_app/feature/auth/login/model/gifts_model.dart';
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
    required this.deleteAccountState,
    required this.giftsState,
    required this.claimGiftState,
    required this.errorMessage,
    required this.message,
    required this.userList,
    required this.isLogin,
    required this.gameList,
    required this.gameStatus,
    required this.countDownWaitingRoom,
    required this.countDownJoinRoom,
    required this.userPoint,
    required this.userGiftsIds,
    required this.giftsList,
    required this.visible,
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
      deleteAccountState: DeleteAccountStates.initial,
      giftsState: GiftsStates.initial,
      claimGiftState: ClaimGiftStates.initial,
      errorMessage: '',
      message: '',
      userList: [],
      isLogin: false,
      gameList: [],
      gameStatus: null,
      countDownWaitingRoom: 5,
      countDownJoinRoom: 5,
      userPoint: 0,
      userGiftsIds: '',
      giftsList: [],
      visible: false,
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
  final DeleteAccountStates deleteAccountState;
  final GiftsStates giftsState;
  final ClaimGiftStates claimGiftState;
  final String errorMessage;
  final String message;
  List<UserModel> userList;
  bool isLogin;
  List<GameModel> gameList;
  String? gameStatus;
  int countDownWaitingRoom;
  int countDownJoinRoom;
  int userPoint;
  //* Gifts
  String userGiftsIds;
  List<GiftsModel> giftsList;
  bool visible;

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
        deleteAccountState,
        giftsState,
        claimGiftState,
        errorMessage,
        message,
        userList,
        isLogin,
        gameList,
        gameStatus,
        countDownWaitingRoom,
        countDownJoinRoom,
        userPoint,
        userGiftsIds,
        giftsList,
        visible,
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
    DeleteAccountStates? deleteAccountState,
    GiftsStates? giftsState,
    ClaimGiftStates? claimGiftState,
    String? errorMessage,
    String? message,
    List<UserModel>? userList,
    bool? isLogin,
    List<GameModel>? gameList,
    String? gameStatus,
    int? countDownWaitingRoom,
    int? countDownJoinRoom,
    int? userPoint,
    String? userGiftsIds,
    List<GiftsModel>? giftsList,
    bool? visible,
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
      deleteAccountState: deleteAccountState ?? this.deleteAccountState,
      giftsState: giftsState ?? this.giftsState,
      claimGiftState: claimGiftState ?? this.claimGiftState,
      errorMessage: errorMessage ?? this.errorMessage,
      message: message ?? this.message,
      userList: userList ?? this.userList,
      isLogin: isLogin ?? this.isLogin,
      gameList: gameList ?? this.gameList,
      gameStatus: gameStatus ?? this.gameStatus,
      countDownWaitingRoom: countDownWaitingRoom ?? this.countDownWaitingRoom,
      countDownJoinRoom: countDownJoinRoom ?? this.countDownJoinRoom,
      userPoint: userPoint ?? this.userPoint,
      userGiftsIds: userGiftsIds ?? this.userGiftsIds,
      giftsList: giftsList ?? this.giftsList,
      visible: visible ?? this.visible,
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

enum DeleteAccountStates {
  initial,
  loading,
  completed,
  error,
}

enum GiftsStates {
  initial,
  loading,
  completed,
  error,
}

enum ClaimGiftStates {
  initial,
  loading,
  completed,
  error,
}
