import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sigest/api/response.dart';
import 'package:sigest/views/scenes/auth/activate-profile.dart';
import 'package:sigest/views/scenes/auth/login.dart';
import 'package:sigest/views/widgets/button.dart';
import 'package:sigest/views/widgets/edit_user_form.dart';
import 'package:sigest/views/widgets/picker.dart';
import 'package:sigest/views/widgets/switch.dart';
import 'package:sigest/views/widgets/widget_wrapper.dart';

import '../../bloc/main_cubit.dart';
import '../../bloc/profile-settings/profile_settings_cubit.dart';
import '../styles.dart';
import '../widgets/toggle_mode.dart';

class ProfileSettingsScreen extends StatefulWidget {
  final Map<String, TextEditingController> bindControllers = {
    'username': TextEditingController(text: ''),
    'email': TextEditingController(text: ''),
    'old_password': TextEditingController(text: ''),
    'new_password': TextEditingController(text: '')
  };
  final ProfileSettingsCubit cubit = ProfileSettingsCubit();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  ProfileSettingsScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  bool showPasswordFields = false;
  Map<String, dynamic>? errors;
  bool updating = false;

  @override
  void initState() {
    super.initState();
    widget.cubit.load();
  }

  void _navigateToLogin() {
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) {
      return LoginScreen();
    }), (r) => false);
  }

  void _navigateToActivateProfile() {
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) {
      return ActivateProfileScreen(
        params: {'login': widget.cubit.store.user.user.username},
      );
    }), (r) => false);
  }

  PreferredSizeWidget _renderTopBar(BuildContext context, MainState state) {
    return AppBar(
      title: const Text('НАСТРОЙКИ', style: TextStyles.title18Medium),
      backgroundColor: ColorStyles.accent,
      shadowColor: Colors.transparent,
      centerTitle: true,
    );
  }

  Widget _renderBody(BuildContext context, MainState state) {
    if (state is! DataLoading && state is! ProfileDeleteSuccess) {
      widget.bindControllers['username']?.text =
          widget.cubit.store.user.user.username;
      widget.bindControllers['email']?.text =
          widget.cubit.store.user.user.email;

      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 18),
        child: Column(children: [
          _renderUserFormBlock(),
          _renderCommonSettingsBlock(),
          _renderNotificationSettingsBlock(),
          _renderAdditionalBlock(),
        ]),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _renderUserFormBlock() {
    return EditUserFormWidget(
      canChangePassword: widget.cubit.canChangePassword(),
      canChangeEmail: widget.cubit.canChangeEmail(),
      onDelete: () {
        log('delete');
        widget.cubit.deleteUser();
      },
      onSave: (bindControllers) {
        log('save');
        widget.cubit.updateUser(bindControllers);
      },
      user: widget.cubit.store.user.user,
      processing: updating,
    );
  }

  Widget _renderCommonSettingsBlock() {
    return Column(
      children: [
        Container(
            alignment: AlignmentDirectional.centerStart,
            margin: const EdgeInsets.only(bottom: 18, top: 22),
            child: Text('ОБЩЕЕ',
                style: Theme.of(context).textTheme.headlineMedium)),
        SizedBox(
            width: double.infinity,
            child: Wrap(
                spacing: MediaQuery.of(context).size.width - 146 * 2 - 18 * 2,
                runSpacing: 17,
                alignment: WrapAlignment.spaceEvenly,
                children: [
                  ToggleModeWidget(
                    selectedModes: [
                      !widget.cubit.store.settings.current.isRightHanded,
                      widget.cubit.store.settings.current.isRightHanded
                    ],
                    onSelect: (val) {
                      log('set ' + val.toString());
                      widget.cubit.updateIsRightHanded(val);
                    },
                  ),
                  WidgetWrapper(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 26, vertical: 10),
                      width: 146,
                      height: 110,
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 19),
                            child: Text('Темная тема',
                                style: Theme.of(context).textTheme.bodyMedium),
                          ),
                          SwitchWidget(
                              onSwitch: (val) {
                                log('change value to ' + val.toString());
                                widget.cubit.updateIsDarkMode(val);
                              },
                              value: widget
                                  .cubit.store.settings.current.isDarkMode),
                        ],
                      )),
                ]))
      ],
    );
  }

  Widget _renderNotificationSettingsBlock() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 22, bottom: 18),
          alignment: AlignmentDirectional.centerStart,
          child: Text('УВЕДОМЛЕНИЯ',
              style: Theme.of(context).textTheme.headlineMedium),
        ),
        WidgetWrapper(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          child: Column(
            children: [
              SizedBox(
                  width: double.infinity,
                  child: Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    runSpacing: 17,
                    children: [
                      Text(
                        'Напоминания об уроках',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      SwitchWidget(
                          onSwitch: (val) {
                            log('switch reminder to ' + val.toString());
                            widget.cubit.updateNotificationsEnabled(val);
                          },
                          value: widget.cubit.store.settings.current
                              .notificationsEnabled)
                    ],
                  )),
              Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 17),
                  child: Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    runSpacing: 17,
                    children: [
                      Text(
                        'Время напоминания',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      PickerWidget(
                          isTime: true,
                          minValue: 0,
                          maxValue: 23,
                          step: 1,
                          onPick: (val) {
                              widget.cubit.updateNotificationTime(val);
                          },
                          current: widget
                              .cubit.store.settings.current.notificationTime)
                    ],
                  ))
            ],
          ),
        ),
        WidgetWrapper(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          margin: const EdgeInsets.only(top: 17),
          child: SizedBox(
              width: double.infinity,
              child: Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                runSpacing: 17,
                children: [
                  Text('Мотивационные сообщения',
                      style: Theme.of(context).textTheme.bodyMedium),
                  SwitchWidget(
                      onSwitch: (val) {
                        log('switch motivation to ' + val.toString());
                        widget.cubit.updateMessagesEnabled(val);
                      },
                      value:
                          widget.cubit.store.settings.current.messagesEnabled)
                ],
              )),
        )
      ],
    );
  }

  Widget _renderAdditionalBlock() {
    return Column(
      children: [
        Container(
            alignment: AlignmentDirectional.centerStart,
            margin: const EdgeInsets.only(top: 22, bottom: 18),
            child: Text(
              'ДОПОЛНИТЕЛЬНО',
              style: Theme.of(context).textTheme.headlineMedium,
            )),
        ButtonWidget(
            onClick: () => log(''),
            color: ColorStyles.gray,
            backgroundColor: Colors.transparent,
            borderSideColor: ColorStyles.gray,
            minWidth: 203,
            height: 40,
            text: 'terms of use'),
        ButtonWidget(
            onClick: () => log(''),
            color: ColorStyles.gray,
            backgroundColor: Colors.transparent,
            borderSideColor: ColorStyles.gray,
            minWidth: 203,
            height: 40,
            text: 'о приложении'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => widget.cubit,
        child: BlocConsumer<ProfileSettingsCubit, MainState>(
          bloc: widget.cubit,
            listener: (BuildContext context, state) {
          if (state is Error) {
            if (codeErrors[state.error.code] == ApiErrors.validationError) {
              errors = state.error.messages;
            } else {
              errors = null;
            }
          }

          if (state is EmailChanged) {
            _navigateToActivateProfile();
          }

          if (state is ProfileDeleteSuccess) {
            _navigateToLogin();
            return;
          }

          if (state is UpdatingUser) {
            updating = true;
          } else {
            updating = false;
          }
        }, builder: (BuildContext context, state) {
          return Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: _renderTopBar(context, state),
              body: _renderBody(context, state));
        }));
  }
}
