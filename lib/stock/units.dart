import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:sigest/api/abstract_api.dart';
import 'package:sigest/stock/abstract_stock.dart';
import 'package:sigest/stock/hive_source_of_truth.dart';
import 'package:sigest/stock/hive_stock.dart';
import 'package:stock/stock.dart';

import '../api/response.dart';
import '../models/units.dart';
import 'abstract_repository.dart';

@Named('units')
@LazySingleton(as: AbstractRepository)
class UnitsRepository extends HiveStock<UnitsModel> {
  @override
  String get name => 'units';

  // static const String name = 'units';
  UnitsModel get units => get('units') as UnitsModel;

  //
  // @override
  // Box<UnitsModel> get store => Hive.box(name);

  // @override
  // Future<UnitsModel> load(String key, Params params) async {
  //   this.params = params;
  //   return stock.get(key) as UnitsModel;
  // }

  @override
  Future<UnitsModel> loadModel(String key) async {
    Response response = await api.units();

    if (response is ErrorResponse) {
      log('Load Error');
      throw StockResponseError(ResponseOrigin.fetcher, response);
    }

    response = response as SuccessResponse;
    return UnitsModel.fromJson({'items': response.data['units']});
  }
}
