import 'dart:convert';
import 'dart:developer';

import 'package:injectable/injectable.dart';
import 'package:sigest/models/user.dart';
import 'package:sigest/stock/hive_stock.dart';
import 'package:stock/stock.dart';

import '../api/params.dart';
import '../api/response.dart';
import 'abstract_repository.dart';

@Named('user')
@LazySingleton(as: AbstractRepository)
class UserRepository extends HiveStock<UserModel> {
  @override
  String get name => 'user';
  UserModel get user => get('user') as UserModel;

  @override
  Future<UserModel> loadModel(String key) async {
    Response response = await api.user();

    if (response is ErrorResponse) {
      throw StockResponseError(ResponseOrigin.fetcher, response);
    }

    response = response as SuccessResponse;
    return UserModel.fromJson(response.data);
  }

  Future<Response> deleteUser() async {
    Response response = await api.deleteUser();

    return response;
  }

  Future<Response> updateUser(Params userParams) async {
    Response response = await api.updateUser(userParams);

    if (response is SuccessResponse) {
      UserModel user = this.user;
      user.email = response.data['email'];
      user.username = response.data['username'];
      user.save();
    }

    return response;
  }
}
