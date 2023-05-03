import 'dart:async';
import 'dart:developer';

import 'package:meta/meta.dart';
import 'package:sigest/api/response.dart';
import 'package:sigest/models/settings.dart';

import '../main_cubit.dart';

part 'splash_state.dart';

class SplashCubit extends MainCubit {
  SplashCubit() : super();

  @override
  List<String> get preloadStores => ['user', 'settings', 'units'];

  @override
  Future<void> load() async {
    log('splash data load');
    emit(DataLoading());
    store
        .reload()
        .then((value) {
        log('static splash data loaded');
        updateSettings();

        emit(DataLoaded());
    }, onError: (error, StackTrace stackTrace) {
      log('error!!!');
      log(error.toString());
      log(stackTrace.toString());
      checkForError(error.error as ErrorResponse);
    });
  }

  void updateSettings() {
    SettingsModel currentSettings = store.settings.current;
    SettingsModel userSettings = store.settings.get(store.user.user.id);
    currentSettings.isDarkMode = userSettings.isDarkMode;
    currentSettings.notificationTime = userSettings.notificationTime;
    currentSettings.messagesEnabled = userSettings.messagesEnabled;
    currentSettings.notificationsEnabled = userSettings.notificationsEnabled;
    currentSettings.isRightHanded = userSettings.isRightHanded;

    if (!store.settings.store.containsKey(store.user.user.id)) {
      store.settings.put(store.user.user.id, userSettings);
    }

    if (store.settings.store.containsKey('current')) {
      currentSettings.save();
    } else {
      store.settings.current = currentSettings;
    }
  }
}
