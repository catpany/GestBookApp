import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sigest/views/scenes/auth/auth.dart';
import 'package:sigest/views/scenes/auth/registration.dart';

import '../../../bloc/auth/auth_cubit.dart';
import '../../../bloc/main_cubit.dart';
import '../../styles.dart';
import '../../widgets/button.dart';
import '../../widgets/input.dart';
import '../../widgets/link_button.dart';
import '../splash.dart';
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

  @override
  bool get showAppBar => true;

  Map<String, dynamic> params;

  @override
  void navigateTo(BuildContext context, MainState state) {
    if (state is AuthSuccess) {
      Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 300),
            transitionsBuilder: (BuildContext context,
                Animation<double> animation, __, Widget child) =>
                FadeTransition(
                    opacity: CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeIn,
                    ),
                    child: child),
            pageBuilder: (BuildContext context, _, __) {
              return const SplashScreen();
            }),
        // MaterialPageRoute(builder: (BuildContext context) {
        //   return SplashScreen();
        // }),
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  List<Widget> renderFields([Map<String, dynamic>? errors]) {
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
        obscureText: true,
        controller: bindControllers['password'],
        rules: 'required|min:8|max:22|password',
        errorText: errors != null ? errors['password'] : null,
      ),
    ];
  }

  @override
  List<Widget> renderButtons(BuildContext context) {
    return [
      Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: ButtonWidget(
            onClick: () {
              if (!formKey.currentState!.validate()) {
                return;
              }

              context.read<AuthCubit>().resetPassword();
            },
            text: 'Сбросить пароль',
            color: ColorStyles.accent,
            backgroundColor: ColorStyles.white,
            minWidth: 248,
            height: 41,
          )),
      ButtonWidget(
        onClick: () {
          cubit.resendForgotPasswordCode(params['login']);
        },
        text: 'Отправить код еще раз',
        color: ColorStyles.white,
        backgroundColor: Colors.transparent,
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
                Navigator.pushAndRemoveUntil(
                  context,
                  PageRouteBuilder(
                      transitionDuration: const Duration(milliseconds: 300),
                      transitionsBuilder: (BuildContext context,
                          Animation<double> animation, __, Widget child) =>
                          FadeTransition(
                              opacity: CurvedAnimation(
                                parent: animation,
                                curve: Curves.easeIn,
                              ),
                              child: child),
                      pageBuilder: (BuildContext context, _, __) {
                        return LoginScreen();
                      }),
                  // MaterialPageRoute(builder: (BuildContext context) {
                  //   return LoginScreen();
                  // }),
                  (r) => false,
                )
              },
          color: Colors.white,
          splashColor: Colors.white38,
          height: 35,
          text: 'Войти'),
      LinkButtonWidget(
          onClick: (BuildContext context) => {
                Navigator.pushAndRemoveUntil(
                  context,
                  PageRouteBuilder(
                      transitionDuration: const Duration(milliseconds: 300),
                      transitionsBuilder: (BuildContext context,
                          Animation<double> animation, __, Widget child) =>
                          FadeTransition(
                              opacity: CurvedAnimation(
                                parent: animation,
                                curve: Curves.easeIn,
                              ),
                              child: child),
                      pageBuilder: (BuildContext context, _, __) {
                        return RegistrationScreen();
                      }),
                  // MaterialPageRoute(builder: (BuildContext context) {
                  //   return RegistrationScreen();
                  // }),
                  (r) => false,
                )
              },
          color: Colors.white,
          splashColor: Colors.white38,
          height: 35,
          text: 'Зарегистрироваться'),
    ];
  }
}
