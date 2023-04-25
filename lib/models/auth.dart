import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'auth.g.dart';

@JsonSerializable()
@HiveType(typeId: 1)
class AuthModel  extends HiveObject {
  @JsonKey(name: 'access_token', defaultValue: '')
  @HiveField(0)
  String accessToken;
  @JsonKey(name: 'refresh_token', defaultValue: {})
  @HiveField(1)
  Map<String, String> refreshToken;

  AuthModel({
    required this.accessToken,
    required this.refreshToken,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) => _$AuthModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthModelToJson(this);
}