import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

import '../api/abstract_api.dart';
import '../api/params.dart';

abstract class AbstractRepository {
  // AbstractApi api;
  // String name;
  // Params? params;

  dynamic load(String key, Params? params);

  dynamic reload(String key, Params? params);

  void delete(String key);

  void deleteAll(List<String> keys);

  void clear();

  void put(String key, Object item);

  void putAll(Map<dynamic, Object> items);

  dynamic get(String key);

  Future<void> init();
}