import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sigest/views/widgets/widget_wrapper.dart';

import '../styles.dart';

enum StatisticType { lessons, days, gestures }

class StatisticWidget extends StatelessWidget {
  final StatisticType type;
  final String title;
  final String subtitle;

  const StatisticWidget(
      {Key? key,
      required this.type,
      required this.title,
      required this.subtitle})
      : super(key: key);

  Widget _renderIcon() {
    switch (type) {
      case StatisticType.lessons:
        return const Icon(
          Icons.layers_outlined,
          color: ColorStyles.purple,
          size: 27,
        );
      case StatisticType.days:
        return const Icon(
          Icons.local_fire_department,
          color: ColorStyles.orange,
          size: 27,
        );
      case StatisticType.gestures:
        return const Icon(
          Icons.star_rounded,
          color: ColorStyles.cyan,
          size: 27,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WidgetWrapper(
      width: 155,
      height: 75,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(padding: const EdgeInsets.only(right: 3), child: _renderIcon()),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title, style: Theme.of(context).textTheme.bodyMedium),
              Text(subtitle, style: TextStyles.text12Regular, softWrap: true, maxLines: 2,),
            ],
          ))
        ],
      ),
    );
  }
}
