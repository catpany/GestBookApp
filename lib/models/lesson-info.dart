import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sigest/models/gesture-info.dart';

import 'level.dart';

part 'lesson-info.g.dart';

@JsonSerializable()
@HiveType(typeId: 12)
class LessonInfoModel extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String name;
  @HiveField(2)
  List<GestureInfoModel> gestures;
  @HiveField(3)
  String theory;
  @JsonKey(name: 'best_time')
  @HiveField(4)
  int? bestTime;
  @HiveField(5)
  List<LevelModel> levels;

  LessonInfoModel({required this.id, required this.name, required this.gestures, required this.theory, required this.bestTime, required this.levels});

  factory LessonInfoModel.fromJson(Map<String, dynamic> json) => _$LessonInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$LessonInfoModelToJson(this);
}