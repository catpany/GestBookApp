part of 'main_cubit.dart';

@immutable
abstract class MainState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MainInitial  extends MainState {}

class DataLoading extends MainState {
}

class DataLoaded extends MainState {
}

class DataReceived extends MainState {
  final dynamic data;

  DataReceived({required this.data});
}

class DataLoadingError extends MainState {
  final ErrorResponse error;

  DataLoadingError(this.error);
}

class Error extends MainState {
  final ErrorResponse error;

  Error(this.error);

  @override
  List<Object> get props => [error];
}

class NotificationShow extends MainState {}

class NotificationShowed extends MainState {}
