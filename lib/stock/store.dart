import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:sigest/models/auth.dart';
import 'package:sigest/stock/abstract_repository.dart';
import 'package:sigest/stock/auth.dart';
import 'package:sigest/stock/units.dart';
import 'package:sigest/stock/user.dart';

import '../locator.dart';

class Store {
  late Map<String, AbstractRepository> _stores = {};
  List<String> preloadStores;
  AuthRepository get auth => _stores['auth'] as AuthRepository;
  UnitsRepository get units => _stores['units'] as UnitsRepository;
  UserRepository get user => _stores['user'] as UserRepository;
  final List<String> staticStores = ['auth', 'units', 'user'];

  Store(this.preloadStores) {
    init();
  }

  void init() {
    for (String store in preloadStores) {
      _stores[store] = locator.get<AbstractRepository>(instanceName: store);
    }
  }

  Future<void> loadStatic() async {
    for(final store in _stores.entries) {
      if (staticStores.contains(store.key)) {
        await store.value.load(store.key, null);
      }
    }
  }

  Future<void> reloadStatic() async {
    for(final store in _stores.entries) {
      if (staticStores.contains(store.key)) {
        await store.value.reload(store.key, null);
        log('reload ' + store.key);
      }
    }

  }
}