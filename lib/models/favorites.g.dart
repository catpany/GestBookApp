// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorites.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FavoritesModelAdapter extends TypeAdapter<FavoritesModel> {
  @override
  final int typeId = 8;

  @override
  FavoritesModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FavoritesModel(
      id: fields[0] as String,
      items: (fields[1] as HiveList).castHiveList(),
    );
  }

  @override
  void write(BinaryWriter writer, FavoritesModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.items);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoritesModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
