import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'auth.g.dart';

@JsonSerializable()
@HiveType(typeId: 1)
class AuthModel  extends HiveObject {
  @HiveField(0)
  String access_token;
  @HiveField(1)
  String refresh_token;

  AuthModel({
    required this.access_token,
    required this.refresh_token,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) => _$AuthModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthModelToJson(this);
}