import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'exercise.g.dart';

@JsonSerializable()
@HiveType(typeId: 10)
class ExerciseModel extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  int type;
  @HiveField(2)
  List<String> answers;
  @HiveField(3)
  List<String> options;

  ExerciseModel({required this.id, required this.type, required this.answers, required this.options});

  factory ExerciseModel.fromJson(Map<String, dynamic> json) => _$ExerciseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExerciseModelToJson(this);
}