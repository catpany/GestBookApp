import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sigest/views/widgets/button.dart';
import 'package:sigest/views/widgets/widget_wrapper.dart';

import '../styles.dart';

class ToggleModeWidget extends StatefulWidget {
  List<bool> selectedModes;
  final Function(bool val) onSelect;

  ToggleModeWidget({Key? key, required this.selectedModes, required this.onSelect}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ToggleModeWidgetState();

}

class _ToggleModeWidgetState extends State<ToggleModeWidget> {
  List<bool> selectedModes = [false, true];

  @override
  void initState() {
    super.initState();
    selectedModes = widget.selectedModes;
  }

  void _onSelect(int newIndex) {
    setState(() {
      for (int index = 0; index < selectedModes.length; index++) {
        if (index == newIndex) {
          selectedModes[index] = true;
        } else {
          selectedModes[index] = false;
        }
      }
    });

    widget.onSelect(0 == newIndex? false : true);
  }

  @override
  Widget build(BuildContext context) {
    return WidgetWrapper(
        // padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 10),
        width: 146,
        height: 110,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             Text('Ведущая рука', style: Theme.of(context).textTheme.bodySmall,),
            Row (
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 3),
                  child: ButtonWidget(
                    minWidth: 39,
                    height: 37,
                    borderRadius: 10,
                    backgroundColor: selectedModes[0]? ColorStyles.green : Colors.transparent,
                    onClick: () => _onSelect(0),
                    leadingIcon: Icon(Icons.back_hand, color: selectedModes[0]? Colors.white : ColorStyles.gray),
                    color: ColorStyles.white,
                  ),
                ),
                ButtonWidget(
                  minWidth: 39,
                  height: 37,
                  borderRadius: 10,
                  backgroundColor: selectedModes[1]? ColorStyles.green : Colors.transparent,
                  onClick: () => _onSelect(1),
                  leadingIcon: Icon(Icons.back_hand, color: selectedModes[1]? ColorStyles.white : ColorStyles.gray),
                  color: ColorStyles.white,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.only(right: 13),
                  child: Text('левая', style: Theme.of(context).textTheme.bodySmall),
                ),
                 Text('правая', style: Theme.of(context).textTheme.bodySmall),
              ],
            )
          ],
        )
    );
  }

}