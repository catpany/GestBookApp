import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sigest/views/scenes/auth/login.dart';
import 'package:sigest/views/scenes/auth/registration.dart';

import '../../../bloc/auth/auth_cubit.dart';
import '../../widgets/button.dart';
import '../../widgets/input.dart';
import '../../widgets/link_button.dart';
import '../splash.dart';
import 'auth.dart';

class ActivateProfileScreen extends AuthScreen {
  ActivateProfileScreen({Key? key, this.params = const {}})
      : super(
            key: key,
            bindControllers: {
              'code': TextEditingController(text: '')
            },
  );

  @override
  String get title => 'Активация профиля';

  @override
  bool get showSocials => false;

  @override
  bool get showAppBar => true;

  Map<String, dynamic> params;

  @override
  void navigateTo(BuildContext context, state) {
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
        rules: 'required|max:6',
        errorText: errors != null ? errors['code'] : null,
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

              cubit.activateProfile(params['login']);
            },
            text: 'Активировать',
            color: const Color(0xffff6f91),
            backgroundColor: Colors.white,
            minWidth: 248,
            height: 41,
            borderSideColor: Colors.white,
          )),
      ButtonWidget(
        onClick: () {
          context.read<AuthCubit>().resendActivateProfileCode(params['login']);
        },
        text: 'Отправить код еще раз',
        color: Colors.white,
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
                Navigator.pushReplacement(
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
                )
              },
          color: Colors.white,
          splashColor: Colors.white38,
          height: 35,
          text: 'Зарегистрироваться'),
    ];
  }
}
