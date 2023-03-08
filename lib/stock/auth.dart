import 'package:hive/hive.dart';
import 'package:sigest/models/auth.dart';

class AuthStock {
  final String name = 'auth';

  void setAuth(String id, Map<String, dynamic> data) async {
    final authBox = await Hive.openBox<AuthModel>('auth');

    AuthModel model = AuthModel.fromJson(data);
    authBox.put(id, model);
  }

  Future<AuthModel?> getAuth(String id) async {
    final authBox = await Hive.openBox<AuthModel>('auth');

    return authBox.getAt(0);
  }
}
