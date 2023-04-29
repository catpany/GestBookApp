import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sigest/views/styles.dart';

import '../../models/lesson.dart';
import 'button.dart';

class LessonDialogWidget extends StatefulWidget {
  final LessonModel lesson;
  final Function onStartLesson;

  const LessonDialogWidget(
      {Key? key, required this.lesson, required this.onStartLesson})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LessonDialogState();
  }
}
 class _LessonDialogState extends State<LessonDialogWidget> {

  List<Widget> _renderActionButtons() {
    List<Widget> list = <Widget>[];

    if (true == widget.lesson.theory) {
      list.add(Container(
          margin: const EdgeInsets.only(bottom: 4),
          child: ButtonWidget(
            onClick: () {
              log('press on theory');
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
          log('press on repeat');
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
          log('press on start');
          widget.onStartLesson(widget.lesson.id);
          setState(() {});
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
          log('press on continue');
          widget.onStartLesson(widget.lesson.id);
          setState(() {});
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
          isActive: (i <= widget.lesson.levelsFinished)));
    }

    return list;
  }

  Widget _renderLevel({required bool isFinished, required bool isActive}) {
    return Container(
        margin: const EdgeInsets.only(bottom: 14),
        child: SizedBox(
            width: 40,
            height: 40,
            child: ElevatedButton(
              child: Icon(Icons.star_rounded,
                  size: 40,
                  color:
                      isFinished ? ColorStyles.yellow : ColorStyles.gray),
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
                isActive ? log('press level') : log('pres inactive level');
              },
            )));
  }

  // @override
  // Widget build(BuildContext context) {
  //   return AlertDialog(
  //     contentPadding:
  //         const EdgeInsets.only(left: 30, right: 30, top: 20, bottom: 10),
  //     actionsAlignment: MainAxisAlignment.center,
  //     actionsPadding: const EdgeInsets.only(left: 30, right: 30, bottom: 20),
  //     shadowColor: Colors.transparent,
  //     surfaceTintColor: Colors.transparent,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(10),
  //     ),
  //     content: Row(
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: _renderLevels(),
  //     ),
  //     actions: <Widget>[
  //       Column(
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: _renderActionButtons(),
  //       ),
  //     ],
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child:
        Container(
          width: 225,
          padding: const EdgeInsets.only(left: 30, right: 30, top: 20, bottom: 20),
          child:
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
            children:[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _renderLevels(),
            ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: _renderActionButtons(),
                ),
          ]
          ),
        )
    );
  }
}
