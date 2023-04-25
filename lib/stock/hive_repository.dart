import 'dart:developer';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:sigest/api/abstract_api.dart';
import 'package:sigest/api/params.dart';
import 'package:sigest/stock/abstract_repository.dart';

import '../locator.dart';

class HiveRepository<T extends HiveObject> implements AbstractRepository {
  late Box<T> store;
  late AbstractApi api;

  Params? params;

  String get name => 'default';

  HiveRepository() {
    api = locator<AbstractApi>();
    // init();
    // store = Hive.openBox(name.toString());
    }

  @override
  void delete(String key) {
    store.delete(key);
  }

  @override
  void deleteAll(List<String> keys) {
    store.deleteAll(keys);
  }

  @override
  dynamic load(String key, Params? params) async {
    // store = Hive.isBoxOpen(name.toString())? Hive.box(name.toString()) : await Hive.openBox(name.toString());
    await init();
    this.params = params;
    return store.get(key);
  }

  @override
  dynamic reload(String key, Params? params) {
    return load(key, params);
  }

  @override
  void clear() {
    store.clear();
  }

  @override
  T? get(String key) {
    return store.get(key);
  }

  @override
  void put(String key, Object item) {
    store.put(key, item as T);
  }

  @override
  void putAll(Map<dynamic, Object> items) {
    store.putAll(items as Map<dynamic, T>);
  }

  @override
  Future<void> init() async {
    log('open box ' + name);
    store = Hive.isBoxOpen(name.toString())? Hive.box<T>(name.toString()) : await Hive.openBox<T>(name.toString());
  }
}