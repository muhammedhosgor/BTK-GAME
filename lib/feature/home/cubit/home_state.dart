import 'package:equatable/equatable.dart';

class HomeState extends Equatable {
  HomeState({
    required this.homeState,
    required this.errorMessage,
    required this.message,
  });

  factory HomeState.initial() {
    return HomeState(
      homeState: HomeStates.initial,
      errorMessage: '',
      message: '',
    );
  }

  final HomeStates homeState;
  final String errorMessage;
  final String message;

  @override
  List<Object?> get props => [homeState, errorMessage, message];

  HomeState copyWith({
    HomeStates? homeState,
    String? errorMessage,
    String? message,
  }) {
    return HomeState(
      homeState: homeState ?? this.homeState,
      errorMessage: errorMessage ?? this.errorMessage,
      message: message ?? this.message,
    );
  }
}

enum HomeStates {
  initial,
  loading,
  completed,
  error,
}