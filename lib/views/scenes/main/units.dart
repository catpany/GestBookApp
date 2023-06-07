import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sigest/bloc/main_cubit.dart';
import 'package:sigest/bloc/units/units_cubit.dart';
import 'package:sigest/views/styles.dart';
import 'package:sigest/views/widgets/unit_list.dart';

import '../exercises/lesson.dart';
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

  void _navigateToLesson(String lessonId, int levelOrder) {
    Navigator.of(context, rootNavigator: true)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return LessonScreen(
        lessonId: lessonId,
        levelOrder: levelOrder,
      );
    })).then((value) => setState(() {}));
  }

  void _navigateToTheory(String lessonId, int finished, int total) {
    Navigator.of(context, rootNavigator: true)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return TheoryScreen(lessonId: lessonId, finished: finished, total: total);
    })).then((value) => setState(() {}));
  }

  Widget _renderBody(BuildContext context, MainState state) {
    if (state is! DataLoading) {
      return UnitListWidget(
        units: widget.cubit.store.units.units,
        onStartLesson: (String lessonId, int levelOrder) =>
            _navigateToLesson(lessonId, levelOrder),
        onStartFastRepetition: (String lessonId) => {},
        onViewTheory: (String lessonId, int finished, int total) =>
            _navigateToTheory(lessonId, finished, total),
      );
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
                listener: (context, state) {},
                builder: (context, state) {
                  return _renderBody(context, state);
                })));
  }
}
