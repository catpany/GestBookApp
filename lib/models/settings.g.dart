// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SettingsModelAdapter extends TypeAdapter<SettingsModel> {
  @override
  final int typeId = 5;

  @override
  SettingsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SettingsModel(
      isDarkMode: fields[0] == null ? false : fields[0] as bool,
      isRightHanded: fields[1] == null ? true : fields[1] as bool,
      notificationTime: fields[2] == null ? 18 : fields[2] as int,
      notificationsEnabled: fields[3] == null ? true : fields[3] as bool,
      messagesEnabled: fields[4] == null ? true : fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, SettingsModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.isDarkMode)
      ..writeByte(1)
      ..write(obj.isRightHanded)
      ..writeByte(2)
      ..write(obj.notificationTime)
      ..writeByte(3)
      ..write(obj.notificationsEnabled)
      ..writeByte(4)
      ..write(obj.messagesEnabled);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
