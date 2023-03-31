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
  late Map<String, AbstractStock> repos;
  late Map<String, HiveObject> data;
  UnitsCubit() : super() {
    init();
  }

  void init() {
    repos = {
      'units': UnitsRepository(),
    };
    data = {};
  }

  void load() async {
    emit(DataLoading());
    data['units'] = await repos['units']?.stock.get(repos['units']?.name ?? '');
    emit(UnitsLoaded());
  }

  HiveObject? getUnits() {
    return data['units'];
  }
}
