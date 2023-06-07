import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sigest/views/styles.dart';

import '../../models/lesson.dart';
import 'button.dart';

class LessonDialogWidget extends StatefulWidget {
  final LessonModel lesson;
  final Function(String id, int levelOrder) onStartLesson;
  final Function(String id) onStartFastRepetition;
  final Function(String id, int finished, int total) onViewTheory;

  const LessonDialogWidget(
      {Key? key,
      required this.lesson,
      required this.onStartLesson,
      required this.onViewTheory,
      required this.onStartFastRepetition})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LessonDialogState();
  }
}

class _LessonDialogState extends State<LessonDialogWidget> {
  List<Widget> _renderActionButtons() {
    List<Widget> list = <Widget>[];

    if (true == widget.lesson.withTheory) {
      list.add(Container(
          margin: const EdgeInsets.only(bottom: 4),
          child: ButtonWidget(
            onClick: () {
              widget.onViewTheory(widget.lesson.id, widget.lesson.levelsFinished, widget.lesson.levelsTotal);
            },
            color: ColorStyles.accent,
            borderSideColor: ColorStyles.accent,
            backgroundColor: Colors.transparent,
            text: 'Теория',
            minWidth: double.infinity,
            height: 41,
          )));
    }

    if (widget.lesson.levelsFinished == widget.lesson.levelsTotal) {
      list.add(ButtonWidget(
        onClick: () {
          widget.onStartFastRepetition(widget.lesson.id);
        },
        color: ColorStyles.white,
        backgroundColor: ColorStyles.purple,
        text: 'Повторить',
        minWidth: double.infinity,
        height: 41,
      ));
    }

    if (0 == widget.lesson.levelsFinished) {
      list.add(ButtonWidget(
        onClick: () {
          widget.onStartLesson(widget.lesson.id, 1);
        },
        color: ColorStyles.white,
        backgroundColor: ColorStyles.green,
        text: 'Начать',
        minWidth: double.infinity,
        height: 41,
      ));
    }

    if (0 != widget.lesson.levelsFinished &&
        widget.lesson.levelsFinished < widget.lesson.levelsTotal) {
      list.add(ButtonWidget(
        onClick: () {
          widget.onStartLesson(
              widget.lesson.id, widget.lesson.levelsFinished + 1);
        },
        color: ColorStyles.white,
        backgroundColor: ColorStyles.green,
        text: 'Продолжить',
        minWidth: double.infinity,
        height: 41,
      ));
    }

    return list;
  }

  List<Widget> _renderLevels() {
    List<Widget> list = <Widget>[];
    for (var i = 0; i < widget.lesson.levelsTotal; i++) {
      list.add(_renderLevel(
        isFinished: (i < widget.lesson.levelsFinished),
        isActive: (i <= widget.lesson.levelsFinished),
        order: i + 1,
      ));
    }

    return list;
  }

  Widget _renderLevel(
      {required bool isFinished, required bool isActive, required int order}) {
    return Container(
        margin: const EdgeInsets.only(bottom: 14),
        child: SizedBox(
            width: 40,
            height: 40,
            child: ElevatedButton(
              child: Icon(Icons.star_rounded,
                  size: 40,
                  color: isFinished ? ColorStyles.yellow : ColorStyles.gray),
              style: ButtonStyle(
                overlayColor:
                    MaterialStateProperty.all<Color>(Colors.transparent),
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    const EdgeInsets.all(0.0)),
                shadowColor:
                    MaterialStateProperty.all<Color>(Colors.transparent),
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.transparent),
                foregroundColor:
                    MaterialStateProperty.all<Color>(Colors.transparent),
              ),
              onPressed: () {
                isActive
                    ? widget.onStartLesson(
                        widget.lesson.id, order)
                    : {};
              },
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          width: 225,
          padding:
              const EdgeInsets.only(left: 30, right: 30, top: 20, bottom: 20),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                Wrap(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  spacing: 5,
                  alignment: WrapAlignment.start,
                  runSpacing: 10,
                  runAlignment: WrapAlignment.start,
                  children: _renderLevels(),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: _renderActionButtons(),
                ),
              ]),
        ));
  }
}
