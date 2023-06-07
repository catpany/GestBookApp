import 'package:flutter/material.dart';

import '../styles.dart';

class WidgetWrapper extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final double? width;
  final double? height;
  final AlignmentDirectional? alignment;

  const WidgetWrapper({
    Key? key,
    required this.child,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(0),
    this.margin = const EdgeInsets.all(0),
    this.alignment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      padding: padding,
      margin: margin,
      width: width,
      height: height,
      decoration: BoxDecoration(
          border: Border.all(
            color: ColorStyles.gray,
            width: 2,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: child,
    );
  }
}
