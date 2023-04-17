import 'package:flutter/cupertino.dart';

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
    return Container(
      width: double.infinity,
      height: 110,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: ColorStyles.gray, width: 2.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 7),
          child: Text(title, style: TextStyles.text16Medium)
          ),
          Text(text, style: TextStyles.text14Regular?.apply(color: ColorStyles.grayDark), overflow: TextOverflow.ellipsis, maxLines: 2,)
        ],
      ),
    );
  }

}