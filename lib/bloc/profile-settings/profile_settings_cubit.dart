import 'package:meta/meta.dart';
import 'package:sigest/bloc/main_cubit.dart';
import 'package:sigest/models/settings.dart';

import '../../api/params.dart';
import '../../api/response.dart';

part 'profile_settings_state.dart';

class ProfileSettingsCubit extends MainCubit {
  @override
  List<String> get preloadStores => ['user', 'settings'];

  ProfileSettingsCubit() : super();

  bool canChangeEmail() {
    return '' != store.user.user.email;
  }

  bool canChangePassword() {
    return canChangeEmail();
  }

  void updateIsDarkMode(bool newDarkMode) {
    SettingsModel userSettings = store.settings.get(store.user.user.id);
    SettingsModel currentSettings = store.settings.current;
    userSettings.isDarkMode = newDarkMode;
    currentSettings.isDarkMode = newDarkMode;
    userSettings.save();
    currentSettings.save();
  }

  void updateIsRightHanded(bool newIsRightHanded) {
    SettingsModel userSettings = store.settings.get(store.user.user.id);
    SettingsModel currentSettings = store.settings.current;
    userSettings.isRightHanded = newIsRightHanded;
    currentSettings.isRightHanded = newIsRightHanded;
    userSettings.save();
    currentSettings.save();
  }

  void updateNotificationsEnabled(bool newNotificationsEnabled) {
    emit(NotificationsEnabledChange());
    SettingsModel userSettings = store.settings.get(store.user.user.id);
    SettingsModel currentSettings = store.settings.current;
    userSettings.notificationsEnabled = newNotificationsEnabled;
    currentSettings.notificationsEnabled = newNotificationsEnabled;
    userSettings.save();
    currentSettings.save();
    emit(NotificationsEnabledChanged());
  }

  void updateMessagesEnabled(bool newMessagesEnabled) {
    SettingsModel userSettings = store.settings.get(store.user.user.id);
    SettingsModel currentSettings = store.settings.current;
    userSettings.messagesEnabled = newMessagesEnabled;
    currentSettings.messagesEnabled = newMessagesEnabled;
    userSettings.save();
    currentSettings.save();
  }

  void updateNotificationTime(String newNotificationTime) {
    emit(NotificationTimeChange());
    SettingsModel userSettings = store.settings.get(store.user.user.id);
    SettingsModel currentSettings = store.settings.current;
    userSettings.notificationTime = newNotificationTime;
    currentSettings.notificationTime = newNotificationTime;
    userSettings.save();
    currentSettings.save();
    emit(NotificationTimeChanged());
  }

  Future<void> updateUser(bindControllers) async {
    emit(UpdatingUser());
    Map<String, dynamic> body = {
      // 'old_password': bindControllers['old_password']!.text,
      // 'password': bindControllers['new_password']!.text,
      'email': bindControllers['email']!.text,
      'username': bindControllers['username']!.text,
    };

    if (bindControllers['old_password']!.text != '' && bindControllers['new_password']!.text != '') {
      body['old_password'] = bindControllers['old_password']!.text;
      body['password'] = bindControllers['new_password']!.text;
    }

    // if (bindControllers['email']!.text != store.user.user.email) {
    //   body['email'] = bindControllers['email']!.text;
    // }
    //
    // if (bindControllers['username']!.text != store.user.user.username) {
    //   body['username'] = bindControllers['username']!.text;
    // }

    Response response = await store.user.updateUser(Params({}, body));

    if (isNeedToActivate(response)) {
      emit(EmailChanged());
    } else if (!checkForError(response)) {
      emit(UserDataChanged());
    }
  }

  Future<void> deleteUser() async {
    emit(DeletingUser());

    Response response = await store.user.deleteUser();

    if (!checkForError(response)) {
      store.settings.delete(store.user.user.id);
      store.clear();
      emit(ProfileDeleteSuccess());
    }
  }
}
