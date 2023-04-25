import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'lesson.g.dart';

@JsonSerializable()
@HiveType(typeId: 3)
class LessonModel extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  int order;
  @HiveField(2)
  String name;
  @JsonKey(fromJson: _hexStringToInt, toJson: _intToHexString)
  @HiveField(3)
  int icon;
  @JsonKey(name: 'levels_total')
  @HiveField(4)
  int levelsTotal;
  @JsonKey(name: 'levels_finished')
  @HiveField(5)
  int levelsFinished;
  @JsonKey(defaultValue: false)
  @HiveField(6)
  bool theory;
  @JsonKey(includeFromJson: false, includeToJson: false)
  @HiveField(7, defaultValue: false)
  bool available;

  double get progress => (levelsFinished / levelsTotal);

  LessonModel({required this.id, required this.order, required this.name, required this.icon, required this.levelsTotal, required this.levelsFinished, required this.theory, this.available = false});

  factory LessonModel.fromJson(Map<String, dynamic> json) => _$LessonModelFromJson(json);

  Map<String, dynamic> toJson() => _$LessonModelToJson(this);

  static int _hexStringToInt(String hexIcon) {
    var result = int.tryParse(hexIcon, radix: 16 );

    if (null == result) {
      return 0xf036b;
    }

    return result;
  }

  static String _intToHexString(int intIcon) {
    return intIcon.toString();
  }
}