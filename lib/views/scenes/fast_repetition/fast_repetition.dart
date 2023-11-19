import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/fast_repetition/fast_repetition_cubit.dart';
import '../../../bloc/main_cubit.dart';
import '../../styles.dart';
import '../../widgets/exercise_popup.dart';
import '../../widgets/popup_window.dart';
import '../../widgets/progress_bar.dart';
import '../loading.dart';
import 'choose_word_exercise.dart';
import 'fast_repetition_finished.dart';
import 'yes_no_exercise.dart';

class FastRepetitionScreen extends StatefulWidget {
  final String lessonId;

  const FastRepetitionScreen({Key? key, required this.lessonId})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => FastRepetitionScreenState();
}

class FastRepetitionScreenState extends State<FastRepetitionScreen> {
  final AudioPlayer player = AudioPlayer();
  late final FastRepetitionCubit cubit =
      FastRepetitionCubit(lessonId: widget.lessonId);
  Stopwatch timer = Stopwatch();

  Map<String, String> audioAssets = {
    'success': 'audio/success_sound.wav',
    'error': 'audio/error_sound.wav',
    'completed': 'audio/fast_rep_passed.wav'
  };

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
        return ChooseWordExerciseScreen();
      case 4:
        return YesNoExerciseScreen();
      default:
        throw Exception('No such exercise');
    }
  }

  Widget _renderBody(BuildContext context, MainState state) {
    if (state is DataLoading) {
      return const LoadingScreen();
    }

    if (state is FastRepetitionCompleted) {
      return FastRepetitionFinishedScreen(
        time: timer.elapsed.inSeconds,
      );
    }

    if (state is! DataLoadingError) {
      return Stack(children: [_nextExercise(), _renderNextButton(state)]);
    }

    return const SizedBox.shrink();
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

    if (cubit.failedExercises == 0 &&
        (bestTime != null && time < bestTime || bestTime == null)) {
      return getTime(time);
    } else if (bestTime != null) {
      return getTime(bestTime);
    } else {
      return '???';
    }
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
              } else if (state is ExercisePassed) {
                player.play(AssetSource(audioAssets['success']!));
              } else if (state is ExerciseFailed) {
                player.play(AssetSource(audioAssets['error']!));
              } else if (state is FastRepetitionCompleted) {
                player.play(AssetSource(audioAssets['completed']!));
                timer.stop();
              } else if (state is FastRepetitionStarted) {
                timer.reset();
                timer.start();
              } else if (state is DataLoadingError) {
                Navigator.of(context).pop(true);
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
