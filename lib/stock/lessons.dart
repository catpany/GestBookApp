import 'dart:developer';

import 'package:injectable/injectable.dart';
import 'package:sigest/models/lesson.dart';
import 'package:sigest/stock/hive_repository.dart';

import '../api/response.dart';
import 'abstract_repository.dart';

@Named('lessons')
@LazySingleton(as: AbstractRepository)
class LessonRepository extends HiveRepository<LessonModel> {
  @override
  String get name => 'lessons';

  Future<void> finishLevel(String levelId, String lessonId) async {
    LessonModel? lesson = get(lessonId);

    if (lesson != null) {
      lesson.levelsFinished ++;
      lesson.save();

      Response response = await api.finishLevel(levelId);

      if (response is ErrorResponse) {
        lesson.levelsFinished --;
        lesson.save();
      }
    }
  }
}