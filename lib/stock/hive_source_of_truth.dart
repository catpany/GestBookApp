import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:sigest/models/unit.dart';
import 'package:stock/stock.dart';

class HiveSourceOfTruth<String, T> extends CachedSourceOfTruth<String, T> {
  final String name;
  HiveSourceOfTruth({required this.name});

  @override
  @protected
  Stream<T?> reader(String key) async* {
    final Box box = Hive.box<T>(name.toString());
    // log();
    // Hive.isBoxOpen(name.toString())? Hive.box(name.toString()) : await Hive.openBox(name.toString());
    // Read data from an non-stream source
    var value = box.get(key);
    setCachedValue(key, value);
    yield* super.reader(key);
  }

  @override
  @protected
  Future<void> write(String key, T? value) async {
    final Box box = Hive.box<T>(name.toString());
    // Hive.isBoxOpen(name.toString())? Hive.box(name.toString()) : await Hive.openBox(name.toString());
    box.put(key, value);
    await super.write(key, value);
  }
}