import 'dart:core';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sigest/bloc/main_cubit.dart';
import 'package:sigest/views/scenes/main/dictionaries.dart';
import 'package:sigest/views/scenes/main/page_navigators.dart';
import 'package:sigest/views/scenes/main/profile.dart';
import 'package:sigest/views/scenes/main/units.dart';
import 'package:sigest/views/styles.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late MainCubit cubit = MainCubit();
  late int currentIndex = 0;
  late final List<GlobalKey<NavigatorState>> navigatorKeys;
  late final List<Widget> pageViews;
  static const List<PageItem> pages = <PageItem>[
    PageItem(index: 0, icon: Icons.school_outlined),
    PageItem(index: 1, icon: Icons.back_hand),
    PageItem(index: 2, icon: Icons.menu_book_outlined),
    PageItem(index: 3, icon: Icons.account_circle),
  ];

  Widget _buildOffstageNavigator(PageItem page) {
    return Offstage(
      offstage: currentIndex != page.index,
      child: pageViews[page.index],
    );
  }

  @override
  void initState() {
    super.initState();
    navigatorKeys = List<GlobalKey<NavigatorState>>.generate(
        pages.length, (int index) => GlobalKey()).toList();

    pageViews = [
      PageNavigator(
        navigatorKey: navigatorKeys[pages[0].index],
        builder: (BuildContext context) {
          return UnitsScreen();
        }),
      PageNavigator(
          navigatorKey: navigatorKeys[pages[1].index],
          builder: (BuildContext context) {
            return UnitsScreen();
          }),
      PageNavigator(
          navigatorKey: navigatorKeys[pages[2].index],
          builder: (BuildContext context) {
            return const DictionariesScreen();
          }),
      PageNavigator(
          navigatorKey: navigatorKeys[pages[3].index],
          builder: (BuildContext context) {
            return const ProfileScreen();
          }),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
            onWillPop: () async {
              final NavigatorState navigator =
              navigatorKeys[currentIndex].currentState!;
              if (!navigator.canPop()) {
                return true;
              }
              navigator.pop();
              return false;
            },
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Stack(
                fit: StackFit.expand,
                children: pages.map((page) => _buildOffstageNavigator(page)).toList(),
              ),
            ),
            bottomNavigationBar: Container(
              height: 72,
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: ColorStyles.gray, width: 3.0))),
            child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
              selectedFontSize: 0,
              unselectedFontSize: 0,
              selectedItemColor: ColorStyles.accent,
              unselectedItemColor: ColorStyles.grayDark,
              currentIndex: currentIndex,
              iconSize: 28,
              onTap: (int index) {
                setState(() {
                  currentIndex = index;
                });
              },
              items: pages.map((page) => BottomNavigationBarItem(icon: Icon(page.icon), label: '',
                  activeIcon: Container(
                    width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: ColorStyles.accentLight,
                        borderRadius: BorderRadius.circular(8),
                      ),
                  child: Icon(page.icon)))).toList()
            ),
          )
        ));
  }
}
