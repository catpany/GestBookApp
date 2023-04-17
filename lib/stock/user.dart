import 'dart:convert';
import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:sigest/stock/abstract_stock.dart';
import 'package:sigest/models/user.dart';
import 'package:sigest/stock/hive_stock.dart';
import 'package:stock/stock.dart';

import '../api/api.dart';
import '../api/params.dart';
import '../api/response.dart';
import 'abstract_repository.dart';

@Named('user')
@LazySingleton(as: AbstractRepository)
class UserRepository extends HiveStock<UserModel> {
  @override
  String get name => 'user';

  // static const String name = 'user';
  UserModel get user => get('user') as UserModel;

  // @override
  // Box<UnitsModel> get store => Hive.box(name);

  @override
  Future<UserModel> loadModel(String key) async {
    // final box = Hive.isBoxOpen(name.toString())? Hive.box<UserModel>(name.toString()) : await Hive.openBox<UserModel>(name.toString());
    // box.clear();
    Response response = await api.user(key);

    if (response is ErrorResponse) {
      log('Load Error');
      throw StockResponseError(ResponseOrigin.fetcher, response);
    }
    response = response as SuccessResponse;
    return UserModel.fromJson(response.data);
  }
}
