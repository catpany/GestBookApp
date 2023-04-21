part of 'auth_cubit.dart';

@immutable
class AuthState extends MainState {
}

class CodeSent extends AuthState {
  final String login;

  CodeSent(this.login);

  @override
  List<Object> get props => [login];
}

class CodeResent extends AuthState {
  final String message;

  CodeResent(this.message);

  @override
  List<Object> get props => [message];
}

class NeedToActivate extends AuthState {
  final String login;
  final String password;

  NeedToActivate(this.login, this.password);

  @override
  List<Object> get props => [login, password];
}

class AuthSuccess extends AuthState {}