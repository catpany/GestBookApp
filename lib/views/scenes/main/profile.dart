import 'dart:developer';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sigest/bloc/profile/profile_cubit.dart';
import 'package:sigest/views/scenes/auth/login.dart';
import 'package:sigest/views/scenes/profile-settings.dart';
import 'package:sigest/views/widgets/button.dart';
import 'package:sigest/views/widgets/notice.dart';
import 'package:sigest/views/widgets/popup_window.dart';
import 'package:sigest/views/widgets/statistic.dart';

import '../../../bloc/main_cubit.dart';
import '../../styles.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late ProfileCubit cubit = ProfileCubit();

  @override
  void initState() {
    super.initState();
    cubit.load();
  }

  PreferredSizeWidget _renderTopBar(BuildContext context, MainState state) {
    return AppBar(
      title: const Text('ПРОФИЛЬ', style: TextStyles.title18Medium),
      backgroundColor: ColorStyles.accent,
      shadowColor: Colors.transparent,
      centerTitle: true,
    );
  }

  void _navigateToSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (BuildContext context) {
        return ProfileSettingsScreen();
      }));
  }

  void _navigateToLogin() {
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      MaterialPageRoute(builder: (BuildContext context) {
        return LoginScreen();
      }),
        (r) => false
    );
  }

  Widget _renderUserBlock() {
    return Container(
        width: double.infinity,
        height: 74,
        decoration: const BoxDecoration(
          border:
              Border(bottom: BorderSide(color: ColorStyles.gray, width: 2.0)),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 4),
                  child: Text(cubit.store.user.user.username.toUpperCase(),
                      style: Theme.of(context).textTheme.headlineMedium),
                ),
                '' != cubit.store.user.user.email
                    ? Text(cubit.store.user.user.email.toLowerCase(),
                        style: Theme.of(context).textTheme.bodySmall
                            ?.apply(color: ColorStyles.grayDark))
                    : const SizedBox.shrink(),
              ],
            ),
            Positioned(
                top: -10,
                right: -10,
                child: IconButton(
                  icon: const Icon(Icons.settings,
                      color: ColorStyles.grayDark, size: 30),
                  splashRadius: 20,
                  onPressed: () {
                    _navigateToSettings();
                  },
                  style: ButtonStyle(
                    overlayColor:
                        MaterialStateProperty.all<Color>(Colors.transparent),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        const EdgeInsets.all(0)),
                    shadowColor:
                        MaterialStateProperty.all<Color>(Colors.transparent),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.transparent),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.transparent),
                    alignment: Alignment.center,
                  ),
                )),
          ],
        ));
  }

  String _getImpactMode() {
    var mode = cubit.store.user.user.stat['impact_mode'];

    if (mode > 10 && mode < 14) return mode.toString() + ' дней';

    mode = mode.toString();

    if (mode.endsWith('1')) return mode + ' день';

    if (mode.endsWith('2') || mode.endsWith('3') || mode.endsWith('4')) return mode + ' дня';

    return mode + ' дней';
  }

  List<Widget> _renderStatisticsBlock(BuildContext context) {
    return [
      Container(
        margin: const EdgeInsets.only(top: 22, bottom: 17),
        alignment: AlignmentDirectional.centerStart,
        child: Text('СТАТИСТИКА', style: Theme.of(context).textTheme.headlineMedium),
      ),
      SizedBox(
        width: double.infinity,
        child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            runSpacing: 17,
            children: [
              StatisticWidget(
                type: StatisticType.days,
                title: _getImpactMode(),
                subtitle: 'ударный режим',
              ),
              // Spacer(),
              StatisticWidget(
                type: StatisticType.gestures,
                title: cubit.store.user.user.stat['goal_achieved'].toString() + '/' + (cubit.store.user.user.stat['goal']?? 10).toString() + ' жестов',
                subtitle: 'ежедн. цель',
              ),
              StatisticWidget(
                type: StatisticType.lessons,
                title: cubit.store.user.user.stat['goal_achieved'].toString() + '/' + cubit.getAllLessonsNumber().toString() + ' уроков',
                subtitle: 'пройдено',
              ),
            ]),
      )
    ];
  }

  List<Widget> _renderNotificationsBlock(BuildContext context) {
    return [
      Container(
        margin: const EdgeInsets.only(top: 22, bottom: 17),
        alignment: AlignmentDirectional.centerStart,
        width: double.infinity,
        child: Stack(
          children: [
            Row(
              children: [
                Text('УВЕДОМЛЕНИЯ', style: Theme.of(context).textTheme.headlineMedium),
                Padding(padding: const EdgeInsets.symmetric(horizontal: 10), child: Text('9', style: Theme.of(context).textTheme.headlineMedium?.apply(color: ColorStyles.red))),
              ],
            ),
            Positioned(
              right: 0,
              bottom: 0,
              width: 110,
              height: 22,
              child: ElevatedButton(
                onPressed: () => print('go to notices'),
                style: ButtonStyle(
                  overlayColor:
                  MaterialStateProperty.all<Color>(Colors.black12),
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      const EdgeInsets.all(0)),
                  shadowColor:
                  MaterialStateProperty.all<Color>(Colors.transparent),
                  backgroundColor:
                  MaterialStateProperty.all<Color>(Colors.transparent),
                  foregroundColor:
                  MaterialStateProperty.all<Color>(Colors.transparent),
                  alignment: Alignment.center,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('смотреть все', style: Theme.of(context).textTheme.bodySmall),
                    const Icon(Icons.chevron_right, size: 22, color: ColorStyles.grayDark)
                  ]
                )
              )
            )
          ],
        ),
      ),
      _renderNoticesList(),
    ];
  }

  Widget _renderNoticesList() {
    bool isEmpty = false;
    List<Map<String, String>> notices = [
      {
        'title': 'Технические работы',
        'text':
            '17 января с 17:30 до 21:00 планируются технические работы. Пожалуйста, доделайте все свои дела здесь до вышеуказанного времени'
      },
      {
        'title': 'Технические работы',
        'text':
            '17 января с 17:30 до 21:00 планируются технические работы. Пожалуйста, доделайте все свои дела здесь до вышеуказанного времени'
      },
      {
        'title': 'Технические работы',
        'text':
            '17 января с 17:30 до 21:00 планируются технические работы. Пожалуйста, доделайте все свои дела здесь до вышеуказанного времени'
      },
      {
        'title': 'Технические работы',
        'text':
            '17 января с 17:30 до 21:00 планируются технические работы. Пожалуйста, доделайте все свои дела здесь до вышеуказанного времени'
      }
    ];
    if (isEmpty) {
      return Container(
          width: double.infinity,
          height: 180,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "НЕТ НОВЫХ \n УВЕДОМЛЕНИЙ",
                style: Theme.of(context).textTheme.headlineMedium?.apply(color: ColorStyles.gray),
                textAlign: TextAlign.center,
              ),
              const Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Icon(Icons.email, size: 68, color: ColorStyles.gray)),
            ],
          ));
    }
    return Column(
      children: _renderNotices(notices)
    );
  }

  List<Widget> _renderNotices(List<Map<String, String>> notices) {
    List<Widget> noticeWidgets = [];
    int length = min(notices.length, 3);

    for(var index = 0; index < length; index++){
      noticeWidgets.add(Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.5),
          child: NoticeWidget(
              title: notices[index]['title'] ?? '',
              text: notices[index]['text'] ?? ''))
      );
    }

    return noticeWidgets;
  }

  Widget _renderQuitButton() {
    return Container(
        margin: const EdgeInsets.only(top: 28),
        alignment: AlignmentDirectional.center,
        child: ButtonWidget(
          text: 'ВЫЙТИ ИЗ ПРОФИЛЯ',
          backgroundColor: Colors.transparent,
          color: ColorStyles.red,
          minWidth: 200,
          height: 40,
          borderSideColor: ColorStyles.red,
          onClick: () => _renderQuitDialog(),
        ));
  }

  Future<void> _renderQuitDialog() async {
    await showDialog<void>(
        context: context,
        builder: (context) {
          return PopupWindowWidget(
            title: 'Выход из профиля',
            text: 'Вы уверены, что хотите выйти?',
            onAcceptButtonPress: () => cubit.quit(),
            onRejectButtonPress: () => Navigator.pop(context),
            acceptButtonText: 'выйти',
            rejectButtonText: 'отмена',
          );
        }
    );
  }

  Widget _renderBody(BuildContext context, MainState state) {
    if(state is DataLoaded) {
      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
            children: [_renderUserBlock()] +
                _renderStatisticsBlock(context) +
                // _renderNotificationsBlock(context) +
                [_renderQuitButton()]),
      );
    }

    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => cubit,
        child: BlocConsumer<ProfileCubit, MainState>(
            listener: (BuildContext context, state) {
              if (state is ProfileQuited) {
                _navigateToLogin();
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
