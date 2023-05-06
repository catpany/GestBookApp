import 'package:injectable/injectable.dart';
import 'package:sigest/stock/hive_repository.dart';

import '../models/gesture.dart';
import 'abstract_repository.dart';

@Named('gestures')
@Singleton(as: AbstractRepository)
class GestureRepository extends HiveRepository<GestureModel> {
  @override
  String get name => 'gestures';
}
