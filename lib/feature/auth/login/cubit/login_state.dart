import 'package:equatable/equatable.dart';
import 'package:flutter_base_app/feature/auth/login/model/user_model.dart';

class LoginState extends Equatable {
  LoginState({
    required this.loginState,
    required this.getUserState,
    required this.errorMessage,
    required this.message,
    required this.userList,
  });
  factory LoginState.initial() {
    return LoginState(
      loginState: LoginStates.initial,
      getUserState: GetUserStates.initial,
      errorMessage: '',
      message: '',
      userList: [],
    );
  }
  final LoginStates loginState;
  final GetUserStates getUserState;
  final String errorMessage;
  final String message;
  List<UserModel> userList;

  @override
  List<Object?> get props => [loginState, getUserState, errorMessage, message, userList];

  LoginState copyWith({
    LoginStates? loginState,
    GetUserStates? getUserState,
    String? errorMessage,
    String? message,
    List<UserModel>? userList,
  }) {
    return LoginState(
      loginState: loginState ?? this.loginState,
      getUserState: getUserState ?? this.getUserState,
      errorMessage: errorMessage ?? this.errorMessage,
      message: message ?? this.message,
      userList: userList ?? this.userList,
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
