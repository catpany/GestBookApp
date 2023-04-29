import 'package:hive/hive.dart';

part 'settings.g.dart';

@HiveType(typeId: 5)
class SettingsModel  extends HiveObject {
  @HiveField(0, defaultValue: false)
  bool isDarkMode;
  @HiveField(1, defaultValue: true)
  bool isRightHanded;
  @HiveField(2, defaultValue: 18)
  int notificationTime;
  @HiveField(3, defaultValue: true)
  bool notificationsEnabled;
  @HiveField(4, defaultValue: true)
  bool messagesEnabled;

  SettingsModel({
    required this.isDarkMode,
    required this.isRightHanded,
    required this.notificationTime,
    required this.notificationsEnabled,
    required this.messagesEnabled
  });
}