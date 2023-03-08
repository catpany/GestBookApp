import 'package:bloc/bloc.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';

import '../../api.dart';
import '../main_cubit.dart';

part 'splash_state.dart';

class SplashCubit extends MainCubit {

  SplashCubit() : super() {
    emit(DataLoading());

    getUserInfo();
  }

  Future<void> getUserInfo() async {
    Response response = await Api.user('');

    if (!isErrorDetected(response)) {
      emit(SplashLoaded());
    }
  }


}
