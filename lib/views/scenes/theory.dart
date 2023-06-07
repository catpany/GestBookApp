import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sigest/bloc/main_cubit.dart';
import 'package:sigest/views/scenes/exercises/lesson.dart';

import '../../bloc/theory/theory_cubit.dart';
import '../styles.dart';
import '../widgets/button.dart';
import 'exercises/loading.dart';

class TheoryScreen extends StatefulWidget {
  final String lessonId;
  final int finished;
  final int total;

  const TheoryScreen(
      {Key? key, required this.lessonId, required this.finished, required this.total})
      : super(key: key);

  @override
  _TheoryScreenState createState() => _TheoryScreenState();
}

class _TheoryScreenState extends State<TheoryScreen> {
  late final TheoryCubit cubit = TheoryCubit(lessonId: widget.lessonId);

  @override
  void initState() {
    super.initState();
    cubit.load();
  }

  Widget _renderBody(MainState state) {
    if (state is! DataLoading) {
      return RawScrollbar(
          thumbColor: ColorStyles.gray,
          padding: const EdgeInsets.only(right: 6),
          radius: const Radius.circular(5),
          thickness: 8,
          child: SingleChildScrollView(
              child: Container(
            padding: const EdgeInsets.only(right: 20, left: 20, bottom: 20, top: 0),
            child: Text(cubit.store.lessonInfo.lessonInfo.theory,
                style: Theme.of(context).textTheme.bodySmall),
          )));
    }

    return const LoadingScreen();
  }

  PreferredSizeWidget _renderTopBar() {
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
                    _quit();
                  },
                  icon: const Icon(
                    Icons.close,
                    color: ColorStyles.grayDark,
                  )))),
      preferredSize: const Size(double.infinity, 60),
    );
  }

  Widget _renderBottomBar() {
    return BottomAppBar(
      elevation: 0,
      color: Theme.of(context).scaffoldBackgroundColor,
      surfaceTintColor: Colors.transparent,
      child: Container(
        height: 100.0,
        alignment: AlignmentDirectional.center,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ButtonWidget(
            text: 'продолжить',
            backgroundColor: ColorStyles.green,
            color: ColorStyles.white,
            minWidth: double.infinity,
            height: 40,
            onClick: () {
              if (widget.finished == widget.total) {
                _quit();
              } else {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return LessonScreen(lessonId: widget.lessonId, levelOrder: widget.finished + 1);
                }));
              }
            }),
      ),
    );
  }

  void _quit() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => cubit,
        lazy: false,
        child: BlocConsumer<TheoryCubit, MainState>(
            bloc: cubit,
            listener: (BuildContext context, state) {},
            builder: (BuildContext context, state) {
              return SafeArea(
                  child: Scaffold(
                      resizeToAvoidBottomInset: false,
                      appBar: _renderTopBar(),
                      bottomNavigationBar: _renderBottomBar(),
                      body: _renderBody(state)));
            }));
  }
}
