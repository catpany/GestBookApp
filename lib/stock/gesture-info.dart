import 'dart:developer';

import 'package:injectable/injectable.dart';
import 'package:sigest/models/gesture-info.dart';
import 'package:sigest/stock/hive_stock.dart';
import 'package:stock/stock.dart';

import '../api/params.dart';
import '../api/response.dart';
import 'abstract_repository.dart';

@Named('gestureInfo')
@LazySingleton(as: AbstractRepository)
class GestureInfoRepository extends HiveStock<GestureInfoModel> {
  @override
  String get name => 'gestureInfo';
  GestureInfoModel get gestureInfo => get('gestureInfo') as GestureInfoModel;
  set gestureInfo(GestureInfoModel gesture) => store.put('gestureInfo', gesture);
  late String id;

  @override
  Future<GestureInfoModel> load(String key, Params? params) async {
    this.params = params;
    id = key;
    return stock.get(name);
  }

  @override
  Future<GestureInfoModel> reload(String key, Params? params) async {
    this.params = params;
    id = key;
    return stock.fresh(name);
  }

  @override
  Future<GestureInfoModel> loadModel(String key) async {
    Response response = await api.gesture(id);

    if (response is ErrorResponse) {
      throw StockResponseError(ResponseOrigin.fetcher, response);
    }

    response = response as SuccessResponse;
    return GestureInfoModel.fromJson(response.data);
  }
}
