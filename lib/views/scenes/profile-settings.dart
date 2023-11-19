import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sigest/api/response.dart';
import 'package:sigest/views/scenes/auth/activate-profile.dart';
import 'package:sigest/views/scenes/auth/login.dart';
import 'package:sigest/views/widgets/button.dart';
import 'package:sigest/views/widgets/edit_user_form.dart';
import 'package:sigest/views/widgets/switch.dart';
import 'package:sigest/views/widgets/widget_wrapper.dart';

import '../../bloc/main_cubit.dart';
import '../../bloc/profile-settings/profile_settings_cubit.dart';
import '../../helpers/notification_service.dart';
import '../../helpers/serializers.dart';
import '../../main.dart';
import '../styles.dart';
import '../widgets/notification.dart';
import 'about.dart';

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
  int scheduledNotificationId = 0;

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
      title: Text('НАСТРОЙКИ', style: Theme.of(context).textTheme.titleSmall),
      shadowColor: Colors.transparent,
      centerTitle: true,
      flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [ColorStyles.orange, ColorStyles.accent]))),
    );
  }

  Widget _renderBody(BuildContext context, MainState state) {
    if (state is! DataLoading && state is! ProfileDeleteSuccess) {
      widget.bindControllers['username']?.text =
          widget.cubit.store.user.user.username;
      widget.bindControllers['email']?.text =
          widget.cubit.store.user.user.email;

      return Stack(alignment: Alignment.topCenter, children: [
        SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 18),
        child: Column(children: [
          _renderUserFormBlock(),
          _renderCommonSettingsBlock(),
          _renderNotificationSettingsBlock(),
          _renderAdditionalBlock(),
        ]),
      ),
        _renderNotificationBlock(state)
      ]);
    }
    return const SizedBox.shrink();
  }

  Widget _renderUserFormBlock() {
    return EditUserFormWidget(
      canChangePassword: widget.cubit.canChangePassword(),
      canChangeEmail: widget.cubit.canChangeEmail(),
      onDelete: () {
        widget.cubit.deleteUser();
      },
      onSave: (bindControllers) {
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
                  // ToggleModeWidget(
                  //   selectedModes: [
                  //     !widget.cubit.store.settings.current.isRightHanded,
                  //     widget.cubit.store.settings.current.isRightHanded
                  //   ],
                  //   onSelect: (val) {
                  //     widget.cubit.updateIsRightHanded(val);
                  //   },
                  // ),
                  WidgetWrapper(
                      alignment: AlignmentDirectional.center,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 26, vertical: 10),
                      width: 146,
                      height: 110,
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 19),
                            child: Text('Темная тема',
                                style: Theme.of(context).textTheme.bodySmall),
                          ),
                          SwitchWidget(
                              onSwitch: (val) {
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
          alignment: AlignmentDirectional.center,
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
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      SwitchWidget(
                          onSwitch: (val) {
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
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      GestureDetector(
                        onTap: () async {
                          TimeOfDay? result = await showTimePicker(context: context, initialTime: Serializer.stringToTimeOfDay(widget.cubit.store.settings.current.notificationTime),
                            useRootNavigator: false,
                          );
                          if (result != null && !Serializer.timeOfDayToString(context, result).contains(widget.cubit.store.settings.current.notificationTime)) {
                            widget.cubit.updateNotificationTime(Serializer.timeOfDayToString(context, result));
                          }
                        },
                          child:
                      Container(
                        alignment: Alignment.center,
                        width: 62,
                        height: 33,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: ColorStyles.gray,
                              width: 2,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
                        child: Text(widget.cubit.store.settings.current.notificationTime.toString(),
                            style: Theme.of(context).textTheme.bodySmall),
                      ))
                    ],
                  ))
            ],
          ),
        ),
        // ToDo: motivation messages
        // WidgetWrapper(
        //   alignment: AlignmentDirectional.center,
        //   width: double.infinity,
        //   padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        //   margin: const EdgeInsets.only(top: 17),
        //   child: SizedBox(
        //       width: double.infinity,
        //       child: Wrap(
        //         alignment: WrapAlignment.spaceBetween,
        //         crossAxisAlignment: WrapCrossAlignment.center,
        //         runSpacing: 17,
        //         children: [
        //           Text('Мотивационные сообщения',
        //               style: Theme.of(context).textTheme.bodyMedium),
        //           SwitchWidget(
        //               onSwitch: (val) {
        //                 widget.cubit.updateMessagesEnabled(val);
        //               },
        //               value:
        //                   widget.cubit.store.settings.current.messagesEnabled)
        //         ],
        //       )),
        // )
      ],
    );
  }

  void _navigateToAbout() {
    Navigator.of(context).push(
        PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 400),
            transitionsBuilder:
                (_, Animation<double> animation, __, Widget child) =>
                FadeTransition(
                    opacity: CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeIn,
                    ),
                    child: child),
            pageBuilder: (_, __, ___) {
              return const AboutAppScreen();
            })
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
        // ToDo: terms of use
        // ButtonWidget(
        //     onClick: () => log(''),
        //     color: ColorStyles.grayDark,
        //     backgroundColor: Colors.transparent,
        //     borderSideColor: ColorStyles.gray,
        //     minWidth: 203,
        //     height: 40,
        //     text: 'terms of use'),
        ButtonWidget(
            onClick: () => _navigateToAbout(),
            color: ColorStyles.grayDark,
            backgroundColor: Colors.transparent,
            borderSideColor: ColorStyles.gray,
            minWidth: 203,
            height: 40,
            text: 'о приложении'),
      ],
    );
  }

  Future<void> generateNotification() {
    return notificationService.showScheduledNotification(id: NotificationService.scheduledNotificationId,
        title: 'Книга Жестов',
        body: NotificationService.getRandomNotificationBody(),
        payload: 'Приступим!',
        time: Serializer.stringToTimeOfDay(widget.cubit.store.settings.current.notificationTime));
  }

  Widget _renderNotificationBlock(state) {
    if (state is DataLoadingError) {
      return NotificationWidget(text: 'Ошибка загрузки данных', onClose: widget.cubit.hideNotification,);
    }

    return const SizedBox.shrink();
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

              if (state is NotificationsEnabledChanged) {
                if (widget.cubit.store.settings.current.notificationsEnabled) {
                  generateNotification();
                } else {
                  notificationService.cancelNotification(scheduledNotificationId);
                }
              }

              if (state is NotificationTimeChanged && widget.cubit.store.settings.current.notificationsEnabled) {
                generateNotification();
              }
            },
            builder: (BuildContext context, state) {
              return Scaffold(
                  resizeToAvoidBottomInset: false,
                  appBar: _renderTopBar(context, state),
                  body: _renderBody(context, state));
            }));
  }
}
