// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SavedModelAdapter extends TypeAdapter<SavedModel> {
  @override
  final int typeId = 9;

  @override
  SavedModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SavedModel(
      items: (fields[0] as HiveList).castHiveList(),
    );
  }

  @override
  void write(BinaryWriter writer, SavedModel obj) {
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
      other is SavedModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
