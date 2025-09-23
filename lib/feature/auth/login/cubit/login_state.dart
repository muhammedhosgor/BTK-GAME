import 'package:equatable/equatable.dart';

class LoginState extends Equatable {
  const LoginState({
    required this.loginState,
    required this.errorMessage,
    required this.message,
  });
  factory LoginState.initial() {
    return const LoginState(
      loginState: LoginStates.initial,
      errorMessage: '',
      message: '',
    );
  }
  final LoginStates loginState;
  final String errorMessage;
  final String message;

  @override
  List<Object?> get props => [LoginStates, errorMessage, message];

  LoginState copyWith({
    LoginStates? loginState,
    String? errorMessage,
    String? message,
  }) {
    return LoginState(
      loginState: loginState ?? this.loginState,
      errorMessage: errorMessage ?? this.errorMessage,
      message: message ?? this.message,
    );
  }
}

enum LoginStates {
  initial,
  loading,
  completed,
  error,
}
