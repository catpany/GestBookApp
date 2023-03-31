import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:stock/stock.dart';

import 'hive_source_of_truth.dart';

abstract class AbstractStock<T> {
  final String name = 'default';
  // final T mockObj;
  late Fetcher<String, T> fetcher;

  late HiveSourceOfTruth<String, T> sourceOfTruth;
  late Stock<String, T> stock;

  AbstractStock() {
    fetcher = Fetcher.ofFuture<String, T>((key) => load(key));
    sourceOfTruth = HiveSourceOfTruth(name: name);
    stock = Stock<String, T>(
      fetcher: fetcher,
      sourceOfTruth: sourceOfTruth,
    );
  }



  @protected
  Future<T> load(String key);
}