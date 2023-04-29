import 'package:sigest/api/params.dart';
import 'package:sigest/api/response.dart';

abstract class AbstractApi {
Future<Response> login(Params params);

Future<Response> register(Params params);

Future<Response> sendCode(Params params);

Future<Response> resetPassword(Params params);

Future<Response> activateProfile(Params params);

Future<Response> user();

Future<Response> units();

Future<Response> updateUser(Params params);

Future<Response> deleteUser();
}