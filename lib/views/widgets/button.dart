import 'package:flutter/material.dart';

class ButtonWidget extends StatefulWidget {
  final Function onClick;
  final String text;
  final Color color;
  final Color backgroundColor;
  final Color splashColor;
  final double borderRadius;
  final double minWidth;
  final double height;
  final Color borderSideColor;
  final Widget? leadingIcon;
  final Widget? trailingIcon;

  const ButtonWidget({Key? key,
    required this.onClick,
    this.text = '',
    required this.color,
    required this.backgroundColor,
    required this.splashColor,
    required this.borderRadius,
    required this.minWidth,
    required this.height,
    required this.borderSideColor,
    this.leadingIcon,
    this.trailingIcon
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ButtonWidgetState();
}

class _ButtonWidgetState extends State<ButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () => widget.onClick(),
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.backgroundColor,
          foregroundColor: widget.splashColor,
          minimumSize: Size(widget.minWidth, widget.height),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          // This is must when you are using Row widget inside Raised Button
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildLeadingIcon(widget.leadingIcon),
            Text(
              widget.text.toUpperCase(),
              style: TextStyle(
                color: widget.color,
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.normal,
                letterSpacing: 1.2,
              ),
            ),
            _buildTrailingIcon(widget.trailingIcon)
          ],
        )
    );
  }

  Widget _buildLeadingIcon(Widget? leadingIcon) {
    if (null != leadingIcon) {
      return Row(
        children: <Widget>[leadingIcon, SizedBox(width: 10)],
      );
    }
    return Container();
  }

  Widget _buildTrailingIcon(Widget? trailingIcon) {
    if (null != trailingIcon) {
      return Row(
        children: <Widget>[
          SizedBox(width: 10),
          trailingIcon,
        ],
      );
    }
    return Container();
  }
}