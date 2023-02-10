import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sigest/bloc/auth/registration/registration_cubit.dart';
import 'package:sigest/views/scenes/auth/auth.dart';
import 'package:sigest/views/scenes/auth/login.dart';

import '../../widgets/button.dart';
import '../../widgets/input.dart';
import '../../widgets/link_button.dart';

class RegistrationScreen extends AuthScreen {
  RegistrationScreen({Key? key}) : super(key: key);
  @override
  final RegistrationCubit cubit = RegistrationCubit();

  @override
  String get socialsText => 'или \войдите с помощью';
  @override
  String get title => 'Регистрация';

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
          onFieldTap: () => {log('tap field')}
      ),
      TextFormFieldWidget(
          title: 'Почта',
          titleColor: Colors.white,
          hintText: 'Почта',
          controller: passwordController,
          functionValidate: cubit.validate,
          onFieldTap: () => {log('tap field')}
      ),
      TextFormFieldWidget(
          title: 'Пароль',
          titleColor: Colors.white,
          hintText: 'Почта',
          controller: passwordController,
          functionValidate: cubit.validate,
          onFieldTap: () => {log('tap field')}
      ),
      TextFormFieldWidget(
          title: 'Повтор пароля',
          titleColor: Colors.white,
          hintText: 'Повтор пароля',
          controller: passwordController,
          functionValidate: cubit.validate,
          onFieldTap: () => {log('tap field')}
      ),
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
        text: 'Зарегистрироваться',
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
          onClick: (BuildContext context) => {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context){
          return LoginScreen();
          }), (r){
          return false;
          })},
          color: Colors.white,
          splashColor: Colors.white38,
          height: 35,
          text: 'Войти'
      )
    ];
  }
}