// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unit.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UnitModelAdapter extends TypeAdapter<UnitModel> {
  @override
  final int typeId = 2;

  @override
  UnitModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UnitModel(
      id: fields[0] as String,
      order: fields[1] as int,
      lessons: (fields[2] as List).cast<LessonModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, UnitModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.order)
      ..writeByte(2)
      ..write(obj.lessons);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UnitModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UnitModel _$UnitModelFromJson(Map<String, dynamic> json) => UnitModel(
      id: json['id'] as String,
      order: json['order'] as int,
      lessons: (json['lessons'] as List<dynamic>?)
              ?.map((e) => LessonModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$UnitModelToJson(UnitModel instance) => <String, dynamic>{
      'id': instance.id,
      'order': instance.order,
      'lessons': instance.lessons,
    };
