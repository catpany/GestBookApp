import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sigest/models/unit.dart';

part 'units.g.dart';

@JsonSerializable()
@HiveType(typeId: 4)
class UnitsModel extends HiveObject {
  @HiveField(0)
  List<UnitModel> items;

  UnitsModel({required this.items});

  factory UnitsModel.fromJson(Map<String, dynamic> json) => _$UnitsModelFromJson(json);

  Map<String, dynamic> toJson() => _$UnitsModelToJson(this);
}