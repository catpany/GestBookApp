import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';

import '../api/api.dart';
import '../api/response.dart';
import '../locator.dart';
import '../stock/abstract_stock.dart';
import '../stock/store.dart';

part 'main_state.dart';

class MainCubit extends Cubit<MainState> {
  late Store store;
  List<String> preloadStores = [];
  // late Map<String, HiveObject> data;
  // late int loaded = 0;

  MainCubit() : super(MainInitial()) {
    init();
  }

  void init() {
    store = Store(preloadStores);
  }

  Future<void> load() async {
    emit(DataLoading());
    store.loadStatic().onError((error, stackTrace) {
        log(error.toString());
        log(stackTrace.toString());
        checkForError(error);
    }).whenComplete(() {
      // loaded = ;
      // checkIfLoadFinished();
      log('static data loaded');
      emit(DataLoaded());
    });
    // preloadStores.forEach((name, rep) async {
    //   log('get ' + rep.name.toString());
    //   data[name] = await rep.stock.get(rep.name).onError((error, stacktrace) {
    //     log(error.toString());
    //     log(stacktrace.toString());
    //     checkForError(error);
    //   }).whenComplete(() {
    //     loaded++;
    //     checkIfLoadFinished();
    //   });
    // });
  }

  // void checkIfLoadFinished() {
  //   if (preloadStores.length == loaded) {
  //     emit(DataLoaded());
  //   }
  // }

  bool checkForError(response) {
    if (response is ErrorResponse) {
      if (response.code < 200) {
        if (ApiErrors.notActivated != codeErrors[response.code]) {
          emit(Error(response));
        }
      } else {
        emit(DataLoadingError(response.message));
      }

      return true;
    }

    return false;
  }
}
