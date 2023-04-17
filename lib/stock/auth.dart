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
@LazySingleton(as: AbstractRepository)
class AuthRepository extends HiveRepository<AuthModel> {
  @override
  String get name => 'auth';
  // Box<AuthModel> store = Hive.box(name);
  String get refreshToken => get('auth')?.refreshToken['token'] ?? '';
  String get family => get('auth')?.refreshToken['family'] ?? '';
  String get accessToken => get('auth')?.accessToken ?? '';
  set tokens(AuthModel auth) => update('auth', auth);

  // void setAuth(Map<String, dynamic> data) {
  //   // final authBox = await Hive.openBox<AuthModel>(name);
  //   AuthModel model = AuthModel.fromJson(data);
  //   store.put('auth', model);
  // }
  //
  // AuthModel? getAuth() {
  //   // final authBox = await Hive.openBox<AuthModel>('auth');
  //   return store.get('auth');
  // }

  Future<Response> login(Params params) async {
    Response response = await api.login(params);
    return response;
  }

  Future<Response> register(Params params) async {
    return await api.register(params);
    // return response;
  }

  Future<Response> forgotPassword(Params params) async {
    Response response = await api.forgotPassword(params);
    return response;
  }

  Future<Response> resendCode(Params params) async {
    Response response = await api.forgotPassword(params);
    return response;
  }

  Future<Response> resetPassword(Params resetParams, Params loginParams) async {
    Response response = await api.resetPassword(resetParams);

    if (response is SuccessResponse) {
      // response = await api.login(loginParams);
      //
      // if (response is SuccessResponse) {
        tokens = AuthModel.fromJson(response.data);
      // }
    }

    return response;
  }

  Future<Response> activateProfile(Params activateParams, loginParams) async {
    Response response = await api.activateProfile(activateParams);

    if (response is SuccessResponse) {
      response = await api.login(loginParams);

      if (response is SuccessResponse) {
        tokens = AuthModel.fromJson(response.data);
      }
    }

    return response;
  }
  //
  // Future<void> setTokens(SuccessResponse response) async {
  //   AuthRepository auth = AuthRepository();
  //
  //   auth.setAuth(response.data);
  // }

}
