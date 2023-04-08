import 'dart:developer';

import 'package:sigest/stock/abstract_stock.dart';
import 'package:stock/stock.dart';

import '../api.dart';
import '../models/units.dart';

class UnitsRepository extends AbstractStock<UnitsModel> {
  UnitsRepository() : super();

    @override
    String get name => 'units';

    @override
    Future<UnitsModel> load(String key) async {
      Response response = await Api().units();

      if(response is ErrorResponse) {
        log('Load Error');
        throw StockResponseError(ResponseOrigin.fetcher, response);
      }

      response = response as SuccessResponse;
      return UnitsModel.fromJson({'items': response.data['units']});
    }
  }