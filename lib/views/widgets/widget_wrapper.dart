import 'package:flutter/cupertino.dart';

import '../styles.dart';

class WidgetWrapper extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final double width;
  final double? height;

  const WidgetWrapper(
      {Key? key,
      required this.child,
      required this.width,
      this.height,
      this.padding = const EdgeInsets.all(0),
      this.margin = const EdgeInsets.all(0)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: AlignmentDirectional.center,
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