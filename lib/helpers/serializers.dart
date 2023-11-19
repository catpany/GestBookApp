import 'package:flutter/material.dart';

class Serializer {
  static TimeOfDay stringToTimeOfDay(String time) {
    return TimeOfDay(hour: int.parse(time.split(":")[0]),minute: int.parse(time.split(":")[1]));
  }

  static String timeOfDayToString(BuildContext context, TimeOfDay time) {
    return time.format(context);
  }
}