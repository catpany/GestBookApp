import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meta/meta.dart';
import 'package:sigest/models/user.dart';
import 'package:sigest/stock/abstract_stock.dart';
import 'package:sigest/stock/units.dart';
import 'package:stock/stock.dart';

import '../../api/api.dart';
import '../../models/unit.dart';
import '../../models/units.dart';
import '../../stock/user.dart';
import '../main_cubit.dart';

part 'splash_state.dart';

class SplashCubit extends MainCubit {
  SplashCubit() : super();

  @override
  List<String> get preloadStores => ['user', 'units'];

  @override
  Future<void> load() async {
    emit(DataLoading());
    store.reloadStatic().onError((error, stackTrace) {
      log(error.toString());
      log(stackTrace.toString());
      checkForError(error);
    }).whenComplete(() {
      // loaded = ;
      // checkIfLoadFinished();
      log('static data loaded');
      emit(DataLoaded());
    });
    // repos.forEach((name, rep) {
    //   log('update ' + rep.name.toString());
    //   rep.stock.fresh(rep.name).onError((error, stacktrace) {
    //     log(error.toString());
    //     log(stacktrace.toString());
    //     checkForError(error);
    //   }).whenComplete(() {
    //     log('complete');
    //     loaded++;
    //     checkIfLoadFinished();
    //   });
    // });
  }
}
