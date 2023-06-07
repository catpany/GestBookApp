import 'dart:developer';

import 'package:injectable/injectable.dart';
import 'package:sigest/stock/hive_stock.dart';
import 'package:stock/stock.dart';

import '../api/params.dart';
import '../api/response.dart';
import '../models/lesson-info.dart';
import 'abstract_repository.dart';

@Named('lessonInfo')
@LazySingleton(as: AbstractRepository)
class LessonInfoRepository extends HiveStock<LessonInfoModel> {
  @override
  String get name => 'lessonInfo';
  LessonInfoModel get lessonInfo => get('lessonInfo') as LessonInfoModel;
  set lessonInfo(LessonInfoModel gesture) => store.put('lessonInfo', gesture);
  late String id;

  @override
  Future<LessonInfoModel> load(String key, Params? params) async {
    this.params = params;
    id = key;
    return stock.get(name);
  }

  @override
  Future<LessonInfoModel> reload(String key, Params? params) async {
    this.params = params;
    id = key;
    LessonInfoModel? lesson = get('lessonInfo');
    if (lesson == null || lesson.id != key) {
      return stock.fresh(name);
    }

    return lesson;
  }

  @override
  Future<LessonInfoModel> loadModel(String key) async {
    Response response = await api.lesson(id);

    if (response is ErrorResponse) {
      throw StockResponseError(ResponseOrigin.fetcher, response);
    }

    response = response as SuccessResponse;
    return LessonInfoModel.fromJson(response.data);
  }
}
