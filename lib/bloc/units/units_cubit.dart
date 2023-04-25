import 'dart:developer';
import 'dart:math';

import 'package:async/async.dart';
import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'package:sigest/models/lesson.dart';
import 'package:sigest/models/units.dart';
import 'package:sigest/stock/units.dart';

import '../../stock/abstract_stock.dart';
import '../main_cubit.dart';

part 'units_state.dart';

class UnitsCubit extends MainCubit {
  UnitsCubit() : super();

  @override
  List<String> get preloadStores => ['units', 'user', 'lessons'];

  // String get gesturesLearned => {
  //   this.store.
  // };

  void onStartLesson(String id) {
    // var rng = Random();
    // print(rng.nextInt(100));
    LessonModel? lesson = store.lessons.get(id);
    print(lesson?.toJson().toString());
    if (lesson != null && lesson.levelsFinished<lesson.levelsTotal) {
      lesson.levelsFinished ++;
    } else if (lesson != null && lesson.levelsFinished == lesson.levelsTotal) {
      lesson.levelsFinished = 0;
    }
  }
}
