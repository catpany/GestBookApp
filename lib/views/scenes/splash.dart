import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sigest/bloc/splash/splash_cubit.dart';

import '../../bloc/main_cubit.dart';
import '../styles.dart';
import '../widgets/button.dart';
import 'auth/login.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return BlocProvider<SplashCubit>(
        create: (_) => SplashCubit(),
        child: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [ColorStyles.orange, ColorStyles.accent])),
            child: Scaffold(
                resizeToAvoidBottomInset: false,
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
                body: Theme(
                    data: Theme.of(context).copyWith(
                      primaryColor: ColorStyles.white,
                    ),
                    child: BlocListener<SplashCubit, MainState>(
                      listener: (context, state) {
                        if (state is SplashLoaded) {
                          log('loaded');
                        } else {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (BuildContext context) {
                              return LoginScreen();
                            }),
                          );
                        }
                      },
                      child: const Center(
                        child: Text('Книга Жестов', style: TextStyles.title60Bold),
                      ),
                    ),
                ))));
  }
}
