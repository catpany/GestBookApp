import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sigest/views/scenes/auth/activate-profile.dart';
import 'package:sigest/views/scenes/auth/auth.dart';
import 'package:sigest/views/scenes/auth/login.dart';

import '../../../bloc/auth/auth_cubit.dart';
import '../../../bloc/main_cubit.dart';
import '../../widgets/button.dart';
import '../../widgets/input.dart';
import '../../widgets/link_button.dart';

class RegistrationScreen extends AuthScreen {
  RegistrationScreen({Key? key})
      : super(key: key, bindControllers: {
          'username': TextEditingController(text: ''),
          'email': TextEditingController(text: ''),
          'password': TextEditingController(text: '')
        });

  @override
  String get socialsText => 'или \nвойдите с помощью';

  @override
  String get title => 'Регистрация';

  @override
  void navigateTo(BuildContext context, MainState state) {
    if (state is NeedToActivate) {
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
        title: 'Имя пользователя',
        titleColor: Colors.white,
        hintText: 'Имя пользователя',
        controller: bindControllers['username'],
        rules: 'required|username|min:1|max:256',
        errorText: errors != null ? errors['username'] : null,
      ),
      TextFormFieldWidget(
        title: 'Почта',
        titleColor: Colors.white,
        hintText: 'Почта',
        controller: bindControllers['email'],
        rules: 'required|email|max:256',
        errorText: errors != null ? errors['email'] : null,
      ),
      TextFormFieldWidget(
        title: 'Пароль',
        titleColor: Colors.white,
        hintText: 'Пароль',
        obscureText: true,
        type: FieldType.password,
        controller: bindControllers['password'],
        rules: 'required|min:8|max:22|password',
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
          cubit.register();
        },
        text: 'Зарегистрироваться',
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
          text: 'Войти')
    ];
  }
}
