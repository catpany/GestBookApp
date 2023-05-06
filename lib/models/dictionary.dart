import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

import 'gesture.dart';

part 'dictionary.g.dart';

@HiveType(typeId: 8)
class DictionaryModel extends HiveObject {
  @JsonKey(defaultValue: [])
  @HiveField(0)
  HiveList<GestureModel> items;

  DictionaryModel({required this.items});
}