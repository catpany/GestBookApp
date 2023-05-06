// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gesture.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GestureModelAdapter extends TypeAdapter<GestureModel> {
  @override
  final int typeId = 6;

  @override
  GestureModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GestureModel(
      id: fields[0] as String,
      name: fields[1] as String,
      context: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, GestureModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.context);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GestureModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GestureModel _$GestureModelFromJson(Map<String, dynamic> json) => GestureModel(
      id: json['id'] as String,
      name: json['name'] as String,
      context: json['context'] as String,
    );

Map<String, dynamic> _$GestureModelToJson(GestureModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'context': instance.context,
    };
