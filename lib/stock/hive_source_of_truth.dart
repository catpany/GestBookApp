import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:stock/stock.dart';

class HiveSourceOfTruth extends CachedSourceOfTruth<String, Object> {
  final String name;
  HiveSourceOfTruth({required this.name});

  @override
  @protected
  Stream<Object?> reader(String key) async* {
    final box = await Hive.openBox(name);
    // Read data from an non-stream source
    final value = box.get(key);
    setCachedValue(key, value);
    yield* super.reader(key);
  }

  @override
  @protected
  Future<void> write(String key, Object? value) async {
    final box = await Hive.openBox(name);
    box.put(key, value);
    await super.write(key, value);
  }
}