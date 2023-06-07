import 'dart:developer';

import 'package:flutter/material.dart';

import '../styles.dart';

class TextRowWidget extends StatefulWidget {
  final String text;

  const TextRowWidget({Key? key, required this.text}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TextRowWidgetState();
}

class _TextRowWidgetState extends State<TextRowWidget> {
  final GlobalKey _widgetKey = GlobalKey();
  double height = 92;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_updateRowsHeight);
  }

  void _updateRowsHeight(_) {
    final RenderBox renderBox = _widgetKey.currentContext?.findRenderObject() as RenderBox;
    final Size size = renderBox.size;

    setState(() {
      height = size.height;
    });
  }

  Widget _renderRows() {
    List<Widget> rows = [];
    double rowHeight = 46;
    int rowCount = (height / rowHeight).ceil();

    for (int i = 1; i <= rowCount; i++) {
      rows.add(Container(
          height: rowHeight,
          decoration: const BoxDecoration(
            border:
                Border(bottom: BorderSide(color: ColorStyles.gray, width: 2.0)),
          )));
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: rows,
    );
  }

  @override
  Widget build(BuildContext context) {
      return Stack(
        children: [
          Text(
            widget.text,
            key: _widgetKey,
            style: Theme.of(context).textTheme.bodySmall?.apply(heightFactor: 2),
            maxLines: 10,
            overflow: TextOverflow.ellipsis,
          ),
          _renderRows(),
        ],
      );
  }
}
