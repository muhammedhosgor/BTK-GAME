import 'dart:io';

import 'package:equatable/equatable.dart';

class RegisterState extends Equatable {
  RegisterState({
    required this.registerState,
    required this.loginState,
    required this.errorMessage,
    required this.message,
    required this.obscureText,
    required this.imageFile,
  });

  factory RegisterState.initial() {
    return RegisterState(
      registerState: RegisterStates.initial,
      loginState: LoginStates.initial,
      errorMessage: '',
      message: '',
      obscureText: false,
      imageFile: null,
    );
  }

  final RegisterStates registerState;
  final LoginStates loginState;
  final String errorMessage;
  final String message;
  final bool obscureText;
  File? imageFile;

  @override
  List<Object?> get props => [registerState, loginState, errorMessage, message, obscureText, imageFile];

  RegisterState copyWith({
    RegisterStates? registerState,
    LoginStates? loginState,
    String? errorMessage,
    String? message,
    bool? obscureText,
    File? imageFile,
  }) {
    return RegisterState(
      registerState: registerState ?? this.registerState,
      loginState: loginState ?? this.loginState,
      errorMessage: errorMessage ?? this.errorMessage,
      message: message ?? this.message,
      obscureText: obscureText ?? this.obscureText,
      imageFile: imageFile ?? this.imageFile,
    );
  }
}

enum RegisterStates {
  initial,
  loading,
  completed,
  error,
}

enum LoginStates {
  initial,
  loading,
  completed,
  error,
}
