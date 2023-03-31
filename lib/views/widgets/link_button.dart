import 'package:flutter/material.dart';

class LinkButtonWidget extends StatelessWidget {
  final Function onClick;
  final String text;
  final Color color;
  final Color splashColor;
  final double height;

  const LinkButtonWidget({
    Key? key,
    required this.onClick,
    this.text = '',
    required this.color,
    required this.splashColor,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: height,
        child: TextButton(
          onPressed: () => onClick(context),
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) {
                  return Colors.transparent;
                }
                return null;
              },
            ),
          ),
          // style: ElevatedButton.styleFrom(
          //   backgroundColor: Colors.black.withOpacity(0.00),
          // ),
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
        ));
  }
}
