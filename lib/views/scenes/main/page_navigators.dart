import 'package:flutter/material.dart';

class PageItem {
  final int index;
  final IconData icon;

  const PageItem({required this.index, required this.icon});
}

class PageNavigator extends StatefulWidget {
  const PageNavigator({Key? key,
    required this.navigatorKey, required this.builder,
  }) : super(key: key);

  final Key navigatorKey;
  final Function(BuildContext context) builder;

  @override
  State<PageNavigator> createState() => _PageNavigatorState();
}

class _PageNavigatorState extends State<PageNavigator> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: widget.navigatorKey,
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (BuildContext context) => widget.builder(context),
        );
      },
    );
  }
}