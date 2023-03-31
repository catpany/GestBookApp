import 'dart:convert';
import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:sigest/stock/abstract_stock.dart';
import 'package:sigest/models/user.dart';
import 'package:stock/stock.dart';

import '../api.dart';

class UserRepository extends AbstractStock<UserModel> {
  UserRepository() : super();

  @override
  String get name => 'user';

  @override
  Future<UserModel> load(String key) async {
    // final box = Hive.isBoxOpen(name.toString())? Hive.box<UserModel>(name.toString()) : await Hive.openBox<UserModel>(name.toString());
    // box.clear();
    Response response = await Api().user();

    if (response is ErrorResponse) {
      log('Load Error');
      throw StockResponseError(ResponseOrigin.fetcher, response);
    }
    response = response as SuccessResponse;
    return UserModel.fromJson(response.data);
  }

  void updateUser(String id, Object data) {}
}
