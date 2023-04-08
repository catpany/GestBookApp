import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meta/meta.dart';
import 'package:sigest/models/user.dart';
import 'package:sigest/stock/abstract_stock.dart';
import 'package:sigest/stock/units.dart';
import 'package:stock/stock.dart';

import '../../api.dart';
import '../../models/unit.dart';
import '../../models/units.dart';
import '../../stock/user.dart';
import '../main_cubit.dart';

part 'splash_state.dart';

class SplashCubit extends MainCubit {
  late Map<String, AbstractStock> repos;
  late Map<String, StreamSubscription<StockResponse<dynamic>>> streams;
  late int loaded = 0;

  SplashCubit() : super() {
    init();
  }

  void init() {
    repos = {
      'units': UnitsRepository(),
      'user': UserRepository()
    };
    streams = {};
  }

  Future<void> load() async {
    emit(DataLoading());
    repos.forEach((name, rep) {
      log('update ' + rep.name.toString());
      rep.stock.fresh(rep.name)
          .onError((error, stacktrace) {
            log(error.toString());
            log(stacktrace.toString());
            checkForError(error);
      })
          .whenComplete(() {
        loaded ++;
              checkIfLoadFinished();
      });
    });
  }

  void checkIfLoadFinished() {
    if (repos.length == loaded) {
      emit(SplashLoaded());
    }
  }

  void dispose() {
    for(var stream in streams.values) {
      stream.cancel();
    }
  }
}
