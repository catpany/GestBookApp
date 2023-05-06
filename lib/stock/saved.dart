import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:sigest/models/dictionary.dart';
import 'package:sigest/stock/hive_repository.dart';

import '../api/params.dart';
import '../locator.dart';
import '../models/gesture.dart';
import 'abstract_repository.dart';
import 'gestures.dart';

@Named('saved')
@Singleton(as: AbstractRepository)
class SavedRepository extends HiveRepository<DictionaryModel> {
  @override
  String get name => 'saved';

  List<GestureModel> find(String userId, String word) {
    List<GestureModel> gestures = [];
    store.get(userId)?.items.forEach((GestureModel gesture) {
      if (gesture.name.contains(word)) {
        gestures.add(gesture);
      }
    });

    return gestures;
  }

  @override
  dynamic load(String key, Params? params) async {
    this.params = params;
    DictionaryModel? dictionary = store.get(key);

    if (dictionary == null) {
      GestureRepository rep = locator.get<AbstractRepository>(instanceName: 'gestures') as GestureRepository;
      await rep.init();
      dictionary = DictionaryModel(items: HiveList(rep.store));
      store.put(key, dictionary);
    }

    return dictionary;
  }
}
