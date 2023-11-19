part of 'exercise_cubit.dart';

@immutable
abstract class LessonState extends MainState {}

class LevelStarted extends LessonState {}

class LevelCompleted extends LessonState {}

class StartNextExercise extends LessonState {}

class ExercisePassed extends LessonState {}

class ExerciseFailed extends LessonState {}

class StartNewLevel extends LessonState {}

class QuitLevel extends LessonState {}

class WrongMatchAnswer extends LessonState {}

class CorrectMatchAnswer extends LessonState {}

class ProcessingMatchAnswer extends LessonState {}

class ImpactModeUpdated extends LessonState {}
