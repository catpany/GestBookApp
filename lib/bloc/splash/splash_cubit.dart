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
  late Map<String, HiveObject> data;

  SplashCubit() : super() {
    init();
  }

  void init() {
    repos = {
      'units': UnitsRepository(),
      'user': UserRepository()
    };
    streams = {};
    data={};
  }

  void load(){
    emit(DataLoading());
    repos.forEach((name, rep) {
      streams[name] = rep.stock
          .stream(rep.name, refresh: true)
          .listen((StockResponse<dynamic> stockResponse) {
        stockResponse.when(
          onLoading: (_) => {},
          onData: (_, data) {
            this.data[rep.name] = data;
            checkIfLoadFinished();
          },
          onError: (_, error, stacktrace) {
            checkForError(error);
          },
        );
      });
    });
  }

  void checkIfLoadFinished() {
    if (repos.length == data.length) {
      emit(SplashLoaded());
    }
  }

  void dispose() {
    for(var stream in streams.values) {
      stream.cancel();
    }
  }
}
