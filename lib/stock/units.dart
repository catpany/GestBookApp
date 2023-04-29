import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:sigest/models/lesson.dart';
import 'package:sigest/stock/hive_stock.dart';
import 'package:sigest/stock/lessons.dart';
import 'package:stock/stock.dart';

import '../api/response.dart';
import '../locator.dart';
import '../models/unit.dart';
import '../models/units.dart';
import 'abstract_repository.dart';

@Named('units')
@LazySingleton(as: AbstractRepository)
class UnitsRepository extends HiveStock<UnitsModel> {
  @override
  String get name => 'units';

  UnitsModel get units => get('units') as UnitsModel;

  @override
  Future<UnitsModel> loadModel(String key) async {
    Response response = await api.units();

    if (response is ErrorResponse) {
      throw StockResponseError(ResponseOrigin.fetcher, response);
    }

    response = response as SuccessResponse;

    List<UnitModel> units = [];

    for(var unit in response.data['list']) {
      LessonRepository rep = locator.get<AbstractRepository>(instanceName: 'lessons') as LessonRepository;
      await rep.init();
      List<LessonModel> lessons = [];
      for(var lesson in unit['lessons']) {
        LessonModel lessonItem = LessonModel.fromJson(lesson);
        rep.put(lessonItem.id, lessonItem);
        lessons.add(lessonItem);
      }

      UnitModel unitItem = UnitModel(id: unit['id'], order: unit['order'], lessons: HiveList(rep.store, objects: lessons));
      units.add(unitItem);
    }

    return UnitsModel(items: units);
  }
}
