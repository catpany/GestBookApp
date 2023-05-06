import 'dart:developer';

import 'package:json_annotation/json_annotation.dart';

part 'word.g.dart';

@JsonSerializable()
class WordModel {
  String id;
  String name;
  String context;
  String gesture;

  WordModel({required this.id, required this.name, required this.context, required this.gesture});

  factory WordModel.fromJson(Map<String, dynamic> json) => _$WordModelFromJson(json);

  Map<String, dynamic> toJson() => _$WordModelToJson(this);
}