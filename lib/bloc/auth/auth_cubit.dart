import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:sigest/api.dart';
import 'package:sigest/bloc/main_cubit.dart';
import 'package:sigest/stock/auth.dart';

import '../../models/auth.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final Map<String, TextEditingController> bindControllers;

  AuthCubit(this.bindControllers) : super(AuthInitial());

  Future<void> login() async {
    emit(AuthDataLoading());

    Response response = await Api.login({
      'login': bindControllers['login'],
      'password': bindControllers['password']
    });

    if (!isErrorDetected(response)) {
      await setTokens(response);
      emit(AuthSuccess());
    }
  }

  Future<void> register() async {
    emit(AuthDataLoading());

    Response response = await Api.register({
      'username': bindControllers['username'],
      'email': bindControllers['email'],
      'password': bindControllers['password']
    });

    if (!isErrorDetected(response)) {
      emit(AuthSuccess());
    }
  }

  Future<void> forgotPassword() async {
    emit(AuthDataLoading());

    Response response = await Api.forgotPassword({
      'username': bindControllers['username']?.text,
    });

    if (!isErrorDetected(response)) {
      emit(CodeSent(bindControllers['username']!.text));
    }
  }

  Future<void> resendCode(String username) async {
    emit(AuthDataLoading());
    log(username);

    Response response = await Api.forgotPassword({
      'username': username,
    });

    if (!isErrorDetected(response)) {
      emit(CodeResent('Код успешно отправлен'));
    }
  }

  Future<void> resetPassword(String username) async {
    emit(AuthDataLoading());

    Response response = await Api.resetPassword({
      'code': bindControllers['code'],
      'password': bindControllers['password']
    });

    if (!isErrorDetected(response)) {
      response = await Api.login({
        'login': username,
        'password': bindControllers['password']
      });

      await setTokens(response);
      emit(AuthSuccess());
    }
  }

  bool isErrorDetected(Response response) {
    if (response.isError()) {
      ErrorResponse errorResponse = response.getError();

      if (response.statusCode == 200) {
        emit(AuthError(errorResponse));
      } else {
        emit(AuthDataLoadingError(errorResponse.message));
      }

      return true;
    }

    return false;
  }

  Future<void> setTokens(Response response) async {
    AuthStock auth = AuthStock();
    var data = jsonDecode(response.body)['data'];
    Map<String, dynamic> decodedToken = JwtDecoder.decode(data['access_token']);

    auth.setAuth(decodedToken['id'], data);
  }

}
