part of 'profile_settings_cubit.dart';

@immutable
abstract class ProfileSettingsState extends MainState {}

class ProfileSettingsInitial extends ProfileSettingsState {}

class ProfileDeleteSuccess extends ProfileSettingsState {}

class EmailChanged extends ProfileSettingsState {}

class UserDataChanged extends ProfileSettingsState {}

class UpdatingUser extends ProfileSettingsState {}

class DeletingUser extends ProfileSettingsState {}