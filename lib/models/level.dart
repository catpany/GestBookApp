import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

import 'exercise.dart';

part 'level.g.dart';

@JsonSerializable()
@HiveType(typeId: 11)
class LevelModel extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  int order;
  @HiveField(2)
  List<ExerciseModel> exercises;

  LevelModel({required this.id, required this.order, required this.exercises});

  factory LevelModel.fromJson(Map<String, dynamic> json) => _$LevelModelFromJson(json);

  Map<String, dynamic> toJson() => _$LevelModelToJson(this);
}