import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';

import '../api.dart';

part 'main_state.dart';

class MainCubit extends Cubit<MainState> {
  MainCubit() : super(MainInitial());

  bool isErrorDetected(Response response) {
    if (response.isError()) {
      ErrorResponse errorResponse = response.getError();

      if (response.statusCode == 200) {
        if (ApiErrors.notActivated != Api.codeErrors[errorResponse.code]) {
          emit(Error(errorResponse));
        }
      } else {
        emit(DataLoadingError(errorResponse.message));
      }

      return true;
    }

    return false;
  }
}
