import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sigest/views/scenes/auth/auth.dart';
import 'package:sigest/views/scenes/auth/registration.dart';
import 'package:sigest/views/widgets/button.dart';
import 'package:sigest/views/widgets/link_button.dart';

import '../../../bloc/auth/auth_cubit.dart';
import '../../../bloc/main_cubit.dart';
import '../../widgets/input.dart';
import '../splash.dart';
import 'activate-profile.dart';
import 'forgot-password.dart';

class LoginScreen extends AuthScreen {
  LoginScreen({Key? key})
      : super(key: key, bindControllers: {
          'login': TextEditingController(text: ''),
          'password': TextEditingController(text: '')
        });

  @override
  String get socialsText => 'или \nвойдите с помощью';

  @override
  String get title => 'Вход';

  @override
  void navigateTo(BuildContext context, MainState state) {
    if (state is AuthSuccess) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) {
          return const SplashScreen();
        }),
        (Route<dynamic> route) => false,
      );
    } else if (state is NeedToActivate) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return ActivateProfileScreen(
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
      TextFormFieldWidget(
        title: 'Пароль',
        titleColor: Colors.white,
        hintText: 'Пароль',
        type: FieldType.password,
        rules: 'required',
        controller: bindControllers['password'],
        obscureText: true,
        errorText: errors != null ? errors['password'] : null,
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
          cubit.login();
        },
        text: 'Войти',
        color: const Color(0xffff6f91),
        backgroundColor: Colors.white,
        minWidth: 248,
        height: 41,
      )
    ];
  }

  @override
  List<LinkButtonWidget> renderLinks() {
    return [
      LinkButtonWidget(
          onClick: (BuildContext context) => {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return ForgotPasswordScreen();
                }))
              },
          color: Colors.white,
          splashColor: Colors.white38,
          height: 35,
          text: 'Забыли пароль?'),
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
          text: 'Зарегистрироваться')
    ];
  }
}
