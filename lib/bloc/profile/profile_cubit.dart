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

  void quit() {
    log('quit');
    store.clear();
    store.settings.delete('current');

    log('emit quit');

    emit(ProfileQuited());
  }
}
