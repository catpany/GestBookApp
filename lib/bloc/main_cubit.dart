import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../api/response.dart';
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
    store.load().then((value) {
      emit(DataLoaded());
    }, onError: (error, StackTrace stackTrace) {
      checkForError(error.error as ErrorResponse);
    });
  }

  bool checkForError(Response response) {
    if (response is ErrorResponse) {
      if (codeErrors.keys.contains(response.code)) {
        if (ApiErrors.notActivated != codeErrors[response.code]) {
          emit(Error(response));
        }
      } else {
        emit(DataLoadingError(response));
      }

      return true;
    }

    return false;
  }

  bool isNeedToActivate(Response response) {
    if (response is ErrorResponse) {
      if (response.code < 200) {
        if (ApiErrors.notActivated == codeErrors[response.code]) {
          return true;
        }
      }
    }

    return false;
  }

  void showNotification() {
    emit(NotificationShow());
  }

  void hideNotification() {
    emit(NotificationShowed());
  }
}
