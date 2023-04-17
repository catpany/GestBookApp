import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:sigest/api/params.dart';
import 'package:sigest/api/response.dart';
import 'package:sigest/locator.dart';
import 'package:sigest/stock/auth.dart';

import '../stock/abstract_repository.dart';
import 'abstract_api.dart';

@production
@LazySingleton(as: AbstractApi)
class Api implements AbstractApi {
  final String _prefix = '/api';
  final String _version = '/v1';
  final String _host = '172.16.0.1';
  late AuthRepository auth;

  Api() {
    auth = locator.get<AbstractRepository>(instanceName: 'auth') as AuthRepository;
  }

  Future<bool> refreshAuthTokens() async {
    http.Response response = await request(
        method: 'post',
        uri: '/auth/token/refresh',
        headers: {},
      params: Params({}, {
        'token': auth.refreshToken,
        'family': auth.family
      })
    );

    if (response.isError()) {
      return false;
    }

    SuccessResponse successResponse = response.getSuccessResponse();

    auth.update('auth', successResponse.data);

    return true;
  }

  Future<Response> make(
      {required String method,
        required String uri,
        required Map<String, String> headers,
        Params? params,
        bool authorized = true}) async {
    http.Response response;

    if (authorized) {
      headers['Authorization'] = 'Bearer:' + auth.accessToken;
    }

    headers['Content-Type'] = 'application/json; charset=UTF-8;';
    headers['Accept'] = 'application/json;';

    response =
    await request(method: method, uri: uri, headers: headers, params: params);

    if (response.isError()) {
      ErrorResponse error = response.getErrorResponse();

      if (codeErrors[error.code] == ApiErrors.notAuthorized) {
        bool isRefreshed = await refreshAuthTokens();

        if (isRefreshed) {
          response = await request(
              method: method, uri: uri, headers: headers, params: params);

          if (response.isError()) {
            return response.getErrorResponse();
          }

          return response.getSuccessResponse();
        }
      }

      return error;
    }

    return response.getSuccessResponse();
  }

  Future<http.Response> request(
      {required String method,
        required String uri,
        required Map<String, String> headers,
        Params? params}) async {
    if ('post' == method) {
      return await http.post(Uri.http(_host, _prefix + _version + uri, params?.query),
          headers: headers, body: jsonEncode(params?.body));
    } else if ('get' == method) {
      return await http.get(
        Uri.http(_host, _prefix + _version + uri, params?.query),
        headers: headers,
      );
    } else {
      throw Exception('Invalid method');
    }
  }

  @override
  Future<Response> login(Params params) async {
    return make(method: 'post', uri: '/auth/login', headers: {}, params: params);
  }

  @override
  Future<Response> register(Params params) async {
    return make(method: 'post', uri: '/auth/register', headers: {}, params: params);
  }

  @override
  Future<Response> forgotPassword(Params params) async {
    return make(method: 'post', uri: '/auth/code/send', headers: {}, params: params);
  }

  @override
  Future<Response> resetPassword(Params params) async {
    return make(method: 'post', uri: '/auth/password/reset', headers: {}, params: params);
  }

  @override
  Future<Response> activateProfile(Params params) async {
    return make(method: 'post', uri: '/auth/email/verify', headers: {}, params: params);
  }

  @override
  Future<Response> user(String userId) async {
    return make(method: 'get', uri: '/user?userId=' + userId, headers: {});
  }

  @override
  Future<Response> units() async {
    return make(method: 'get', uri: '/units', headers: {});
  }
}
