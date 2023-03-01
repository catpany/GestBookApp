part of 'auth_cubit.dart';

@immutable
class AuthState extends MainState {
}

class AuthInitial extends AuthState {
}

class AuthDataLoading extends AuthState {
}

class AuthDataReceived extends AuthState {
  final dynamic data;

  AuthDataReceived({required this.data});
}

class AuthDataLoadingError extends AuthState {
  final String message;

  AuthDataLoadingError(this.message);
}

class AuthError extends AuthState {
  final ErrorResponse error;

  AuthError(this.error);

  @override
  List<Object> get props => [error];
}

class AuthSuccess extends AuthState {}