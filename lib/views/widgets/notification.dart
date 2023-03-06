import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../styles.dart';

class NotificationWidget extends StatefulWidget {
  final String text;

  NotificationWidget({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return NotificationState();
  }
}

class NotificationState extends State<NotificationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late final Timer _timer;
  bool disabled = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500))
      ..forward();
    _controller.reverseDuration = const Duration(seconds: 3);

    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      close();
    });
  }

  void close() {
    _timer.cancel();
    _controller.reverse().then((_) => disable());
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  void disable() {
    setState(() {
      disabled = true;
    });
  }

  void restart() {
    _controller
        .animateBack(1,
            duration: const Duration(milliseconds: 500), curve: Curves.easeOut)
        .then((_) {
      _timer.cancel();
      _timer = Timer.periodic(const Duration(seconds: 3), (_) {
        close();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.bottomCenter,
        child: !disabled
            ? AnimatedBuilder(
                animation: _controller,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 35),
                  child: ElevatedButton(
                    onPressed: restart,
                    style: ButtonStyle(
                      overlayColor:
                          MaterialStateProperty.all<Color>(Colors.transparent),
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40)),
                      ),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          const EdgeInsets.only(
                              top: 5, bottom: 5, left: 20, right: 5)),
                      shadowColor:
                          MaterialStateProperty.all<Color>(Colors.transparent),
                      fixedSize:
                          MaterialStateProperty.all<Size>(const Size(220, 60)),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          ColorStyles.grayLight),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.transparent),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                            child: Text(widget.text,
                                style: TextStyles.text14Medium,
                                textAlign: TextAlign.center)),
                        IconButton(
                          onPressed: disable,
                          padding: const EdgeInsets.all(0),
                          icon: const Icon(Icons.close_rounded),
                          color: ColorStyles.black,
                          iconSize: 20,
                        ),
                      ],
                    ),
                  ),
                ),
                builder: (BuildContext context, Widget? child) {
                  return FadeTransition(
                      opacity:
                          _controller.drive(CurveTween(curve: Curves.easeOut)),
                      child: child);
                })
            : const SizedBox.shrink());
  }
}
