import 'package:flutter/material.dart';

/*class ButtonWidget extends StatefulWidget {
  final Function onClick;
  final String text;
  final Color color;
  final Color splashColor;
  final double minWidth;
  final double height;

  const ButtonWidget({Key? key,
    required this.onClick,
    this.text = '',
    required this.color,
    required this.splashColor,
    required this.minWidth,
    required this.height,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ButtonWidgetState();
}*/

class LinkButtonWidget extends StatelessWidget {
  final Function onClick;
  final String text;
  final Color color;
  final Color splashColor;
  final double height;

  const LinkButtonWidget({Key? key,
    required this.onClick,
    this.text = '',
    required this.color,
    required this.splashColor,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      SizedBox(
        height: height,
        child: TextButton(
          onPressed: () => onClick(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black.withOpacity(0.00),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 14.0,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal,
              letterSpacing: 1.0,
              decoration: TextDecoration.underline,
              fontFamily: 'Jost',
              height: 1.2,
            ),
          ),
        )
      );
  }
}