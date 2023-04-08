import 'package:hive/hive.dart';
import 'package:sigest/api.dart';
import 'package:sigest/models/auth.dart';
import 'package:sigest/stock/abstract_stock.dart';
import 'package:stock/stock.dart';

class AuthRepository {
  static const String name = 'auth';

  void setAuth(Map<String, dynamic> data) async {
    final authBox = await Hive.openBox<AuthModel>(name);

    AuthModel model = AuthModel.fromJson(data);
    authBox.put('auth', model);
  }

  Future<AuthModel?> getAuth() async {
    final authBox = await Hive.openBox<AuthModel>('auth');

    return authBox.get('auth');
  }
}
