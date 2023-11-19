import 'dart:developer';

import 'package:meta/meta.dart';

import '../../api/response.dart';
import '../../models/exercise.dart';
import '../../models/gesture-info.dart';
import '../main_cubit.dart';

part 'fast_repetition_state.dart';

class FastRepetitionCubit extends MainCubit {
  String lessonId;
  List<ExerciseModel> exercises = [];
  int passedExercises = 0;
  int failedExercises = 0;
  int currentExerciseIndex = 0;

  ExerciseModel get currentExercise => exercises[currentExerciseIndex];
  Map<String, GestureInfoModel> gestures = {};

  @override
  List<String> get preloadStores => ['lessonInfo'];

  FastRepetitionCubit({required this.lessonId}) : super();

  double get progress => currentExerciseIndex / (exercises.length);

  @override
  Future<void> load() async {
    emit(DataLoading());
    store.load().then((value) async {
      await loadLessonInfo();
    }, onError: (error, StackTrace stackTrace) {
      log(error.toString());
      checkForError(error.error as ErrorResponse);
    });
  }

  Future<void> loadFastRepetitionInfo() async {
    store.lessonInfo.getFastRepetition(lessonId).then((List<dynamic> data) {
      for (int i = 0; i < data.length; i++) {
        exercises.add(ExerciseModel(
            id: i.toString(),
            type: data[i]['type'],
            answers: List<String>.from(data[i]['answers']),
            options: List<String>.from(data[i]['options'])));
      }
      emit(FastRepetitionStarted());
    }, onError: (error, StackTrace stacktrace) {
      log(error.toString());
      checkForError(error.error as ErrorResponse);
    });
  }

  Future<void> loadLessonInfo() async {
    store.lessonInfo.reload(lessonId, null).then((value) async {
      for (var gesture in store.lessonInfo.lessonInfo.gestures) {
        gestures[gesture.id] = gesture;
      }

      await loadFastRepetitionInfo();
    }, onError: (error, StackTrace stacktrace) {
      log(error.toString());
      checkForError(error.error as ErrorResponse);
    });
  }

  Map<String, GestureInfoModel> getGesturesOptions() {
    Map<String, GestureInfoModel> options = {};
    log(gestures.toString());

    for (String option in currentExercise.options + currentExercise.answers) {
      log(option);
      options[option] = gestures[option]!;
    }

    return options;
  }

  String getAnswer() {
    String answer = '';

    for (String answerId in currentExercise.answers) {
      String? name = gestures[answerId]?.name;
      answer = answer + ' ' + (name ?? '');
    }

    return answer;
  }

  void next() {
    if (currentExerciseIndex == exercises.length - 1) {
      emit(FastRepetitionCompleted());
    } else {
      currentExerciseIndex++;
      emit(StartNextExercise());
    }
  }

  Future<void> saveBestTime(int time) async {
    int? bestTime = store.lessonInfo.lessonInfo.bestTime;

    if ((bestTime == null || time < bestTime) && failedExercises == 0) {
      emit(DataLoading());
      await store.lessonInfo.updateFastRepetition(lessonId, time);
    }
  }

  Future<void> restartFastRepetition(int time) async {
    await saveBestTime(time);
    passedExercises = 0;
    failedExercises = 0;
    currentExerciseIndex = 0;

    emit(FastRepetitionStarted());
  }

  Future<void> finishFastRepetition(int time) async {
    await saveBestTime(time);

    emit(QuitFastRepetition());
  }

  bool checkChooseWordEx(List<String> selectedAnswers) {
    if (selectedAnswers.length != currentExercise.answers.length) {
      failedExercises++;
      emit(ExerciseFailed());

      return false;
    }

    for (int i = 0; i < selectedAnswers.length; i++) {
      if (selectedAnswers[i] != currentExercise.answers[i]) {
        failedExercises++;
        emit(ExerciseFailed());

        return false;
      }
    }

    passedExercises++;
    emit(ExercisePassed());

    return true;
  }

  void checkYesNoEx(bool isCorrect) {
    if (currentExercise.options[0] == currentExercise.answers[0]) {
      if (true == isCorrect) {
        passedExercises++;
        emit(ExercisePassed());
      } else {
        failedExercises++;
        emit(ExerciseFailed());
      }
    } else {
      if (false == isCorrect) {
        passedExercises++;
        emit(ExercisePassed());
      } else {
        failedExercises++;
        emit(ExerciseFailed());
      }
    }
  }
}
