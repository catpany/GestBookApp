import 'dart:developer';

import 'package:sigest/models/lesson.dart';

import '../../api/response.dart';
import '../../models/exercise.dart';
import '../../models/gesture-info.dart';
import '../../models/level.dart';
import '../main_cubit.dart';

import 'package:meta/meta.dart';

part 'exercise_state.dart';

class LessonCubit extends MainCubit {
  String lessonId;
  int currentExerciseIndex = 0;
  int levelOrder;
  late LevelModel currentLevel;
  int completed = 0;
  Map<String, GestureInfoModel> gestures = {};
  List<int> failedExercises = [];

  @override
  List<String> get preloadStores => ['lessonInfo', 'user', 'lessons'];

  ExerciseModel get currentExercise =>
      currentLevel.exercises[currentExerciseIndex];

  double get progress => completed / currentLevel.exercises.length;

  LessonCubit({required this.lessonId, required this.levelOrder}) : super();

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

  Future<void> loadLessonInfo() async {
    store.lessonInfo.reload(lessonId, null).then((value) {
      loadNewLevel();

      emit(LevelStarted());
    }, onError: (error, StackTrace stacktrace) {
      log(error.toString());
      checkForError(error.error as ErrorResponse);
    });
  }

  void loadNewLevel() {
    currentLevel = store.lessonInfo.lessonInfo.levels
        .singleWhere((level) => level.order == levelOrder);

    for (var gesture in store.lessonInfo.lessonInfo.gestures) {
      gestures[gesture.id] = gesture;
    }
  }

  Future<void> saveStats() async {
    Map<String, dynamic> newStats = store.user.user.stat;
    newStats['goal_achieved'] += getLearnedGestures();
    newStats['impact_mode'] = getImpactMode();
    newStats['lessons_total'] = getLessonsTotal();
    newStats['last_level_passed'] = DateTime.now().toUtc().toString();

    await store.user.updateStats(newStats);
  }

  int getLessonsTotal() {
    if (isLastLevel()) {
      return store.user.user.stat['lessons_total'] + 1;
    }

    return store.user.user.stat['lessons_total'];
  }

  int getImpactMode() {
    if (!store.user.lastLevelPassedToday()) {
      return store.user.user.stat['impact_mode'] + 1;
    }

    return store.user.user.stat['impact_mode'];
  }

  int getLearnedGestures() {
    return currentLevel.exercises
        .where((ExerciseModel exercise) => exercise.type == 1)
        .length;
  }

  bool isNewLevel() {
    LessonModel? lesson = store.lessons.get(lessonId);
    if (lesson != null) {
      if (currentLevel.order > lesson.levelsFinished) {
        return true;
      }
    }

    return false;
  }

  Future<void> startNextLevel() async {
    await finishLevel();
    levelOrder++;
    loadNewLevel();
    currentExerciseIndex = 0;
    failedExercises = [];
    completed = 0;
    emit(LevelStarted());
  }

  void checkImpactModeBeforeStart() {
    if (!store.user.lastLevelPassedToday()) {
      emit(ImpactModeUpdated());
    } else {
      startNextLevel();
    }
  }

  Future<void> finishLevel() async {
    if (isNewLevel()) {
      emit(DataLoading());
      await store.lessons.finishLevel(currentLevel.id, lessonId);
      await saveStats();
    }
  }

  Future<void> quitLevel() async {
    await finishLevel();
    emit(QuitLevel());
  }

  bool isLastLevel() {
    return store.lessonInfo.lessonInfo.levels.length == levelOrder;
  }

  void next() {
    if (completed == currentLevel.exercises.length &&
        failedExercises.isEmpty) {
      emit(LevelCompleted());
    } else if (failedExercises.isNotEmpty &&
        completed == currentLevel.exercises.length - failedExercises.length) {
      currentExerciseIndex = failedExercises.first;
      emit(StartNextExercise());
    } else {
      currentExerciseIndex++;
      emit(StartNextExercise());
    }
  }

  Map<String, GestureInfoModel> getGesturesOptions() {
    Map<String, GestureInfoModel> options = {};

    for (String option in currentExercise.options + currentExercise.answers) {
      options[option] = gestures[option]!;
    }

    return options;
  }

  Map<String, GestureInfoModel> getGesturesAnswers() {
    Map<String, GestureInfoModel> answers = {};

    for (String answer in currentExercise.answers) {
      answers[answer] = gestures[answer]!;
    }

    return answers;
  }

  void addToFailed() {
    if (failedExercises.contains(currentExerciseIndex)) {
      failedExercises.remove(currentExerciseIndex);
    }

    failedExercises.add(currentExerciseIndex);
  }

  void completeExercise() {
    if (failedExercises.contains(currentExerciseIndex)) {
      failedExercises.remove(currentExerciseIndex);
    }

    completed++;
  }

  bool checkChooseWordEx(List<String> selectedAnswers) {
    if (selectedAnswers.length != currentExercise.answers.length) {
      addToFailed();
      emit(ExerciseFailed());

      return false;
    }

    for (int i = 0; i < selectedAnswers.length; i++) {
      if (selectedAnswers[i] != currentExercise.answers[i]) {
        addToFailed();
        emit(ExerciseFailed());

        return false;
      }
    }

    completeExercise();
    emit(ExercisePassed());

    return true;
  }

  String getAnswer() {
    String answer = '';

    for (String answerId in currentExercise.answers) {
      String? name = gestures[answerId]?.name;
      answer = answer + ' ' + (name ?? '');
    }

    return answer;
  }

  void checkNewWordEx() {
    completeExercise();
    emit(ExercisePassed());
  }

  bool checkChooseGestEx(String selectedId) {
    if (currentExercise.answers[0] != selectedId) {
      addToFailed();
      emit(ExerciseFailed());

      return false;
    }

    completeExercise();
    emit(ExercisePassed());

    return true;
  }

  void checkYesNoEx(bool isCorrect) {
    if (currentExercise.options[0] == currentExercise.answers[0]) {
      if (true == isCorrect) {
        completeExercise();
        emit(ExercisePassed());
      } else {
        addToFailed();
        emit(ExerciseFailed());
      }
    } else {
      if (false == isCorrect) {
        completeExercise();
        emit(ExercisePassed());
      } else {
        addToFailed();
        emit(ExerciseFailed());
      }
    }
  }

  bool checkMatchEx(List<String> matched) {
    if (matched.length == currentExercise.answers.length) {
      completeExercise();
      emit(ExercisePassed());
      return true;
    }

    return false;
  }

  void wrongAnswer() {
    emit(WrongMatchAnswer());
  }

  void correctAnswer() {
    emit(CorrectMatchAnswer());
  }

  void processingMatchAnswer() {
    emit(ProcessingMatchAnswer());
  }
}
