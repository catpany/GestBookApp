import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../api.dart';

part 'main_state.dart';

class MainCubit extends Cubit<MainState> {
  MainCubit() : super(MainInitial());

  bool checkForError(response) {
    if (response is ErrorResponse) {
      if (response.code < 200) {
        if (ApiErrors.notActivated != Api.codeErrors[response.code]) {
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
