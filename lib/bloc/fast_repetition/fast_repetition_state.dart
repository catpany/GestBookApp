part of 'fast_repetition_cubit.dart';

@immutable
abstract class FastRepetitionState extends MainState {}

class FastRepetitionInitial extends FastRepetitionState {}

class FastRepetitionStarted extends FastRepetitionState {}

class FastRepetitionCompleted extends FastRepetitionState {}

class ExercisePassed extends FastRepetitionState {}

class ExerciseFailed extends FastRepetitionState {}

class StartNextExercise extends FastRepetitionState {}

class QuitFastRepetition extends FastRepetitionState {}