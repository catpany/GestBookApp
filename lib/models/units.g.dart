// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'units.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UnitsModelAdapter extends TypeAdapter<UnitsModel> {
  @override
  final int typeId = 4;

  @override
  UnitsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UnitsModel(
      items: (fields[0] as List).cast<UnitModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, UnitsModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.items);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UnitsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UnitsModel _$UnitsModelFromJson(Map<String, dynamic> json) => UnitsModel(
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => UnitModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$UnitsModelToJson(UnitsModel instance) =>
    <String, dynamic>{
      'items': instance.items,
    };
