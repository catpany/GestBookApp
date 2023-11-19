import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/fast_repetition/fast_repetition_cubit.dart';
import '../../styles.dart';
import '../../widgets/button.dart';

class FastRepetitionFinishedScreen extends StatefulWidget {
  final int time;
  const FastRepetitionFinishedScreen({Key? key, required this.time})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => FastRepetitionFinishedScreenState();
}

class FastRepetitionFinishedScreenState extends State<FastRepetitionFinishedScreen> {
  final AudioPlayer player = AudioPlayer();
  late FastRepetitionCubit cubit;
  double _result = 0;
  bool _bestTimeUpdated = false;
  late int oldBestTime;
  Map<String, String> audioAssets = {
    'completed': 'audio/best_time.wav'
  };

  @override
  void initState() {
    super.initState();
    cubit = context.read<FastRepetitionCubit>();
    oldBestTime = cubit.store.lessonInfo.lessonInfo.bestTime!;
    WidgetsBinding.instance.addPostFrameCallback(_updateResult);
  }

  void _updateResult(_) {
    setState(() {
      _result = _getResult();
    });
  }

  String getTime(int time) {
    return (time / 60).floor().toString() + ':' + (time % 60).toString();
  }

  String getBestTime() {
    int? bestTime = cubit.store.lessonInfo.lessonInfo.bestTime;
    int time = widget.time;

    if (cubit.failedExercises == 0 &&
        (bestTime != null && time < bestTime || bestTime == null)) {
      return getTime(time);
    } else if (bestTime != null) {
      return getTime(bestTime);
    } else {
      return '???';
    }
  }

  double _getResult() {
    return cubit.passedExercises / cubit.exercises.length;
  }

  void _updateBestTime() {
    if (getTime(oldBestTime) != getBestTime()) {
      setState(() {
        _bestTimeUpdated = true;
      });
      player.play(AssetSource(audioAssets['completed']!));
    }
  }

  Widget _getResultScale() {
    return Stack(alignment: Alignment.center, children: [
      Container(
        width: 110,
        height: 36,
        decoration: const BoxDecoration(
          color: ColorStyles.gray,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
      Positioned(
        left: 0,
        child: AnimatedContainer(
          width: 110 * _result,
          height: 36,
          curve: Curves.ease,
          decoration: const BoxDecoration(
            color: ColorStyles.green,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          duration: const Duration(milliseconds: 1000),
          onEnd: _updateBestTime,
        ),
      ),
      Text(
        (_getResult() * 100).round().toString() + '%',
        style: Theme.of(context)
            .textTheme
            .headlineSmall
            ?.apply(fontSizeFactor: 1.1, color: ColorStyles.white),
      )
    ]);
  }

  Widget _renderBody() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.only(top: 40, right: 20, left: 20),
      child: Stack(alignment: AlignmentDirectional.topCenter, children: [
        Column(children: [
          Text(
            'Пройдено!',
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.apply(fontSizeFactor: 1.5),
          ),
          Container(
              margin: const EdgeInsets.only(top: 50),
              child: Text('Лучшее время',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.apply(fontSizeFactor: 1.1))),
          Container(
              margin: const EdgeInsets.only(top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      margin: const EdgeInsets.only(right: 8),
                      child: const Icon(Icons.workspace_premium,
                          size: 55, color: ColorStyles.yellow)),
                    Text(_bestTimeUpdated ? getBestTime() + "!": getTime(oldBestTime),
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.apply(fontSizeFactor: 1.1, color: _bestTimeUpdated ? ColorStyles.red : null)),
                ],
              )),
          Container(
              margin: const EdgeInsets.only(top: 15),
              child: Text('Текущее время',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.apply(fontSizeFactor: 1.1))),
          Container(
            margin: const EdgeInsets.only(top: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    margin: const EdgeInsets.only(right: 8),
                    child: const Icon(Icons.timer_rounded,
                        size: 50, color: ColorStyles.cyan)),
                Text(getTime(widget.time),
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.apply(fontSizeFactor: 1.1)),
              ],
            ),
          ),
          Container(
              margin: const EdgeInsets.only(top: 15),
              child: Text('Результат',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.apply(fontSizeFactor: 1.1))),
          Container(
              margin: const EdgeInsets.only(top: 15), child: _getResultScale()),
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
                cubit.restartFastRepetition(widget.time);
              },
              minWidth: double.infinity,
              height: 40,
            ),
          ),
        )
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _renderBody();
  }
}
