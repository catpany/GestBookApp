import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/fast_repetition/fast_repetition_cubit.dart';
import '../../../bloc/main_cubit.dart';
import '../../styles.dart';
import '../../widgets/button.dart';
import '../../widgets/exercise_popup.dart';
import '../../widgets/popup_window.dart';
import '../../widgets/progress_bar.dart';
import '../loading.dart';
import 'choose_word_exercise.dart';
import 'yes_no_exercise.dart';

class FastRepetitionScreen extends StatefulWidget {
  final String lessonId;

  const FastRepetitionScreen({Key? key, required this.lessonId})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => FastRepetitionScreenState();
}

class FastRepetitionScreenState extends State<FastRepetitionScreen> {
  late final FastRepetitionCubit cubit =
      FastRepetitionCubit(lessonId: widget.lessonId);
  Stopwatch timer = Stopwatch();

  @override
  void initState() {
    super.initState();
    cubit.load();
  }

  PreferredSizeWidget? _renderTopBar(BuildContext context, MainState state) {
    if (state is FastRepetitionCompleted) {
      return PreferredSize(
        child: Container(
            height: 60,
            padding: const EdgeInsets.only(left: 27, right: 14),
            alignment: AlignmentDirectional.centerEnd,
            child: Container(
                margin: const EdgeInsets.only(left: 12),
                child: IconButton(
                    splashRadius: 24,
                    padding: EdgeInsets.zero,
                    iconSize: 34,
                    onPressed: () {
                      cubit.finishFastRepetition(timer.elapsed.inSeconds);
                    },
                    icon: const Icon(
                      Icons.close,
                      color: ColorStyles.grayDark,
                    )))),
        preferredSize: const Size(double.infinity, 60),
      );
    }

    if (state is! DataLoading) {
      return PreferredSize(
        child: Container(
            height: 60,
            padding: const EdgeInsets.only(left: 27, right: 14),
            alignment: AlignmentDirectional.center,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      child: ProgressBarWidget(
                    progress: cubit.progress,
                  )),
                  Container(
                      margin: const EdgeInsets.only(left: 12),
                      child: IconButton(
                          splashRadius: 24,
                          padding: EdgeInsets.zero,
                          iconSize: 34,
                          onPressed: () => _renderQuitDialog(state),
                          icon: const Icon(
                            Icons.close,
                            color: ColorStyles.grayDark,
                          )))
                ])),
        preferredSize: const Size(double.infinity, 60),
      );
    }

    return null;
  }

  Widget _nextExercise() {
    switch (cubit.currentExercise.type) {
      case 2:
        return const ChooseWordExerciseScreen();
      case 4:
        return const YesNoExerciseScreen();
      default:
        throw Exception('No such exercise');
    }
  }

  Widget _renderBody(BuildContext context, MainState state) {
    if (state is DataLoading) {
      return const LoadingScreen();
    }

    if (state is FastRepetitionCompleted) {
      return _renderFastRepetitionCompletedScreen();
    }

    return Stack(children: [_nextExercise(), _renderNextButton(state)]);
  }

  Widget _renderNextButton(MainState state) {
    return Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: ExercisePopupWidget(
          show: state is ExercisePassed || state is ExerciseFailed,
          error: state is ExerciseFailed,
          onClick: () => cubit.next(),
        ));
  }

  String getTime(int time) {
    return (time / 60).floor().toString() + ':' + (time % 60).toString();
  }

  String getBestTime() {
    int? bestTime = cubit.store.lessonInfo.lessonInfo.bestTime;
    int time = timer.elapsed.inSeconds;

    if ((bestTime != null && time < bestTime && cubit.failedExercises == 0) ||
        (bestTime == null && cubit.failedExercises == 0)) {
      return getTime(time);
    } else if (bestTime != null && bestTime < time) {
      return getTime(bestTime);
    } else {
      return '???';
    }
  }

  Widget _renderFastRepetitionCompletedScreen() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.only(top: 40, right: 20, left: 20),
      child: Stack(alignment: AlignmentDirectional.topCenter, children: [
        Column(children: [
          Container(
              margin: const EdgeInsets.only(bottom: 30),
              child: Text(
                'Пройдено!',
                style: Theme.of(context).textTheme.displayMedium,
              )),
          Row(
            children: [
              Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    border: Border.all(width: 2, color: ColorStyles.yellow)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: Text('Лучшее время',
                            style: Theme.of(context).textTheme.bodyLarge)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            margin: const EdgeInsets.only(right: 8),
                            child: const Icon(Icons.workspace_premium,
                                size: 34, color: ColorStyles.yellow)),
                        Text(getBestTime(),
                            style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    )
                  ],
                ),
              )),
              Container(width: 14),
              Flexible(
                  child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    border: Border.all(width: 2, color: ColorStyles.purple)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: Text('Текущее время',
                            style: Theme.of(context).textTheme.bodyLarge)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            margin: const EdgeInsets.only(right: 8),
                            child: const Icon(Icons.timer_outlined,
                                size: 34, color: ColorStyles.purple)),
                        Text(getTime(timer.elapsed.inSeconds),
                            style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    )
                  ],
                ),
              )),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 18),
              child: Row(
                children: [
              Text('Правильных ответов',
                  style: Theme.of(context).textTheme.bodyMedium),
              Expanded(child: Container(
                alignment: AlignmentDirectional.centerEnd,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                margin: const EdgeInsets.only(left: 16),
                child: Text(
                  cubit.passedExercises.toString(),
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.apply(color: ColorStyles.white),
                ),
                decoration: const BoxDecoration(
                    color: ColorStyles.green,
                    borderRadius: BorderRadius.all(Radius.circular(5))),
              )),
            ],
          )),
          Container(
              margin: const EdgeInsets.only(top: 12),
              child: Row(
                // crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('Неравильных ответов',
                  style: Theme.of(context).textTheme.bodyMedium),
              Expanded(child: Container(
                margin: const EdgeInsets.only(left: 16),
                alignment: AlignmentDirectional.centerEnd,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                child: Text(
                  cubit.failedExercises.toString(),
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.apply(color: ColorStyles.white),
                ),
                decoration: const BoxDecoration(
                    color: ColorStyles.red,
                    borderRadius: BorderRadius.all(Radius.circular(5))),
              ),),
            ],
          ))
        ]),
        Positioned(
          right: 0,
          left: 0,
          bottom: 40,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            width: double.infinity,
            height: 40,
            alignment: AlignmentDirectional.center,
            child: ButtonWidget(
              text: 'заново',
              color: Colors.white,
              backgroundColor: ColorStyles.green,
              onClick: () {
                cubit.restartFastRepetition(timer.elapsed.inSeconds);
              },
              minWidth: double.infinity,
              height: 40,
            ),
          ),
        )
      ]),
    );
  }

  void onQuit() {
    Navigator.pop(context);
  }

  Future<bool> _renderQuitDialog(MainState state) async {
    if (state is! DataLoading) {
      timer.stop();
      return await showDialog(
              context: context,
              builder: (context) {
                return PopupWindowWidget(
                  title: 'Вы уверены, что хотите выйти?',
                  text: 'Весь прогресс текущего уровня будет потерян',
                  onAcceptButtonPress: () {
                    Navigator.pop(context);
                    onQuit();
                  },
                  onRejectButtonPress: () {
                    timer.start();
                    Navigator.pop(context);
                  },
                  acceptButtonText: 'выйти',
                  rejectButtonText: 'остаться',
                );
              }) ??
          false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => cubit,
        lazy: false,
        child: BlocConsumer<FastRepetitionCubit, MainState>(
            bloc: cubit,
            listener: (BuildContext context, state) {
              if (state is QuitFastRepetition) {
                onQuit();
              }

              if (state is FastRepetitionCompleted) {
                timer.stop();
              }

              if (state is FastRepetitionStarted) {
                timer.reset();
                timer.start();
              }
            },
            builder: (BuildContext context, state) {
              return SafeArea(
                  child: WillPopScope(
                      onWillPop: () => _renderQuitDialog(state),
                      child: Scaffold(
                          resizeToAvoidBottomInset: false,
                          appBar: _renderTopBar(context, state),
                          body: _renderBody(context, state))));
            }));
  }
}
