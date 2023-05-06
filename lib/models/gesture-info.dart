import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'gesture-info.g.dart';

@JsonSerializable()
@HiveType(typeId: 7)
class GestureInfoModel  extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String name;
  @HiveField(2)
  String context;
  @HiveField(3)
  String description;
  @HiveField(4)
  String src;
  @HiveField(5)
  String img;

  GestureInfoModel({
    required this.id, required this.name, required this.context, required this.description, required this.img, required this.src
  });

  factory GestureInfoModel.fromJson(Map<String, dynamic> json) => _$GestureInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$GestureInfoModelToJson(this);
}