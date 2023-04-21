import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:sigest/api/abstract_api.dart';
import 'package:sigest/api/api.dart';
import 'package:sigest/api/params.dart';
import 'package:sigest/models/auth.dart';
import 'package:sigest/stock/abstract_stock.dart';
import 'package:sigest/stock/hive_repository.dart';
import 'package:stock/stock.dart';

import '../api/response.dart';
import 'abstract_repository.dart';

@Named('auth')
@Singleton(as: AbstractRepository)
class AuthRepository extends HiveRepository<AuthModel> {
  @override
  String get name => 'auth';
  // Box<AuthModel> store = Hive.box(name);
  String get refreshToken => get('auth')?.refreshToken['token'] ?? '';
  String get family => get('auth')?.refreshToken['family'] ?? '';
  String get accessToken => get('auth')?.accessToken ?? '';
  set tokens(AuthModel auth) => update('auth', auth);

  Future<Response> login(Params params) async {
    Response response = await api.login(params);

    if (response is SuccessResponse) {
      tokens = AuthModel.fromJson(response.data);
    }

    return response;
  }

  Future<Response> register(Params params) async {
    return await api.register(params);
    // return response;
  }

  Future<Response> sendCode(Params params) async {
    Response response = await api.sendCode(params);
    return response;
  }

  Future<Response> resetPassword(Params resetParams) async {
    Response response = await api.resetPassword(resetParams);

    if (response is SuccessResponse) {
        tokens = AuthModel.fromJson(response.data);
    }

    return response;
  }

  Future<Response> activateProfile(Params activateParams) async {
    Response response = await api.activateProfile(activateParams);

    if (response is SuccessResponse) {
        tokens = AuthModel.fromJson(response.data);
    }

    return response;
  }
}
