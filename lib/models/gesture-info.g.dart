// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gesture-info.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GestureInfoModelAdapter extends TypeAdapter<GestureInfoModel> {
  @override
  final int typeId = 7;

  @override
  GestureInfoModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GestureInfoModel(
      id: fields[0] as String,
      name: fields[1] as String,
      context: fields[2] as String,
      description: fields[3] as String,
      img: fields[5] as String?,
      src: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, GestureInfoModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.context)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.src)
      ..writeByte(5)
      ..write(obj.img);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GestureInfoModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GestureInfoModel _$GestureInfoModelFromJson(Map<String, dynamic> json) =>
    GestureInfoModel(
      id: json['id'] as String,
      name: json['name'] as String,
      context: json['context'] as String,
      description: json['description'] as String,
      img: json['img'] as String?,
      src: json['src'] as String?,
    );

Map<String, dynamic> _$GestureInfoModelToJson(GestureInfoModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'context': instance.context,
      'description': instance.description,
      'src': instance.src,
      'img': instance.img,
    };
