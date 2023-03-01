import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart';
import 'package:sigest/stock/abstract_stock.dart';
import 'package:sigest/models/user.dart';

import '../api.dart';

class UserStock extends AbstractStock<UserModel?> {

  UserStock() : super(name: 'user');

  @override
  Future<UserModel?> load(String key) async {
    Response response = await Api.user(key);

    if(response.isError()) {
      log('Load Error');
      return null;
    } else {
      return UserModel.fromJson(jsonDecode(response.body)['data']);
    }
  }

}


