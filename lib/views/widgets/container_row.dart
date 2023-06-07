import 'package:flutter/material.dart';
import 'package:sigest/views/widgets/widget_wrapper.dart';

import '../../models/gesture-info.dart';
import '../styles.dart';

class ContainerRowWidget extends StatefulWidget {
  final Map<String, GestureInfoModel> options;
  final Function(String id) onSelect;
  final Function(String id) onRemove;

  const ContainerRowWidget({Key? key, required this.options, required this.onSelect, required this.onRemove}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ContainerRowWidgetState();
}

class _ContainerRowWidgetState extends State<ContainerRowWidget>
    with TickerProviderStateMixin<ContainerRowWidget> {
  final GlobalKey _widgetKey = GlobalKey();
  double height = 100;
  List<String> selected = [];
  List<String> removed = [];
  Map<String, GlobalKey> draggableKeys = {};
  Map<String, GlobalKey> targetKeys = {};
  Map<String, AnimationController> _animationControllers = {};
  Map<String, Animation<Offset>> _animations = {};
  Map<String, Tween<Offset>> _tweens = {};
  int removing = 0;
  double rowHeight = 50;

  @override
  void initState() {
    for (var option in widget.options.keys) {
      draggableKeys[option] = GlobalKey();
      targetKeys[option] = GlobalKey();
      _animationControllers[option] = AnimationController(
          duration: const Duration(milliseconds: 300), vsync: this);
      _tweens[option] =
          Tween<Offset>(begin: const Offset(0, 0), end: const Offset(0, 0));
      _animations[option] = _tweens[option]!.animate(CurvedAnimation(
          parent: _animationControllers[option] ??
              AnimationController(
                  duration: const Duration(milliseconds: 500), vsync: this),
          curve: Curves.easeOut));
    }

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_updateHeight);
  }

  @override
  void dispose() {
    for (var option in widget.options.keys) {
      _animationControllers[option]?.dispose();
    }
    super.dispose();
  }

  void _updateHeight(_) {
    final RenderBox renderBox =
        _widgetKey.currentContext?.findRenderObject() as RenderBox;

    final Size size = renderBox.size;

    setState(() {
      height = size.height;
    });
  }

  Offset _getPosition(GlobalKey? key) {
    final RenderBox renderBox =
        key?.currentContext?.findRenderObject() as RenderBox;

    final Size size = renderBox.size;

    return renderBox.localToGlobal(Offset(size.width / 2, size.height / 2));
  }

  Offset _getOffset(GlobalKey target, GlobalKey initial) {
    Offset targetOffset = _getPosition(target);
    Offset currentOffset = _getPosition(initial);

    return Offset(
        targetOffset.dx - currentOffset.dx, targetOffset.dy - currentOffset.dy);
  }

  Widget _renderBody() {
    return Stack(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: _renderRows() + [_renderOptions()],
        ),
        DragTarget<String>(
          onLeave: (String? ans) => {},
          builder: (BuildContext context, List<dynamic> accepted,
              List<dynamic> rejected) {
            return Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 4),
                height: (height / rowHeight).ceil() * rowHeight,
                child: Wrap(
                  spacing: 14,
                  runSpacing: 11,
                  children: _renderSelectedOptions(),
                ));
          },
          onWillAccept: (data) {
            return true;
          },
          onAccept: (data) {
            setState(() {
              selected.add(data);
            });

            widget.onSelect(data);
          },
        )
      ],
    );
  }

  List<Widget> _renderRows() {
    List<Widget> rows = [];
    int rowCount = (height / rowHeight).ceil();

    for (int i = 1; i <= rowCount; i++) {
      rows.add(Container(
          height: rowHeight,
          decoration: const BoxDecoration(
            border:
                Border(bottom: BorderSide(color: ColorStyles.gray, width: 2.0)),
          )));
    }

    return rows;
  }

  List<Widget> _renderSelectedOptions() {
    List<Widget> gestures = [];
    for (String gesture in selected) {
      String? name = widget.options[gesture]?.name;

      gestures.add(AnimatedBuilder(
          animation: _animations[gesture] as Animation,
          builder: (BuildContext context, Widget? child) {
            return Transform.translate(
                offset: _animations[gesture]!.value, child: child);
          },
          child: SizedBox(
              height: 40,
              child: ElevatedButton(
                key: targetKeys[gesture],
                onPressed: () {
                  _moveBack(gesture);
                },
                child:
                    Text(name ?? '', style: Theme.of(context).textTheme.bodySmall),
                style: ButtonStyle(
                  side: MaterialStateProperty.all<BorderSide>(const BorderSide(
                    color: ColorStyles.gray,
                    width: 2,
                  )),
                  shape: MaterialStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  overlayColor:
                      MaterialStateProperty.all<Color>(Colors.transparent),
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 6)),
                  shadowColor:
                      MaterialStateProperty.all<Color>(Colors.transparent),
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Theme.of(context).scaffoldBackgroundColor),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.transparent),
                  alignment: Alignment.center,
                ),
              ))));
    }

    return gestures;
  }

  void _moveBack(String gesture) {
    Offset offset = _getOffset(draggableKeys[gesture]!, targetKeys[gesture]!);
    _tweens[gesture]?.end = offset;
    removing++;

    _animationControllers[gesture]?.reset();
    _animationControllers[gesture]?.forward().whenComplete(() {
      removed.add(gesture);
      removing--;

      if (removing == 0) {
        for (var element in removed) {
          _tweens[element]?.end = const Offset(0, 0);
          selected.remove(element);
          widget.onRemove(element);
        }

        removed.clear();
        setState(() {});
      }
    });
  }

  Widget _renderGesture(String optionId) {
    String? name = widget.options[optionId]?.name;

    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 6),
        child: Text(name ?? '', style: Theme.of(context).textTheme.bodySmall),
        height: 40,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: ColorStyles.gray, width: 2.0),
        ));
  }

  Widget _renderEmptyGesture(String optionId) {
    String? name = widget.options[optionId]?.name;

    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 6),
        child: Text(name ?? '',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.apply(color: ColorStyles.gray)),
        height: 40,
        decoration: BoxDecoration(
          color: ColorStyles.gray,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: ColorStyles.gray, width: 2.0),
        ));
  }

  Widget _renderOptions() {
    List<Widget> containers = [];

    for (String option in widget.options.keys) {
      containers.add(Container(
          key: draggableKeys[option],
          child: selected.contains(option)
              ? _renderEmptyGesture(option)
              : Draggable<String>(
                  data: option,
                  child: _renderGesture(option),
                  feedback: _renderGesture(option),
                  childWhenDragging: _renderEmptyGesture(option),
                )));
    }

    return Container(
        margin: const EdgeInsets.only(top: 20),
        width: double.infinity,
        child: Wrap(
          key: _widgetKey,
          spacing: 14,
          runSpacing: 12,
          children: containers,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return _renderBody();
  }
}
