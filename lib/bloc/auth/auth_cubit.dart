import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:sigest/bloc/main_cubit.dart';

import '../../api/params.dart';
import '../../api/response.dart';

part 'auth_state.dart';

class AuthCubit extends MainCubit {
  final Map<String, TextEditingController> bindControllers;

  @override
  List<String> get preloadStores => ['auth'];

  AuthCubit(this.bindControllers) : super(){
    super.init();
  }

  Future<void> login() async {
    emit(DataLoading());

    Response response = await store.auth.login(Params({}, {
      'login': bindControllers['login'],
      'password': bindControllers['password']
    }));

    if (isNeedToActivate(response)) {
      emit(NeedToActivate(
          bindControllers['login']!.text, bindControllers['password']!.text));
    } else if (!checkForError(response)) {
      emit(AuthSuccess());
    }
  }

  Future<void> register() async {
    emit(DataLoading());

    Response response = await store.auth.register(Params({}, {
      'username': bindControllers['username'],
      'email': bindControllers['email'],
      'password': bindControllers['password']
    }));

    if (!checkForError(response)) {
      emit(NeedToActivate(bindControllers['username']!.text,
          bindControllers['password']!.text));
    }
  }

  Future<void> forgotPassword() async {
    emit(DataLoading());

    Response response = await store.auth.forgotPassword(Params({}, {
      'login': bindControllers['login']?.text,
    }));

    if (!checkForError(response)) {
      emit(CodeSent(bindControllers['login']!.text));
    }
  }

  Future<void> resendCode(String username) async {
    emit(DataLoading());

    Response response = await store.auth.forgotPassword(Params({}, {
      'login': username,
    }));

    if (!checkForError(response)) {
      emit(CodeResent('Код успешно отправлен'));
    }
  }

  Future<void> resetPassword(String username) async {
    emit(DataLoading());

    Response response = await store.auth.resetPassword(
        Params({}, {
          'code': bindControllers['code'],
          'password': bindControllers['password']
        }),
        Params(
            {}, {'login': username, 'password': bindControllers['password']}));

    if (!checkForError(response)) {
      emit(AuthSuccess());
    }
  }

  Future<void> activateProfile(String username, String password) async {
    emit(DataLoading());

    Response response = await store.auth.activateProfile(
        Params({}, {
          'code': bindControllers['code'],
        }),
        Params({}, {'login': username, 'password': password}));

    if (!checkForError(response)) {
      emit(AuthSuccess());
    }
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
}
