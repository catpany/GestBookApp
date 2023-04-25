import 'dart:async';
import 'dart:developer';

import 'package:meta/meta.dart';
import 'package:sigest/api/response.dart';

import 'package:stock/stock.dart';

import '../main_cubit.dart';

part 'splash_state.dart';

class SplashCubit extends MainCubit {
  SplashCubit() : super();

  @override
  List<String> get preloadStores => ['user'];

  @override
  Future<void> load() async {
    log('splash data load');
    emit(DataLoading());
    store
        .reloadStatic()
        //     .onError((StockResponseError error, stackTrace) {
        //   log('error!!!');
        //   log(error.toString());
        //   log(stackTrace.toString());
        //   checkForError(error.error as ErrorResponse);
        // })
        .then((value) {
        log('static data loaded');
        emit(DataLoaded());
    }, onError: (error, StackTrace stackTrace) {
      log('error!!!');
      log(error.toString());
      log(stackTrace.toString());
      checkForError(error.error as ErrorResponse);
    });
  }
}
