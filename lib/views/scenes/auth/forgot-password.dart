import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sigest/views/scenes/auth/login.dart';
import 'package:sigest/views/scenes/auth/registration.dart';
import 'package:sigest/views/scenes/auth/reset-password.dart';

import '../../../bloc/auth/auth_cubit.dart';
import '../../../bloc/main_cubit.dart';
import '../../widgets/button.dart';
import '../../widgets/input.dart';
import '../../widgets/link_button.dart';
import 'auth.dart';

class ForgotPasswordScreen extends AuthScreen {
  ForgotPasswordScreen({Key? key})
      : super(
            key: key,
            bindControllers: {'login': TextEditingController(text: '')});

  @override
  String get title => 'Восстановление пароля';

  @override
  bool get showSocials => false;

  @override
  void navigateTo(BuildContext context, MainState state) {
    if (state is CodeSent) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return ResetPasswordScreen(
          params: {'login': state.login},
        );
      }));
    }
  }

  @override
  List<Widget> renderFields([Map<String, dynamic>? errors]) {
    return [
      TextFormFieldWidget(
        title: 'Логин',
        titleColor: Colors.white,
        hintText: 'Логин',
        controller: bindControllers['login'],
        rules: 'required',
        errorText: errors != null ? errors['login'] : null,
      ),
    ];
  }

  @override
  List<Widget> renderButtons(BuildContext context) {
    return [
      ButtonWidget(
        onClick: () {
          if (!formKey.currentState!.validate()) {
            return;
          }

          context.read<AuthCubit>().forgotPassword();
        },
        text: 'Получить код',
        color: const Color(0xffff6f91),
        backgroundColor: Colors.white,
        minWidth: 248,
        height: 41,
        borderSideColor: Colors.white,
      )
    ];
  }

  @override
  List<LinkButtonWidget> renderLinks() {
    return [
      LinkButtonWidget(
          onClick: (BuildContext context) => {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) {
                    return LoginScreen();
                  }),
                )
              },
          color: Colors.white,
          splashColor: Colors.white38,
          height: 35,
          text: 'Войти'),
      LinkButtonWidget(
          onClick: (BuildContext context) => {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) {
                    return RegistrationScreen();
                  }),
                )
              },
          color: Colors.white,
          splashColor: Colors.white38,
          height: 35,
          text: 'Зарегистрироваться'),
    ];
  }
}
