import 'dart:developer';

import 'package:flutter/material.dart';

import '../styles.dart';
import 'button.dart';

class ExercisePopupWidget extends StatefulWidget {
  final bool show;
  final bool error;
  final String errorText;
  final Function onClick;

  const ExercisePopupWidget(
      {Key? key,
      required this.show,
      required this.error,
      this.errorText = '',
      required this.onClick})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => ExercisePopupWidgetState();
}

class ExercisePopupWidgetState extends State<ExercisePopupWidget> {
  double _height = 0;
  Color _color = Colors.transparent;
  String _text = '';

  @override
  Widget build(BuildContext context) {
    _height = widget.show ? 130 : 0;

    if (widget.show) {
      _color = widget.error ? ColorStyles.red : ColorStyles.green;
      _text = widget.error ? 'Неправильно!' : 'Правильно!';
    }

    return AnimatedContainer(
      width: double.infinity,
      height: _height,
      color: Theme.of(context).scaffoldBackgroundColor,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
      child: Container(
          decoration: BoxDecoration(
            color: _color.withAlpha(50),
            border: Border(top: BorderSide(color: _color, width: 2.0)),
          ),
          width: double.infinity,
          alignment: AlignmentDirectional.center,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(children: [
            Expanded(
                child: Container(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(_text,
                        style: Theme.of(context).textTheme.titleMedium?.apply(color: _color)))),
            Expanded(
                child: Container(
                  alignment: AlignmentDirectional.center,
                    padding: const EdgeInsets.only(bottom: 23),
                    child: ButtonWidget(
              text: 'Продолжить',
              color: Colors.white,
              backgroundColor: _color,
              onClick: () {
                widget.onClick();
              },
              minWidth: double.infinity,
              height: 40,
            )))
          ])),
    );
  }
}
