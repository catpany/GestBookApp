import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sigest/views/scenes/auth/activate-profile.dart';
import 'package:sigest/views/scenes/auth/auth.dart';
import 'package:sigest/views/scenes/auth/login.dart';

import '../../../bloc/auth/auth_cubit.dart';
import '../../styles.dart';
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
  List<TextFormFieldWidget> renderFields([Map<String, dynamic>? errors]) {
    return [
      TextFormFieldWidget(
        title: 'Имя пользователя',
        titleColor: Colors.white,
        hintText: 'Имя пользователя',
        controller: bindControllers['username'],
        rules: 'required|username|min:1|max:256',
      ),
      TextFormFieldWidget(
        title: 'Почта',
        titleColor: Colors.white,
        hintText: 'Почта',
        controller: bindControllers['email'],
        rules: 'required|email|max:256',
      ),
      TextFormFieldWidget(
        title: 'Пароль',
        titleColor: Colors.white,
        hintText: 'Пароль',
        obscureText: true,
        type: FieldType.password,
        controller: bindControllers['password'],
        rules: 'required|min:8|max:22|password',
      ),
    ];
  }

  @override
  List<Widget> renderButtons() {
    return [
      BlocConsumer<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state is AuthDataLoading) {
            return const CircularProgressIndicator(color: ColorStyles.white);
          } else {
            return ButtonWidget(
              onClick: () {
                if (!formKey.currentState!.validate()) {
                  return;
                }
                context.read<AuthCubit>().register();
                log('success!!');
              },
              text: 'Зарегистрироваться',
              color: const Color(0xffff6f91),
              backgroundColor: Colors.white,
              splashColor: Colors.white12,
              minWidth: 248,
              height: 41,
            );
          }
        },
        listener: (context, state) {
          if (state is NeedToActivate) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return ActivateProfileScreen(
                params: {
                  'username': state.username,
                  'password': state.password
                },
              );
            }));
          }
        },
      ),
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
