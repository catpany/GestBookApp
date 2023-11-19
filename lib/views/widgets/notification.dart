import 'dart:async';

import 'package:flutter/material.dart';

import '../styles.dart';

class NotificationWidget extends StatefulWidget {
  final String text;
  final Function onClose;

  const NotificationWidget({
    Key? key,
    required this.text,
    required this.onClose
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
  bool active = true;

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
    _controller.reverse().then((_) {_controller.reset();
    disable(); widget.onClose();});
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  void closeNotification() {
    _timer.cancel();
    _controller.reset();
    disable();
    widget.onClose();
  }

  void disable() {
    setState(() {
      active = false;
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
        child: active
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
                          ColorStyles.gray),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.transparent),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                            child: Text(widget.text,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: ColorStyles.black),
                                textAlign: TextAlign.center)),
                        IconButton(
                          onPressed: closeNotification,
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
