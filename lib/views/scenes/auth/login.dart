import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sigest/bloc/auth/login/login_cubit.dart';
import 'package:sigest/views/scenes/auth/auth.dart';
import 'package:sigest/views/scenes/auth/registration.dart';
import 'package:sigest/views/styles.dart';
import 'package:sigest/views/widgets/button.dart';
import 'package:sigest/views/widgets/link_button.dart';

import '../../../bloc/auth/auth_cubit.dart';
import '../../widgets/input.dart';

class LoginScreen extends AuthScreen {
  // final Map<String, TextEditingController> bindControllers = {
  //   'login': TextEditingController(text: ''),
  //   'password': TextEditingController(text: '')
  // };

  LoginScreen({Key? key}) : super(
      key: key,
      bindControllers: {
    'login': TextEditingController(text: ''),
    'password': TextEditingController(text: '')
  });

  @override
  String get socialsText => 'или \nвойдите с помощью';

  @override
  String get title => 'Вход';

  @override
  List<TextFormFieldWidget> renderFields([Map<String, dynamic>? errors]) {
    return [
      TextFormFieldWidget(
        title: 'Логин',
        titleColor: Colors.white,
        hintText: 'Логин',
        controller: bindControllers['login'],
        rules: 'required',
        errorText: errors != null? errors['login'] : null,
      ),
      TextFormFieldWidget(
        title: 'Пароль',
        titleColor: Colors.white,
        hintText: 'Пароль',
        type: FieldType.password,
        rules: 'required',
        controller: bindControllers['password'],
        obscureText: true,
        errorText: errors != null? errors['password'] : null,
        onFieldTap: () {log('tap!');},
      ),
    ];
  }

  @override
  List<Widget> renderButtons() {
    return [
      BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state is AuthDataLoading) {
              return const CircularProgressIndicator(color: ColorStyles.white);
            } else {
              return ButtonWidget(
                  onClick: () {
                    if (!formKey.currentState!.validate()) {
                      return;
                    }
                    context.read<AuthCubit>().login();
                    log('success!!');
                  },
                  text: 'Войти',
                  color: const Color(0xffff6f91),
                  backgroundColor: Colors.white,
                  splashColor: Colors.white12,
                  borderRadius: 0,
                  minWidth: 248,
                  height: 41,
                  borderSideColor: Colors.white,
              );
            }
          }
      ),
    ];
  }

  @override
  List<LinkButtonWidget> renderLinks() {
    return [
      LinkButtonWidget(
          onClick: () => {log('tap on link 1')},
          color: Colors.white,
          splashColor: Colors.white38,
          height: 35,
          text: 'Забыли пароль?'
      ),
      LinkButtonWidget(
          onClick: (BuildContext context) =>
          {
            Navigator.pushAndRemoveUntil(
                context, MaterialPageRoute(builder: (BuildContext context) {
              return RegistrationScreen();
            }), (r) {
              return false;
            })},
          color: Colors.white,
          splashColor: Colors.white38,
          height: 35,
          text: 'Зарегистрироваться'
      )
    ];
  }
}
