import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sigest/views/styles.dart';

class TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var path = Path();

    var points = const [
      Offset(0, 0),
      Offset(15, 10),
      Offset(0, 20),
      Offset(0, 0),
    ];

    path.addPolygon(points, false);

    canvas.drawPoints(
        PointMode.polygon,
        points,
        Paint()
          ..style = PaintingStyle.fill
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 5.0
          ..color = ColorStyles.green);

    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.fill
        ..color = ColorStyles.green,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class PickerWidget extends StatefulWidget {
  final dynamic minValue;
  final dynamic maxValue;
  final dynamic step;
  final dynamic current;
  final bool onTimer;
  final bool onDispose;
  Function(dynamic value) onPick;
  final bool isTime;

  PickerWidget(
      {Key? key,
      required this.minValue,
      required this.maxValue,
      required this.step,
      required this.onPick,
      required this.current,
      this.onTimer = false,
      this.onDispose = true,
      this.isTime = false})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _PickerWidgetState();
}

class _PickerWidgetState extends State<PickerWidget> {
  dynamic value;
  dynamic prevSelectedValue;
  late final Timer _timer;

  @override
  void initState() {
    super.initState();
    value = widget.current;
    prevSelectedValue = widget.current;
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (widget.onTimer && prevSelectedValue != value) {
        prevSelectedValue = value;
        widget.onPick(value);
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    if (widget.onDispose && widget.current != value) {
      widget.onPick(value);
    }
    super.dispose();
  }

  Widget _renderLeftButton() {
    return Container(
        margin: const EdgeInsets.only(right: 5),
        width: 30,
        height: 30,
        child: ElevatedButton(
          onPressed: () {
            var newValue = value - widget.step;

            if (newValue >= widget.minValue) {
              setState(() {
                value -= widget.step;
              });
            }
          },
          child: Transform.rotate(
              angle: pi,
              child: CustomPaint(
                size: const Size.square(20),
                foregroundPainter: TrianglePainter(),
              )),
          style: ButtonStyle(
            alignment: AlignmentDirectional.center,
            overlayColor: MaterialStateProperty.all<Color?>(Colors.transparent),
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                const EdgeInsets.all(0)),
            shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
            backgroundColor:
                MaterialStateProperty.all<Color>(Colors.transparent),
          ),
        ));
  }

  Widget _renderRightButton() {
    return Container(
        margin: const EdgeInsets.only(left: 5),
        width: 30,
        height: 30,
        child: ElevatedButton(
          onPressed: () {
            var newValue = value + widget.step;

            if (newValue <= widget.maxValue) {
              setState(() {
                value += widget.step;
              });
            }
          },
          child: CustomPaint(
            size: const Size.square(20),
            foregroundPainter: TrianglePainter(),
          ),
          style: ButtonStyle(
            alignment: AlignmentDirectional.center,
            overlayColor: MaterialStateProperty.all<Color?>(Colors.transparent),
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                const EdgeInsets.all(0)),
            shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
            backgroundColor:
                MaterialStateProperty.all<Color>(Colors.transparent),
            minimumSize: MaterialStateProperty.all<Size>(const Size(30, 30)),
          ),
        ));
  }

  Widget _renderBody() {
    return Container(
      alignment: Alignment.center,
      width: 62,
      height: 33,
      decoration: BoxDecoration(
          border: Border.all(
            color: ColorStyles.gray,
            width: 2,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: Text(widget.isTime ? value.toString() + ':00' : value.toString(),
          style: Theme.of(context).textTheme.bodySmall),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 132,
        child: Row(
          children: [_renderLeftButton(), _renderBody(), _renderRightButton()],
        ));
  }
}
