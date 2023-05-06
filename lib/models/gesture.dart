import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'gesture.g.dart';

@JsonSerializable()
@HiveType(typeId: 6)
class GestureModel  extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String name;
  @HiveField(2)
  String context;

  GestureModel({
    required this.id, required this.name, required this.context
  });

  factory GestureModel.fromJson(Map<String, dynamic> json) => _$GestureModelFromJson(json);

  Map<String, dynamic> toJson() => _$GestureModelToJson(this);
}