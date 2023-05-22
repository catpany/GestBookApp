import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sigest/api/params.dart';
import 'package:sigest/api/response.dart';
import 'package:sigest/locator.dart';
import 'package:sigest/main.dart';
import 'package:sigest/models/auth.dart';
import 'package:sigest/stock/auth.dart';

import '../stock/abstract_repository.dart';
import 'abstract_api.dart';

@production
@LazySingleton(as: AbstractApi)
class Api implements AbstractApi {
  final String _prefix = '/api';
  final String _version = '/v1';
  final String _host = config["domain"];
  var client = http.Dio();
  String saveVideoPath = '';
  String saveImagePath = '';

  Api() {
    loadPaths();
  }

  Future<void> loadPaths() async {
    Directory savePath = await getApplicationDocumentsDirectory();
    saveVideoPath = savePath.path + '/video/';
    saveImagePath = savePath.path + '/image/';
    log(saveVideoPath);
    log(saveImagePath);
  }

  AuthRepository get auth =>
      locator.get<AbstractRepository>(instanceName: 'auth') as AuthRepository;

  Future<bool> refreshAuthTokens() async {
    http.Response response = await request(
        method: 'post',
        uri: '/auth/token/refresh',
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        params:
            Params({}, {'token': auth.refreshToken, 'family': auth.family}));

    if (response.isError()) {
      log('not refreshed');
      return false;
    }

    log('refresh');

    SuccessResponse successResponse = response.getSuccessResponse();

    await auth.init();
    auth.tokens = AuthModel.fromJson(successResponse.data);

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
      await auth.init();
      headers['Authorization'] = 'Bearer ' + auth.accessToken;
    }

    headers['Content-Type'] = 'application/json';
    headers['Accept'] = 'application/json';
    log('make request');

    response = await request(
        method: method, uri: uri, headers: headers, params: params);
    log(response.toString());

    if (response.isError()) {
      ErrorResponse error = response.getErrorResponse();
      log(error.code.toString());

      if (codeErrors[error.code] == ApiErrors.notAuthorized) {
        log('refresh tokens');
        bool isRefreshed = await refreshAuthTokens();

        if (isRefreshed) {
          log('refreshed');
          headers['Authorization'] = 'Bearer ' + auth.accessToken;

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

  Future<http.Response<dynamic>> request(
      {required String method,
      required String uri,
      required Map<String, String> headers,
      Params? params}) async {
    if (params != null) log(jsonEncode(params.body).toString());
    log('http://' + _host + _prefix + _version + uri);
    try {
      switch (method) {
        case 'post':
          return await client
              .post('http://' + _host + _prefix + _version + uri,
                  queryParameters: params?.query,
                  options: http.Options(headers: headers),
                  data: jsonEncode(params?.body))
              .timeout(const Duration(seconds: 60));
        case 'get':
          return await client
              .get(
                'http://' + _host + _prefix + _version + uri,
                queryParameters: params?.query,
                options: http.Options(headers: headers),
              )
              .timeout(const Duration(seconds: 60));
        case 'put':
          return await client
              .put('http://' + _host + _prefix + _version + uri,
                  queryParameters: params?.query,
                  options: http.Options(headers: headers),
                  data: jsonEncode(params?.body))
              .timeout(const Duration(seconds: 60));
        case 'delete':
          return await client
              .delete('http://' + _host + _prefix + _version + uri,
                  queryParameters: params?.query,
                  options: http.Options(headers: headers),
                  data: jsonEncode(params?.body))
              .timeout(const Duration(seconds: 60));
        default:
          throw Exception('Invalid method');
      }
    } on http.DioError catch (error) {
      log(error.toString());
      return error.response ??
          http.Response(requestOptions: http.RequestOptions());
    }
  }

  @override
  Future<Response> login(Params params) async {
    return make(
        method: 'post', uri: '/auth/login', headers: {}, params: params);
  }

  @override
  Future<Response> register(Params params) async {
    log('send request');
    log(params.toString());
    return make(
        method: 'post', uri: '/auth/register', headers: {}, params: params);
  }

  @override
  Future<Response> sendCode(Params params) async {
    return make(
        method: 'post', uri: '/auth/code/send', headers: {}, params: params);
  }

  @override
  Future<Response> resetPassword(Params params) async {
    return make(
        method: 'post',
        uri: '/auth/password/reset',
        headers: {},
        params: params);
  }

  @override
  Future<Response> activateProfile(Params params) async {
    return make(
        method: 'post', uri: '/auth/email/verify', headers: {}, params: params);
  }

  @override
  Future<Response> user() async {
    return make(method: 'get', uri: '/user/me', headers: {});
  }

  @override
  Future<Response> units() async {
    return make(method: 'get', uri: '/unit', headers: {});
  }

  @override
  Future<Response> updateUser(Params params) async {
    return make(method: 'put', uri: '/user', headers: {}, params: params);
  }

  @override
  Future<Response> deleteUser() async {
    return make(method: 'delete', uri: '/user', headers: {});
  }

  @override
  Future<Response> authViaGoogle() {
    return make(
        method: 'get',
        uri: '/auth/login/google/link',
        headers: {},
        authorized: false);
  }

  @override
  Future<Response> authViaVK() {
    return make(
        method: 'get',
        uri: '/auth/login/vk/link',
        headers: {},
        authorized: false);
  }

  @override
  Future<Response> favorites(Params params) {
    return make(
        method: 'get',
        uri: '/dictionary/favorite',
        headers: {},
        params: params);
  }

  @override
  Future<Response> search(Params params) {
    return make(
        method: 'get', uri: '/gesture/search', headers: {}, params: params);
  }

  @override
  Future<Response> gesture(String id) {
    return make(
      method: 'get',
      uri: '/gesture/' + id,
      headers: {},
    );
  }

  @override
  Future<Response> addToFavorites(Params params) {
    return make(
        method: 'post',
        uri: '/dictionary/gesture',
        headers: {},
        params: params);
  }

  @override
  Future<Response> removeFromFavorites(Params params) {
    return make(
        method: 'delete',
        uri: '/dictionary/gesture',
        headers: {},
        params: params);
  }

  @override
  Future<Response> downloadVideo(String url) async {
    log('load video'+ url);

    try {
      String fileName = url.split('/').last;
      String path = saveVideoPath + fileName;
      log(path);
      await client.download(url.replaceAll('localhost:8000', config["domain"]), path);
      log('video loaded');
      return SuccessResponse(data: {'path': path});
    } on http.DioError catch (error) {
      log(error.toString());
      return ErrorResponse(code: error.response?.statusCode ?? 500, message: error.response?.statusMessage ?? '');
    }
  }

  @override
  Future<Response> downloadImage(String url) async {
    log('load image'+ url);

    try {
      String fileName = url.split('/').last;
      String path = saveImagePath + fileName;
      log(path);
      await client.download(url.replaceAll('localhost:8000', config["domain"]), path);
      log('image loaded');
      return SuccessResponse(data: {'path': path});
    } on http.DioError catch (error) {
      log(error.toString());
      return ErrorResponse(code: error.response?.statusCode ?? 500, message: error.response?.statusMessage ?? '');
    }
  }

  @override
  Future<Response> searchFavorites(Params params) {
    return make(
        method: 'get',
        uri: '/gesture',
        headers: {},
        params: params);
  }
}
