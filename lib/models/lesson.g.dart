// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LessonModelAdapter extends TypeAdapter<LessonModel> {
  @override
  final int typeId = 3;

  @override
  LessonModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LessonModel(
      id: fields[0] as String,
      order: fields[1] as int,
      name: fields[2] as String,
      progress: fields[3] as double,
      icon: fields[4] as int,
      levelsTotal: fields[5] as int,
      levelsFinished: fields[6] as int,
      theory: fields[7] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, LessonModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.order)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.progress)
      ..writeByte(4)
      ..write(obj.icon)
      ..writeByte(5)
      ..write(obj.levelsTotal)
      ..writeByte(6)
      ..write(obj.levelsFinished)
      ..writeByte(7)
      ..write(obj.theory);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LessonModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LessonModel _$LessonModelFromJson(Map<String, dynamic> json) => LessonModel(
      id: json['id'] as String,
      order: json['order'] as int,
      name: json['name'] as String,
      progress: (json['progress'] as num).toDouble(),
      icon: json['icon'] as int,
      levelsTotal: json['levels_total'] as int,
      levelsFinished: json['levels_finished'] as int,
      theory: json['theory'] as bool,
    );

Map<String, dynamic> _$LessonModelToJson(LessonModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'order': instance.order,
      'name': instance.name,
      'progress': instance.progress,
      'icon': instance.icon,
      'levels_total': instance.levelsTotal,
      'levels_finished': instance.levelsFinished,
      'theory': instance.theory,
    };
