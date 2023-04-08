import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:sigest/api.dart';
import 'package:sigest/bloc/main_cubit.dart';
import 'package:sigest/stock/auth.dart';

part 'auth_state.dart';

class AuthCubit extends MainCubit {
  final Map<String, TextEditingController> bindControllers;

  AuthCubit(this.bindControllers) : super();

  Future<void> login() async {
    emit(DataLoading());

    Response response = await Api().login({
      'login': bindControllers['login'],
      'password': bindControllers['password']
    });

    if (isNeedToActivate(response)) {
      emit(NeedToActivate(bindControllers['login']!.text,
          bindControllers['password']!.text));
    } else if (!checkForError(response)) {
      emit(AuthSuccess());
    }
  }

  Future<void> register() async {
    emit(DataLoading());

    Response response = await Api().register({
      'username': bindControllers['username'],
      'email': bindControllers['email'],
      'password': bindControllers['password']
    });

    if (!checkForError(response)){
      emit(NeedToActivate(bindControllers['username']!.text,
          bindControllers['password']!.text));
    }
  }

  Future<void> forgotPassword() async {
    emit(DataLoading());

    Response response = await Api().forgotPassword({
      'username': bindControllers['username']?.text,
    });

    if (!checkForError(response)) {
      emit(CodeSent(bindControllers['username']!.text));
    }
  }

  Future<void> resendCode(String username) async {
    emit(DataLoading());

    Response response = await Api().forgotPassword({
      'username': username,
    });

    if (!checkForError(response)) {
      emit(CodeResent('Код успешно отправлен'));
    }
  }

  Future<void> resetPassword(String username) async {
    emit(DataLoading());

    Response response = await Api().resetPassword({
      'code': bindControllers['code'],
      'password': bindControllers['password']
    });

    if (!checkForError(response)) {
      response = await Api().login(
          {'login': username, 'password': bindControllers['password']});

      if (!checkForError(response)) {
        await setTokens(response as SuccessResponse);
        emit(AuthSuccess());
      }
    }
  }

  Future<void> activateProfile(String username, String password) async {
    emit(DataLoading());

    Response response = await Api().activateProfile({
      'code': username,
    });

    if (!checkForError(response)) {
      response = await Api().login(
          {'login': username, 'password': password});

      if (!checkForError(response)) {
        await setTokens(response as SuccessResponse);
        emit(AuthSuccess());
      }
    }
  }

  bool isNeedToActivate(Response response) {
    if (response is ErrorResponse) {

      if (response.code < 200) {
        if (ApiErrors.notActivated == Api.codeErrors[response.code]) {
          return true;
        }
      }
    }

    return false;
  }

  Future<void> setTokens(SuccessResponse response) async {
    AuthRepository auth = AuthRepository();

    auth.setAuth(response.data);
  }
}
