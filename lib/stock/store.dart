import 'dart:developer';

import 'package:sigest/stock/abstract_repository.dart';
import 'package:sigest/stock/auth.dart';
import 'package:sigest/stock/lessons.dart';
import 'package:sigest/stock/saved.dart';
import 'package:sigest/stock/settings.dart';
import 'package:sigest/stock/units.dart';
import 'package:sigest/stock/user.dart';

import '../locator.dart';
import 'favorites.dart';
import 'gesture-info.dart';
import 'gestures.dart';
import 'lesson-info.dart';

class Store {
  late Map<String, AbstractRepository> _stores = {};
  List<String> preloadStores;
  AuthRepository get auth => _stores['auth'] as AuthRepository;
  UnitsRepository get units => _stores['units'] as UnitsRepository;
  UserRepository get user => _stores['user'] as UserRepository;
  SettingsRepository get settings => _stores['settings'] as SettingsRepository;
  LessonRepository get lessons => _stores['lessons'] as LessonRepository;
  SavedRepository get saved => _stores['saved'] as SavedRepository;
  FavoritesRepository get favorites => _stores['favorites'] as FavoritesRepository;
  GestureRepository get gestures => _stores['gestures'] as GestureRepository;
  GestureInfoRepository get gestureInfo => _stores['gestureInfo'] as GestureInfoRepository;
  LessonInfoRepository get lessonInfo => _stores['lessonInfo'] as LessonInfoRepository;
  final List<String> staticStores = ['auth', 'units', 'user', 'lessons'];
  List<String> clearStores = ['lessons', 'units', 'auth', 'user'];

  Store(this.preloadStores) {
    init();
  }

  void init() {
    for (String store in preloadStores) {
      _stores[store] = locator.get<AbstractRepository>(instanceName: store);
    }
  }

  Future<void> load() async {
    for(final store in _stores.entries) {
      await store.value.init();

      if (staticStores.contains(store.key)) {
        await store.value.load(store.key, null);
      }
    }
  }

  Future<void> reload() async {
    for(final store in _stores.entries) {
      await store.value.init();

      if (staticStores.contains(store.key)) {
        await store.value.reload(store.key, null);
        log('reload ' + store.key);
      }
    }

  }

  clear() {
    for (final store in _stores.entries) {
      if (clearStores.contains(store.key)) {
        store.value.clear();
      }
    }
  }
}