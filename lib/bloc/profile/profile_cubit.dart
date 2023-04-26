import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'package:sigest/bloc/main_cubit.dart';

import '../../models/unit.dart';
import '../../models/user.dart';
import '../../stock/user.dart';

part 'profile_state.dart';

class ProfileCubit extends MainCubit {
  ProfileCubit() : super();

  @override
  List<String> get preloadStores => ['units', 'lessons', 'user'];

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
    log('emit quit');

    emit(ProfileQuited());
  }
}
