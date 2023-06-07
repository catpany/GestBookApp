import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sigest/bloc/exercise/exercise_cubit.dart';
import 'package:sigest/views/scenes/exercises/choose_word_exercise.dart';
import 'package:sigest/views/scenes/exercises/yes_no_exercise.dart';

import '../../../bloc/main_cubit.dart';
import '../../styles.dart';
import '../../widgets/button.dart';
import '../../widgets/exercise_popup.dart';
import '../../widgets/popup_window.dart';
import '../../widgets/progress_bar.dart';
import 'choose_gest_exercise.dart';
import 'loading.dart';
import 'match_exercise.dart';
import 'new_gest_exercise.dart';

class LessonScreen extends StatefulWidget {
  final String lessonId;
  final int levelOrder;

  const LessonScreen(
      {Key? key, required this.lessonId, required this.levelOrder})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => LessonScreenState();
}

class LessonScreenState extends State<LessonScreen> {
  late final LessonCubit cubit =
      LessonCubit(lessonId: widget.lessonId, levelOrder: widget.levelOrder);

  @override
  void initState() {
    super.initState();
    cubit.load();
  }

  PreferredSizeWidget? _renderTopBar(BuildContext context, MainState state) {
    if (state is LevelCompleted) {
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
                      cubit.quitLevel();
                    },
                    icon: const Icon(
                      Icons.close,
                      color: ColorStyles.grayDark,
                    )))),
        preferredSize: const Size(double.infinity, 60),
      );
    }

    if (state is! DataLoading && state is! LevelCompleted) {
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
      case 1:
        return const NewGestExerciseScreen();
      case 2:
        return const ChooseWordExerciseScreen();
      case 3:
        return const ChooseGestExerciseScreen();
      case 4:
        return const YesNoExerciseScreen();
      case 5:
        return const MatchExerciseScreen();
      default:
        throw Exception('No such exercise');
    }
  }

  Widget _renderBody(BuildContext context, MainState state) {
    if (state is DataLoading) {
      return const LoadingScreen();
    }

    if (state is LevelCompleted) {
      return _renderNextLevelScreen();
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

  Widget _renderNextLevelScreen() {
    return SizedBox(
      width: double.infinity,
        height: double.infinity,
        child: Stack(
      alignment: AlignmentDirectional.topCenter,
      children: [
        Text(
          'Уровень пройден!',
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.apply(color: ColorStyles.accent),
        ),
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
                text: 'Продолжить',
                color: Colors.white,
                backgroundColor: ColorStyles.green,
                onClick: () {
                  if (cubit.isLastLevel()) {
                    cubit.quitLevel();
                  } else {
                    cubit.startNextLevel();
                  }
                },
                minWidth: double.infinity,
                height: 40,
              ),
            ))
      ],
    ));
  }

  void onQuit() {
    Navigator.pop(context);
  }

  Future<bool> _renderQuitDialog(MainState state) async {
    if (state is! DataLoading) {
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
                  onRejectButtonPress: () => Navigator.pop(context),
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
        child: BlocConsumer<LessonCubit, MainState>(
            bloc: cubit,
            listener: (BuildContext context, state) {
              if (state is QuitLevel) {
                onQuit();
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
