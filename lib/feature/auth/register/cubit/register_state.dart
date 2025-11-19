import 'dart:io';

import 'package:equatable/equatable.dart';

class RegisterState extends Equatable {
  RegisterState({
    required this.registerState,
    required this.loginState,
    required this.resetEmailState,
    required this.otpState,
    required this.errorMessage,
    required this.message,
    required this.obscureText,
    required this.imageFile,
  });

  factory RegisterState.initial() {
    return RegisterState(
      registerState: RegisterStates.initial,
      loginState: LoginStates.initial,
      resetEmailState: resetEmailStates.initial,
      otpState: OtpStates.initial,
      errorMessage: '',
      message: '',
      obscureText: false,
      imageFile: null,
    );
  }

  final RegisterStates registerState;
  final LoginStates loginState;
  final OtpStates otpState;
  final resetEmailStates resetEmailState;
  final String errorMessage;
  final String message;
  final bool obscureText;
  File? imageFile;

  @override
  List<Object?> get props => [registerState, loginState, otpState, errorMessage, message, obscureText, imageFile];

  RegisterState copyWith({
    RegisterStates? registerState,
    LoginStates? loginState,
    OtpStates? otpState,
    resetEmailStates? resetEmailState,
    String? errorMessage,
    String? message,
    bool? obscureText,
    File? imageFile,
  }) {
    return RegisterState(
      registerState: registerState ?? this.registerState,
      loginState: loginState ?? this.loginState,
      resetEmailState: resetEmailState ?? this.resetEmailState,
      otpState: otpState ?? this.otpState,
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

enum OtpStates {
  initial,
  loading,
  completed,
  error,
}

enum resetEmailStates {
  initial,
  loading,
  completed,
  error,
}
