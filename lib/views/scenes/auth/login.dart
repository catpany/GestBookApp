import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sigest/bloc/auth/login/login_cubit.dart';
import 'package:sigest/views/scenes/auth/auth.dart';
import 'package:sigest/views/scenes/auth/registration.dart';
import 'package:sigest/views/widgets/button.dart';
import 'package:sigest/views/widgets/link_button.dart';

import '../../widgets/input.dart';

class LoginScreen extends AuthScreen {
  LoginScreen({Key? key}) : super(key: key);
  @override
  final LoginCubit cubit = LoginCubit();

  @override
  String get socialsText => 'или \nвойдите с помощью';

  @override
  String get title => 'Вход';

  @override
  List<TextFormFieldWidget> renderFields() {
    TextEditingController usernameController = TextEditingController(text: '');
    TextEditingController passwordController = TextEditingController(text: '');

    return [
      TextFormFieldWidget(
          title: 'Имя пользователя',
          titleColor: Colors.white,
          hintText: 'Имя пользователя',
          controller: usernameController,
          functionValidate: cubit.validate,
          onFieldTap: () => {log('tap field')}),
      TextFormFieldWidget(
          title: 'Пароль',
          titleColor: Colors.white,
          hintText: 'Пароль',
          controller: passwordController,
          functionValidate: cubit.validate,
          obscureText: true,
          onFieldTap: () => {log('tap field')}),
    ];
  }

  @override
  List<ButtonWidget> renderButtons() {
    return [
      ButtonWidget(
        onClick: () {
          log('click on button');

          if (!formKey.currentState!.validate()) {
            return;
          }
          log('success!!');
        },
        text: 'Войти',
        color: Color(0xffff6f91),
        backgroundColor: Colors.white,
        splashColor: Colors.white12,
        borderRadius: 0,
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
          onClick: () => {log('tap on link 1')},
          color: Colors.white,
          splashColor: Colors.white38,
          height: 35,
          text: 'Забыли пароль?'
      ),
      LinkButtonWidget(
          onClick: (BuildContext context) => {
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context){
              return RegistrationScreen();
            }), (r){
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
