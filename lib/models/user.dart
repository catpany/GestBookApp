import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
@HiveType(typeId: 0)
class UserModel  extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String username;
  @JsonKey(defaultValue: '')
  @HiveField(2)
  String email;
  @HiveField(3)
  Map<String, int> stat;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.stat
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}