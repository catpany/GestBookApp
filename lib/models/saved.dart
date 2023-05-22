import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sigest/models/gesture-info.dart';

part 'saved.g.dart';

@HiveType(typeId: 9)
class SavedModel extends HiveObject {
  @JsonKey(defaultValue: [])
  @HiveField(0)
  HiveList<GestureInfoModel> items;

  SavedModel({required this.items});
}