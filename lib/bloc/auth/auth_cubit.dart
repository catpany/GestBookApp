import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:sigest/bloc/main_cubit.dart';

import '../../api/params.dart';
import '../../api/response.dart';
import '../../models/auth.dart';

part 'auth_state.dart';

class AuthCubit extends MainCubit {
  final Map<String, TextEditingController> bindControllers;

  @override
  List<String> get preloadStores => ['auth'];

  AuthCubit(this.bindControllers) : super(){
    log('auth cubit');
    super.init();
  }

  Future<void> login() async {
    emit(DataLoading());
    log(bindControllers['login']!.text);
    log(bindControllers['password']!.text);

    Response response = await store.auth.login(Params({}, {
      'login': bindControllers['login']!.text,
      'password': bindControllers['password']!.text
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
      'username': bindControllers['username']!.text,
      'email': bindControllers['email']!.text,
      'password': bindControllers['password']!.text
    }));

    log(response.toString());

    if (!checkForError(response)) {
      emit(NeedToActivate(bindControllers['email']!.text,
          bindControllers['password']!.text));
    }
  }

  Future<void> forgotPassword() async {
    emit(DataLoading());

    Response response = await store.auth.sendCode(Params({}, {
      'login': bindControllers['login']?.text,
      'type': 'reset'
    }));

    if (!checkForError(response)) {
      emit(CodeSent(bindControllers['login']!.text));
    }
  }

  Future<void> resendForgotPasswordCode(String login) async {
    emit(DataLoading());

    Response response = await store.auth.sendCode(Params({}, {
      'login': login,
      'type': 'reset'
    }));

    if (!checkForError(response)) {
      emit(CodeResent('Код успешно отправлен'));
    }
  }

  Future<void> resetPassword() async {
    emit(DataLoading());

    Response response = await store.auth.resetPassword(
        Params({}, {
          'code': bindControllers['code']!.text,
          'password': bindControllers['password']!.text
        }),);

    if (!checkForError(response)) {
      emit(AuthSuccess());
    }
  }

  Future<void> activateProfile(String login) async {
    emit(DataLoading());

    Response response = await store.auth.activateProfile(
        Params({}, {
          'code': bindControllers['code']!.text,
          'login': login,
        }));

    if (!checkForError(response)) {
      log('auth success 0');
      emit(AuthSuccess());
    }
  }

  Future<void> resendActivateProfileCode(String login) async {
    emit(DataLoading());

    Response response = await store.auth.sendCode(Params({}, {
      'login': login,
      'type': 'verification'
    }));

    if (!checkForError(response)) {
      emit(CodeResent('Код успешно отправлен'));
    }
  }

  Future<void> authViaGoogle() async {
    emit(AuthLinkLoading());

    Response response = await store.auth.authViaGoogle();

    if (!checkForError(response)) {
      emit(LinkReceived((response as SuccessResponse).data['link']));
    }
  }

  Future<void> authViaVK() async {
    emit(AuthLinkLoading());

    Response response = await store.auth.authViaVK();

    if (!checkForError(response)) {
      emit(LinkReceived((response as SuccessResponse).data['link']));
    }
  }

  void setAuth(dynamic jsonTokens) {
    store.auth.tokens = AuthModel.fromJson(jsonTokens);
    emit(AuthSuccess());
  }
}
