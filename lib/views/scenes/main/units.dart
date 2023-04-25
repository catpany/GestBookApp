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
        preferredSize: const Size(double.infinity, 51),
        child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 33),
            decoration: const BoxDecoration(
                color: ColorStyles.white,
                border: Border(
                    bottom: BorderSide(width: 2, color: ColorStyles.gray))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: const Icon(Icons.star_rounded,
                      color: ColorStyles.yellow, size: 27),
                  margin: const EdgeInsets.only(right: 2),
                ),
                Container(
                  child: Text('40/20', style: TextStyles.text14Regular),
                  margin: const EdgeInsets.only(right: 30),
                ),
                Container(
                  child: const Icon(Icons.local_fire_department,
                      color: ColorStyles.orange, size: 27),
                  margin: const EdgeInsets.only(right: 2),
                ),
                Text('14', style: TextStyles.text14Regular),
              ],
            )));
  }

  Widget _renderBody(BuildContext context, MainState state) {
    if (state is DataLoaded) {
      return UnitListWidget(units: cubit.store.units.units, onStartLesson: cubit.onStartLesson);
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
            body: BlocConsumer<UnitsCubit, MainState>(
                listener: (context, state) {},
                builder: (context, state) {
                  return _renderBody(context, state);
                })));
  }
}
