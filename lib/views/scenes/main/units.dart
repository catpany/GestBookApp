import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sigest/bloc/main_cubit.dart';
import 'package:sigest/bloc/units/units_cubit.dart';
import 'package:sigest/models/units.dart';
import 'package:sigest/views/styles.dart';
import 'package:sigest/views/widgets/unit_list.dart';

class UnitsScreen extends StatefulWidget {
  const UnitsScreen({Key? key}) : super(key: key);

  @override
  _UnitsScreenState createState() => _UnitsScreenState();
}

class _UnitsScreenState extends State<UnitsScreen> {
  late UnitsCubit cubit = UnitsCubit();

  @override
  void initState() {
    super.initState();
    cubit.load();
  }

  PreferredSizeWidget _renderTopBar() {
    return PreferredSize(
        preferredSize: const Size(double.infinity, 50),
        child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 13),
            decoration: const BoxDecoration(
                color: ColorStyles.white,
                border: Border(
                    bottom: BorderSide(width: 2, color: ColorStyles.gray))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(children: const [
                  Icon(Icons.star_rounded, color: ColorStyles.yellow, size: 27),
                  Text('40/20'),
                ]),
                Row(children: const [
                  Icon(Icons.local_fire_department,
                      color: ColorStyles.orange, size: 27),
                  Text('14'),
                ]),
              ],
            )));
  }

  Widget _renderBody(BuildContext context, MainState state) {
    if (state is UnitsLoaded && cubit.getUnits() != null) {
      return UnitListWidget(units: cubit.getUnits() as UnitsModel);
    }

    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => cubit,
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.white,
            appBar: _renderTopBar(),
            body:
                BlocConsumer<UnitsCubit, MainState>(listener: (context, state) {
            }, builder: (context, state) {
              return _renderBody(context, state);
            })));
  }
}

