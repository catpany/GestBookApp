import 'package:hive_flutter/hive_flutter.dart';
import 'package:sigest/api/params.dart';
import 'package:sigest/stock/hive_repository.dart';
import 'package:sigest/stock/hive_source_of_truth.dart';
import 'package:stock/stock.dart';

class HiveStock<T extends HiveObject> extends HiveRepository<T> {
  @override
  String get name => 'default';

  // @override
  late Fetcher<String, T> fetcher;

  // @override
  late Stock<String, T> stock;

  // @override
  late CachedSourceOfTruth<String, T> sourceOfTruth;

  HiveStock() : super() {
    fetcher = Fetcher.ofFuture<String, T>((key) => loadModel(key));
    sourceOfTruth = HiveSourceOfTruth(name: name);
    stock = Stock<String, T>(
      fetcher: fetcher,
      sourceOfTruth: sourceOfTruth,
    );
  }

  @override
  void delete(String key) {
    super.delete(key);
    stock.clear(key);
  }

  @override
  T? get(String key) {
    return store.get(key);
  }

  @override
  Future<T> load(String key, Params? params) async {
    this.params = params;
    return stock.get(key);
  }

  @override
  Future<T> reload(String key, Params? params) async {
    this.params = params;
    return stock.fresh(key);
  }

  // @override
  Future<T> loadModel(String key) {
    // TODO: implement loadModel
    throw UnimplementedError();
  }
}