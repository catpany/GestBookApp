import 'package:flutter/cupertino.dart';
import 'package:stock/stock.dart';

import 'hive_source_of_truth.dart';

abstract class AbstractStock<T> {
  final String name;
  late Fetcher<String, dynamic> fetcher;

  late HiveSourceOfTruth sourceOfTruth;
  late Stock stock;

  AbstractStock({required this.name}) {
    fetcher = Fetcher.ofFuture<String, dynamic>((key) => load(key));
    sourceOfTruth = HiveSourceOfTruth(name: name);
    stock = Stock<String, dynamic>(
      fetcher: fetcher,
      sourceOfTruth: sourceOfTruth,
    );
  }

  @protected
  Future<T> load(String key);
}