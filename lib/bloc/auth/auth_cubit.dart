import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:sigest/api.dart';
import 'package:sigest/bloc/main_cubit.dart';

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

    if (response.isError()) {
      ErrorResponse errorResponse = response.getError();

      if (response.statusCode == 200) {
        emit(AuthError(errorResponse));
      } else {
        emit(AuthDataLoadingError(errorResponse.message));
      }
    }

    emit(AuthSuccess());
  }

  Future<void> register() async {
    emit(AuthDataLoading());

    Response response = await Api.register({
      'username': bindControllers['username'],
      'email': bindControllers['email'],
      'password': bindControllers['password']
    });

    if (response.isError()) {
      ErrorResponse errorResponse = response.getError();
      if (response.statusCode == 200) {
        emit(AuthError(errorResponse));
        return;
      } else {
        emit(AuthDataLoadingError(errorResponse.message));
        return;
      }
    }

    emit(AuthSuccess());
  }
}
