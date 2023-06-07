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

Future<Response> authViaGoogle();

Future<Response> authViaVK();

Future<Response> search(Params params);

Future<Response> favorites(Params params);

Future<Response> gesture(String id);

Future<Response> addToFavorites(Params params);

Future<Response> removeFromFavorites(Params params);

Future<Response> downloadVideo(String url);

Future<Response> downloadImage(String url);

Future<Response> searchFavorites(Params params);

Future<Response> lesson(String id);

Future<Response> updateStats(Params params);

Future<Response> finishLevel(String id);
}