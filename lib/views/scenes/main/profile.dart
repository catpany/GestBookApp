import 'dart:developer';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sigest/bloc/profile/profile_cubit.dart';
import 'package:sigest/views/widgets/button.dart';
import 'package:sigest/views/widgets/notice.dart';
import 'package:sigest/views/widgets/statistic.dart';

import '../../../bloc/main_cubit.dart';
import '../../../models/user.dart';
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
    return PreferredSize(
        preferredSize: const Size(double.infinity, 60),
        child: Container(
          color: ColorStyles.accent,
          alignment: AlignmentDirectional.center,
          // padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 33),
          child: const Text('ПРОФИЛЬ', style: TextStyles.title18Medium),
        ));
  }

  void _navigateToSettings() {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (BuildContext context) {
    //     return SplashScreen();
    //   }));
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
                      style: TextStyles.text16Medium),
                ),
                '' != cubit.store.user.user.email
                    ? Text(cubit.store.user.user.email.toLowerCase(),
                        style: TextStyles.text14Regular
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
                    print('go to settings');
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

  List<Widget> _renderStatisticsBlock() {
    return [
      Container(
        margin: const EdgeInsets.only(top: 22, bottom: 17),
        alignment: AlignmentDirectional.centerStart,
        child: const Text('СТАТИСТИКА', style: TextStyles.text16Medium),
      ),
      Container(
        width: double.infinity,
        child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            runSpacing: 17,
            children: [
              StatisticWidget(
                type: StatisticType.days,
                title: '14 дней',
                subtitle: 'ударный режим',
              ),
              // Spacer(),
              StatisticWidget(
                type: StatisticType.gestures,
                title: '15/20 жестов',
                subtitle: 'ежедн. цель',
              ),
              StatisticWidget(
                type: StatisticType.lessons,
                title: '30/70 уроков',
                subtitle: 'пройдено',
              ),
            ]),
      )
    ];
  }

  List<Widget> _renderNotificationsBlock() {
    return [
      Container(
        margin: const EdgeInsets.only(top: 22, bottom: 17),
        alignment: AlignmentDirectional.centerStart,
        width: double.infinity,
        child: Stack(
          children: [
            Row(
              children: [
                const Text('УВЕДОМЛЕНИЯ', style: TextStyles.text16Medium),
                Padding(padding: const EdgeInsets.symmetric(horizontal: 10), child: Text('9', style: TextStyles.text16Medium?.apply(color: ColorStyles.red))),
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
                  children: const [
                    Text('смотреть все', style: TextStyles.text14Regular),
                    Icon(Icons.chevron_right, size: 22, color: ColorStyles.black)
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
                style: TextStyles.text16Medium?.apply(color: ColorStyles.gray),
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
          padding: EdgeInsets.symmetric(vertical: 8.5),
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
        child: ButtonWidget(
          text: 'ВЫЙТИ ИЗ ПРОФИЛЯ',
          backgroundColor: ColorStyles.white,
          color: ColorStyles.red,
          splashColor: ColorStyles.white,
          minWidth: 200,
          height: 40,
          borderSideColor: ColorStyles.red,
          onClick: () => print('tap on quit'),
        ));
  }

  Widget _renderBody(BuildContext context, MainState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 18),
      child: Column(
          children: [_renderUserBlock()] +
              _renderStatisticsBlock() +
              _renderNotificationsBlock() +
              [_renderQuitButton()]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => cubit,
        child: BlocConsumer<ProfileCubit, MainState>(
            listener: (context, state) {},
            builder: (context, state) {
              return Scaffold(
                  resizeToAvoidBottomInset: false,
                  backgroundColor: Colors.white,
                  appBar: _renderTopBar(context, state),
                  body: _renderBody(context, state));
            }));
  }
}
