import 'dart:developer';

import 'package:flutter/material.dart';

import '../styles.dart';

class ProgressBarWidget extends StatefulWidget {
  final double progress;

  const ProgressBarWidget({Key? key, required this.progress}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ProgressBarWidgetState();
}

class ProgressBarWidgetState extends State<ProgressBarWidget> {
  final GlobalKey _widgetKey = GlobalKey();
  double _width = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_updateHeight);
  }

  void _updateHeight(_) {
    final RenderBox renderBox =
    _widgetKey.currentContext?.findRenderObject() as RenderBox;

    final Size size = renderBox.size;

    setState(() {
      _width = size.width;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Stack(
      alignment: AlignmentDirectional.centerStart,
      children: <Widget>[
        Container(
          key: _widgetKey,
          height: 12,
          width: double.infinity,
          decoration: BoxDecoration(
            color: ColorStyles.gray,
            borderRadius: BorderRadius.circular((5)), // round angle
          ),
        ),
        AnimatedContainer(
          width: _width * widget.progress,
          height: 12,
          curve: Curves.ease,
          decoration: BoxDecoration(
            color: ColorStyles.yellow,
            borderRadius: BorderRadius.circular((5)), // round angle
          ),
          duration: const Duration(milliseconds: 700),
        ),
      ],
    );
  }
}
