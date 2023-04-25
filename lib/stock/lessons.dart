import 'package:injectable/injectable.dart';
import 'package:sigest/models/lesson.dart';
import 'package:sigest/stock/hive_repository.dart';

import 'abstract_repository.dart';

@Named('lessons')
@LazySingleton(as: AbstractRepository)
class LessonRepository extends HiveRepository<LessonModel> {
  @override
  String get name => 'lessons';
}