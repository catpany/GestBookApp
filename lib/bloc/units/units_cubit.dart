import 'dart:developer';

import 'package:async/async.dart';
import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'package:sigest/models/units.dart';
import 'package:sigest/stock/units.dart';

import '../../stock/abstract_stock.dart';
import '../main_cubit.dart';

part 'units_state.dart';

class UnitsCubit extends MainCubit {
  UnitsCubit() : super();

  @override
  List<String> get preloadStores => ['units'];
}
