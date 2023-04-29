import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sigest/views/styles.dart';
import 'package:sigest/views/widgets/progress_rect.dart';

class LessonWidget extends StatefulWidget {
  final double progress;
  final int icon;
  final Color color;
  final String title;
  final Function onTap;

  const LessonWidget({Key? key, required this.progress, required this.icon, required this.color, required this.title, required this.onTap}) : super(key: key);

  @override
  _LessonWidgetState createState() => _LessonWidgetState();
}

class _LessonWidgetState extends State<LessonWidget> {

  Widget _renderProgressIndicator(double progress) {
    if(progress > 0) {
      return CustomPaint(
          painter: ProgressRect(progress),
          size: const Size.square(58.0),
      );
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {log('press on lesson'); widget.onTap();},
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            height: 64,
            width: 64,
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: ColorStyles.gray,
                      width: 6,
                    ),
                      borderRadius: const BorderRadius.all(Radius.circular(13))
                  ),
                ),
                Icon(
                  IconData(widget.icon, fontFamily: 'MaterialIcons'),
                  color: widget.color,
                  size: 37,
                ),
                _renderProgressIndicator(widget.progress),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 12),
            child: Text(widget.title.toUpperCase(), style: Theme.of(context).textTheme.bodySmall, overflow: TextOverflow.visible, softWrap: true, textAlign: TextAlign.center,),
          ),
        ],
      ),
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
            const EdgeInsets.all(0)),
        shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
        fixedSize: MaterialStateProperty.all<Size>(const Size(70, 110)),
        backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
      ),
    );
  }

}