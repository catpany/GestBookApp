import 'package:flutter/cupertino.dart';
import 'package:flutter_switch/flutter_switch.dart';

import '../styles.dart';

class SwitchWidget extends StatefulWidget {
  final Function(bool val) onSwitch;
  final bool value;

  const SwitchWidget({Key? key, required this.onSwitch, required this.value})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _SwitchWidgetState();
}

class _SwitchWidgetState extends State<SwitchWidget> {
  late bool val;

  @override
  void initState() {
    super.initState();
    val = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 51.0,
        height: 26.0,
        child: FlutterSwitch(
          width: 51.0,
          height: 26.0,
          activeColor: ColorStyles.green,
          inactiveColor: ColorStyles.gray,
          toggleSize: 18.0,
          value: val,
          borderRadius: 20.0,
          padding: 4.0,
          onToggle: (newVal) {
            setState(() {
              val = newVal;
            });

            widget.onSwitch(val);
          },
        ));
  }
}
