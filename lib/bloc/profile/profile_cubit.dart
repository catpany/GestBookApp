import 'dart:developer';

import 'package:meta/meta.dart';
import 'package:sigest/bloc/main_cubit.dart';

part 'profile_state.dart';

class ProfileCubit extends MainCubit {
  ProfileCubit() : super();

  @override
  List<String> get preloadStores => ['units', 'lessons', 'user', 'settings'];

  int getAllLessonsNumber() {
    int count = 0;
    for (var unit in store.units.units.items) {
      count += unit.lessons.length;
    }

    return count;
  }

  int getFinishedLessons() {
    int count = 0;

    for (var unit in store.units.units.items) {
      for (var lesson in unit.lessons) {
        if (lesson.levelsTotal == lesson.levelsFinished) {
          count ++;
        }
      }
    }

    return count;
  }

  void quit() {
    store.clear();
    store.settings.delete('current');
    emit(ProfileQuited());
  }
}
