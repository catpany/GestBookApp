import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:sigest/api/abstract_api.dart';
import 'package:sigest/locator.dart';
import 'package:stock/stock.dart';

import '../api/params.dart';
import 'abstract_repository.dart';
import 'hive_source_of_truth.dart';

abstract class AbstractStock<T> {
  late Fetcher<String, T> fetcher;
  late CachedSourceOfTruth<String, T> sourceOfTruth;
  late Stock<String, T> stock;

  // AbstractStock() {
  //   fetcher = Fetcher.ofFuture<String, T>((key) => loadModel(key));
  //   sourceOfTruth = HiveSourceOfTruth(name: name);
  //   stock = Stock<String, T>(
  //     fetcher: fetcher,
  //     sourceOfTruth: sourceOfTruth,
  //   );
  //   // api = locator<AbstractApi>();
  // }

  @protected
  Future<T> loadModel(String key);
}