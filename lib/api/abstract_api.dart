import 'dart:convert';

import 'package:sigest/api/params.dart';
import 'package:sigest/api/response.dart';

import '../locator.dart';
import 'api_mock.dart';

abstract class AbstractApi {
Future<Response> login(Params params);

Future<Response> register(Params params);

Future<Response> forgotPassword(Params params);

Future<Response> resetPassword(Params params);

Future<Response> activateProfile(Params params);

Future<Response> user(String userId);

Future<Response> units();
}