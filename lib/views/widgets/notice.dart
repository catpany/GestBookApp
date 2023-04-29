import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sigest/views/widgets/widget_wrapper.dart';

import '../styles.dart';

// enum NoticeType {
//   alert,
//   info
// }

class NoticeWidget extends StatelessWidget {
  // NoticeType type;
  String title;
  String text;

  NoticeWidget({Key? key, required this.title, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WidgetWrapper(
      width: double.infinity,
      height: 110,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(10),
      //   border: Border.all(color: ColorStyles.gray, width: 2.0),
      // ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 7),
          child: Text(title, style: Theme.of(context).textTheme.headlineMedium)
          ),
          Text(text, style: Theme.of(context).textTheme.bodySmall?.apply(color: ColorStyles.grayDark), overflow: TextOverflow.ellipsis, maxLines: 2,)
        ],
      ),
    );
  }

}