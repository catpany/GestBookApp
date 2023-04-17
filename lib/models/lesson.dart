import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'lesson.g.dart';

@JsonSerializable()
@HiveType(typeId: 3)
class LessonModel extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  int order;
  @HiveField(2)
  String name;
  @HiveField(3)
  double progress;
  @HiveField(4)
  int icon;
  @JsonKey(name: 'levels_total')
  @HiveField(5)
  int levelsTotal;
  @JsonKey(name: 'levels_finished')
  @HiveField(6)
  int levelsFinished;
  @HiveField(7)
  bool theory;

  LessonModel({required this.id, required this.order, required this.name, required this.progress, required this.icon, required this.levelsTotal, required this.levelsFinished, required this.theory});

  factory LessonModel.fromJson(Map<String, dynamic> json) => _$LessonModelFromJson(json);

  Map<String, dynamic> toJson() => _$LessonModelToJson(this);
}