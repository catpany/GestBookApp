import 'package:flutter/material.dart';

import '../../models/gesture-info.dart';
import '../styles.dart';

class ContainerRowWidget extends StatefulWidget {
  final Map<String, GestureInfoModel> options;
  final Function(String id) onSelect;
  final Function(String id) onRemove;
  final List<String> selected;

  const ContainerRowWidget(
      {Key? key,
      required this.options,
      required this.onSelect,
      required this.onRemove, this.selected = const []})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ContainerRowWidgetState();
}

class _ContainerRowWidgetState extends State<ContainerRowWidget>
    with TickerProviderStateMixin<ContainerRowWidget> {
  final GlobalKey _widgetKey = GlobalKey();
  final GlobalKey _widgetRowKey = GlobalKey();
  double height = 100;
  List<String> selected = [];
  List<String> removed = [];
  List<String> added = [];
  Map<String, GlobalKey> draggableKeys = {};
  Map<String, GlobalKey> targetKeys = {};
  final Map<String, AnimationController> _animationControllers = {};
  final Map<String, Animation<Offset>> _animations = {};
  final Map<String, Tween<Offset>> _tweens = {};
  int removing = 0;
  int adding = 0;
  double rowHeight = 50;
  double xSpace = 14;
  double ySpace = 11;

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

  @override
  void didUpdateWidget(ContainerRowWidget oldWidget) {
    if (widget.selected.isEmpty) {
      selected.clear();
    }

    super.didUpdateWidget(oldWidget);
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

  Offset findTargetPosition(GlobalKey initKey) {
    Offset rightConstraint = _getRightConstraint();
    Offset lastSelectedPosition = _getLastSelectedPosition();

    final RenderBox renderBox =
        initKey.currentContext?.findRenderObject() as RenderBox;

    final Size size = renderBox.size;

    if (rightConstraint.dx >= lastSelectedPosition.dx + xSpace + size.width) {
      double xOffset = selected.isEmpty ? 0 : xSpace;
      double yOffset = selected.isEmpty ? 4 : 0;
      return Offset(lastSelectedPosition.dx + xOffset + size.width / 2,
          lastSelectedPosition.dy + yOffset + size.height / 2);
    }

    return Offset(_getLeftConstraint().dx + size.width / 2,
        lastSelectedPosition.dy + size.height * 1.5 + ySpace);
  }

  Offset _getRightConstraint() {
    final RenderBox containerRenderBox =
        _widgetRowKey.currentContext?.findRenderObject() as RenderBox;
    final Size containerSize = containerRenderBox.size;

    return containerRenderBox
        .localToGlobal(Offset(containerSize.width, containerSize.height));
  }

  Offset _getLeftConstraint() {
    final RenderBox containerRenderBox =
        _widgetRowKey.currentContext?.findRenderObject() as RenderBox;

    return containerRenderBox.localToGlobal(const Offset(0, 0));
  }

  Offset _getLastSelectedPosition() {
    GlobalKey<State<StatefulWidget>>? lastSelectedKey =
        selected.isEmpty ? null : targetKeys[selected.last];

    if (null == lastSelectedKey) {
      return _getLeftConstraint();
    }

    final RenderBox renderBox =
        lastSelectedKey.currentContext?.findRenderObject() as RenderBox;

    final Size size = renderBox.size;
    return renderBox.localToGlobal(Offset(size.width, 0));
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
          key: _widgetRowKey,
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
                  spacing: xSpace,
                  runSpacing: ySpace,
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
      gestures.add(_renderButtonGesture(_moveBack, gesture));
    }

    return gestures;
  }

  Widget _renderButtonGesture(Function onPress, String gesture) {
    String? name = widget.options[gesture]?.name;

    return AnimatedBuilder(
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
                onPress(gesture);
              },
              child: Text(name ?? '',
                  style: Theme.of(context).textTheme.bodySmall),
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
            )));
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

  void _move(String gesture) {
    Offset targetPosition = findTargetPosition(targetKeys[gesture]!);

    Offset initialPosition = _getPosition(targetKeys[gesture]!);

    Offset offset = Offset(targetPosition.dx - initialPosition.dx,
        targetPosition.dy - initialPosition.dy);

    _tweens[gesture]?.end = offset;
    adding++;

    _animationControllers[gesture]?.reset();
    _animationControllers[gesture]?.forward().whenComplete(() {
      adding--;
      added.add(gesture);

      if (adding == 0) {
        for (var element in added) {
          _tweens[element]?.end = const Offset(0, 0);
          selected.add(element);
          widget.onSelect(element);
        }

        added.clear();
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
    List<Widget> emptyContainers = [];

    for (String option in widget.options.keys) {
      containers.add(Container(
          key: draggableKeys[option],
          child: selected.contains(option)
              ? _renderEmptyGesture(option)
              : Draggable<String>(
                  data: option,
                  child: _renderButtonGesture(_move, option),
                  feedback: _renderGesture(option),
                )));

      emptyContainers.add(_renderEmptyGesture(option));
    }

    return Container(
        margin: const EdgeInsets.only(top: 20),
        width: double.infinity,
        child: Stack(children: [
          Wrap(
            spacing: xSpace,
            runSpacing: ySpace,
            children: emptyContainers,
          ),
          Wrap(
            key: _widgetKey,
            spacing: xSpace,
            runSpacing: ySpace,
            children: containers,
          ),
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return _renderBody();
  }
}
