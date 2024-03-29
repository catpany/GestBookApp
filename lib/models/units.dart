import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sigest/models/unit.dart';

part 'units.g.dart';

@HiveType(typeId: 4)
class UnitsModel extends HiveObject {
  @JsonKey(defaultValue: [])
  @HiveField(0)
  List<UnitModel> items;

  UnitsModel({required this.items});
}