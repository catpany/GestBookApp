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

class CodeSent extends AuthState {
  final String username;

  CodeSent(this.username);

  @override
  List<Object> get props => [username];
}

class CodeResent extends AuthState {
  final String message;

  CodeResent(this.message);

  @override
  List<Object> get props => [message];
}

class NeedToActivate extends AuthState {
  final String username;
  final String password;

  NeedToActivate(this.username, this.password);

  @override
  List<Object> get props => [username, password];
}

class AuthSuccess extends AuthState {}