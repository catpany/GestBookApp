import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/editable_text.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sigest/views/scenes/auth/auth.dart';
import 'package:sigest/views/scenes/auth/registration.dart';

import '../../../bloc/auth/auth_cubit.dart';
import '../../styles.dart';
import '../../widgets/button.dart';
import '../../widgets/input.dart';
import '../../widgets/link_button.dart';
import 'login.dart';

class ResetPasswordScreen extends AuthScreen {
  ResetPasswordScreen({Key? key, this.params = const {}})
      : super(key: key, bindControllers: {
          'code': TextEditingController(),
          'password': TextEditingController(),
        });

  @override
  String get title => 'Сброс пароля';

  @override
  bool get showSocials => false;

  Map<String, dynamic> params;

  @override
  List<TextFormFieldWidget> renderFields([Map<String, dynamic>? errors]) {
    return [
      TextFormFieldWidget(
        title: 'Код',
        titleColor: Colors.white,
        hintText: 'Код',
        controller: bindControllers['code'],
        rules: 'required|maxLen:6',
        errorText: errors != null ? errors['code'] : null,
      ),
      TextFormFieldWidget(
        title: 'Новый пароль',
        titleColor: Colors.white,
        hintText: 'Новый пароль',
        type: FieldType.password,
        controller: bindControllers['password'],
        rules: 'required|min:8|max:22|password',
        errorText: errors != null ? errors['password'] : null,
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
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: ButtonWidget(
                onClick: () {
                  if (!formKey.currentState!.validate()) {
                    return;
                  }

                  context.read<AuthCubit>().resetPassword(params['username']);
                  log('success!!');
                },
                text: 'Сбросить пароль',
                color: ColorStyles.accent,
                backgroundColor: ColorStyles.white,
                splashColor: Colors.white12,
                minWidth: 248,
                height: 41,
              )
            );
          }
        },
      ),
      BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
        if (state is AuthDataLoading) {
          return const SizedBox.shrink();
        } else {
          return ButtonWidget(
            onClick: () {
              context.read<AuthCubit>().resendCode(params['username']);
            },
            text: 'Отправить код еще раз',
            color: Colors.white,
            backgroundColor: Colors.transparent,
            splashColor: Colors.white12,
            minWidth: 248,
            height: 41,
            borderSideColor: Colors.white,
          );
        }
      }),
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