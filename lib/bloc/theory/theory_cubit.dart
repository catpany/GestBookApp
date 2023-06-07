import 'dart:developer';

import 'package:meta/meta.dart';

import '../../api/response.dart';
import '../main_cubit.dart';

part 'theory_state.dart';

class TheoryCubit extends MainCubit {
  String lessonId;

  @override
  List<String> get preloadStores => ['lessonInfo'];

  TheoryCubit({required this.lessonId}) : super();

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
      emit(DataLoaded());
    }, onError: (error, StackTrace stacktrace) {
      log(error.toString());
      checkForError(error.error as ErrorResponse);
    });
  }
}
