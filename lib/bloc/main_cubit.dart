import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'package:stock/stock.dart';

import '../api/api.dart';
import '../api/response.dart';
import '../locator.dart';
import '../stock/abstract_stock.dart';
import '../stock/store.dart';

part 'main_state.dart';

class MainCubit extends Cubit<MainState> {
  late Store store;
  List<String> preloadStores = [];

  MainCubit() : super(MainInitial()) {
    init();
  }

  void init() {
    store = Store(preloadStores);
  }

  Future<void> load() async {
    emit(DataLoading());
    store.loadStatic().then((value) {
      log('static data loaded');
      emit(DataLoaded());
    }, onError: (error, StackTrace stackTrace) {
      log('error!');
      log(error.toString());
      checkForError(error.error as ErrorResponse);
    });
  }

  bool checkForError(Response response) {
    log('check for error');
    log(response.toString());
    if (response is ErrorResponse) {
      if (codeErrors.keys.contains(response.code)) {
        log('Error');
        if (ApiErrors.notActivated != codeErrors[response.code]) {
          emit(Error(response));
        }
      } else {
        log('DataLoadingError');
        emit(DataLoadingError(response.message));
      }

      return true;
    }

    return false;
  }
}
