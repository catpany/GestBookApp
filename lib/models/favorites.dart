import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

import 'gesture.dart';

part 'favorites.g.dart';

@HiveType(typeId: 8)
class FavoritesModel extends HiveObject {
  @JsonKey(defaultValue: [])
  @HiveField(0)
  String id;
  @HiveField(1)
  HiveList<GestureModel> items;

  FavoritesModel({required this.id, required this.items});
}