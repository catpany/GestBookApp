import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sigest/models/lesson.dart';

part 'unit.g.dart';

// @JsonSerializable()
@HiveType(typeId: 2)
class UnitModel extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  int order;
  // @JsonKey(includeToJson: false, includeFromJson: false)
  @HiveField(2)
  HiveList<LessonModel> lessons;
  @HiveField(3, defaultValue: false)
  bool available = false;

  UnitModel({required this.id, required this.order, required this.lessons});

  // factory UnitModel.fromJson(Map<String, dynamic> json) => _$UnitModelFromJson(json);
  //
  // Map<String, dynamic> toJson() => _$UnitModelToJson(this);
}