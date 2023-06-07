// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson-info.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LessonInfoModelAdapter extends TypeAdapter<LessonInfoModel> {
  @override
  final int typeId = 12;

  @override
  LessonInfoModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LessonInfoModel(
      id: fields[0] as String,
      name: fields[1] as String,
      gestures: (fields[2] as List).cast<GestureInfoModel>(),
      theory: fields[3] as String,
      bestTime: fields[4] as int?,
      levels: (fields[5] as List).cast<LevelModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, LessonInfoModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.gestures)
      ..writeByte(3)
      ..write(obj.theory)
      ..writeByte(4)
      ..write(obj.bestTime)
      ..writeByte(5)
      ..write(obj.levels);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LessonInfoModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LessonInfoModel _$LessonInfoModelFromJson(Map<String, dynamic> json) =>
    LessonInfoModel(
      id: json['id'] as String,
      name: json['name'] as String,
      gestures: (json['gestures'] as List<dynamic>)
          .map((e) => GestureInfoModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      theory: json['theory'] as String,
      bestTime: json['best_time'] as int?,
      levels: (json['levels'] as List<dynamic>)
          .map((e) => LevelModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LessonInfoModelToJson(LessonInfoModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'gestures': instance.gestures,
      'theory': instance.theory,
      'best_time': instance.bestTime,
      'levels': instance.levels,
    };
