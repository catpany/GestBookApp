import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ButtonWidget extends StatefulWidget {
  final Function onClick;
  final String text;
  final Color color;
  final Color backgroundColor;
  final double borderRadius;
  final double minWidth;
  final double height;
  final Color borderSideColor;
  final Widget? leadingIcon;
  final Widget? trailingIcon;

  const ButtonWidget({
    Key? key,
    required this.onClick,
    this.text = '',
    required this.color,
    required this.backgroundColor,
    this.borderRadius = 5,
    required this.minWidth,
    required this.height,
    this.borderSideColor = Colors.transparent,
    this.leadingIcon,
    this.trailingIcon,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ButtonWidgetState();
}

class _ButtonWidgetState extends State<ButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () => widget.onClick(),
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed)) {
                return Colors.black12;
              }

              return null;
            },
          ),
          shape: MaterialStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(widget.borderRadius)),
          ),
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
              const EdgeInsets.all(5)),
          shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
          minimumSize: MaterialStateProperty.all<Size>(
              Size(widget.minWidth, widget.height)),
          backgroundColor:
              MaterialStateProperty.all<Color>(widget.backgroundColor),
          side: MaterialStateProperty.all<BorderSide>(BorderSide(
            color: widget.borderSideColor,
            width: 2,
          )),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          // This is must when you are using Row widget inside Raised Button
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildLeadingIcon(widget.leadingIcon),
            Text(widget.text.toUpperCase(),
                style: Theme.of(context).textTheme.headlineLarge?.apply(color: widget.color)),
            _buildTrailingIcon(widget.trailingIcon)
          ],
        ));
  }

  Widget _buildLeadingIcon(Widget? leadingIcon) {
    if (null != leadingIcon) {
      return leadingIcon;
    }

    return const SizedBox.shrink();
  }

  Widget _buildTrailingIcon(Widget? trailingIcon) {
    if (null != trailingIcon) {
      return trailingIcon;
    }

    return const SizedBox.shrink();
  }
}
