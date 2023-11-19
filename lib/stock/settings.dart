import 'package:injectable/injectable.dart';
import 'package:sigest/models/settings.dart';
import 'package:sigest/stock/hive_repository.dart';

import 'abstract_repository.dart';

@Named('settings')
@Singleton(as: AbstractRepository)
class SettingsRepository extends HiveRepository<SettingsModel> {
  @override
  String get name => 'settings';
  SettingsModel get current => get('current');
  set current(SettingsModel settings) => put('current', settings);

  @override
  SettingsModel get(String key) {
    return store.get(key) ?? SettingsModel(isDarkMode: false, isRightHanded: true, notificationTime: '18:00', notificationsEnabled: true, messagesEnabled: true);
  }
}
