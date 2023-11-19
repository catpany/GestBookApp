import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sigest/bloc/main_cubit.dart';
import 'package:sigest/bloc/units/units_cubit.dart';
import 'package:sigest/views/styles.dart';
import 'package:sigest/views/widgets/unit_list.dart';

import '../../widgets/notification.dart';
import '../fast_repetition/fast_repetition.dart';
import '../lesson/lesson.dart';
import '../theory.dart';

class UnitsScreen extends StatefulWidget {
  UnitsScreen({Key? key}) : super(key: key);
  final UnitsCubit cubit = UnitsCubit();

  @override
  _UnitsScreenState createState() => _UnitsScreenState();
}

class _UnitsScreenState extends State<UnitsScreen> {
  @override
  void initState() {
    super.initState();
    widget.cubit.load();
  }

  PreferredSizeWidget _renderTopBar() {
    return PreferredSize(
        preferredSize: const Size(double.infinity, 51),
        child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 33),
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(width: 2, color: ColorStyles.gray))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: const Icon(Icons.star_rounded,
                      color: ColorStyles.yellow, size: 27),
                  margin: const EdgeInsets.only(right: 2),
                ),
                Container(
                  child: Text(
                      widget.cubit.store.user.user.stat['goal_achieved']
                              .toString() +
                          '/' +
                          (widget.cubit.store.user.user.stat['goal'] ?? 10)
                              .toString(),
                      style: Theme.of(context).textTheme.bodySmall),
                  margin: const EdgeInsets.only(right: 30),
                ),
                Container(
                  child: const Icon(Icons.local_fire_department,
                      color: ColorStyles.orange, size: 27),
                  margin: const EdgeInsets.only(right: 2),
                ),
                Text(
                    widget.cubit.store.user.user.stat['impact_mode'].toString(),
                    style: Theme.of(context).textTheme.bodySmall),
              ],
            )));
  }

  Widget _renderNotificationBlock(state) {
    if (state is NotificationShow) {
      return NotificationWidget(text: 'Ошибка загрузки данных', onClose: () => widget.cubit.hideNotification(),);
    }

    return const SizedBox.shrink();
  }

  void _navigateToLesson(String lessonId, int levelOrder) {
    Navigator.of(context, rootNavigator: true)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return LessonScreen(
        lessonId: lessonId,
        levelOrder: levelOrder,
      );
    })).then((withError) {
      if (withError == true) {
        // log(ModalRoute.of(context)?.settings.name.toString() ?? 'null');
        widget.cubit.showNotification();
      }
    });
  }

  void _navigateToTheory(String lessonId, int finished, int total) {
    Navigator.of(context, rootNavigator: true)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return TheoryScreen(lessonId: lessonId, finished: finished, total: total);
    })).then((withError) {
      if (withError == true) {
        widget.cubit.showNotification();
      }
    });
  }

  void _navigateToFastRepetition(String lessonId) {
    Navigator.of(context, rootNavigator: true)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return FastRepetitionScreen(lessonId: lessonId);
    })).then((withError) {
      if (withError == true) {
        Navigator.of(context, rootNavigator: true).pop();
        widget.cubit.showNotification();
      }
    });
  }

  Widget _renderBody(BuildContext context, MainState state) {
    if (state is! DataLoading) {
      return Stack(alignment: Alignment.topCenter, children: [
        UnitListWidget(
          units: widget.cubit.store.units.units,
          onStartLesson: (String lessonId, int levelOrder) =>
              _navigateToLesson(lessonId, levelOrder),
          onStartFastRepetition: (String lessonId) =>
              _navigateToFastRepetition(lessonId),
          onViewTheory: (String lessonId, int finished, int total) =>
              _navigateToTheory(lessonId, finished, total),
        ),
        _renderNotificationBlock(state)
      ]);
    }

    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => widget.cubit,
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: _renderTopBar(),
            body: BlocConsumer<UnitsCubit, MainState>(
                listener: (context, state) {
                },
                builder: (context, state) {
                  return _renderBody(context, state);
                })));
  }
}
