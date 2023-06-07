import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sigest/bloc/splash/splash_cubit.dart';
import 'package:sigest/views/scenes/main/main.dart';

import '../../bloc/main_cubit.dart';
import '../styles.dart';
import 'auth/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late SplashCubit cubit = SplashCubit();

  @override
  void initState() {
    super.initState();
    cubit.load();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SplashCubit>(
        create: (_) => cubit,
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
              body: BlocListener<SplashCubit, MainState>(
                listener: (context, state) {
                  if (state is DataLoaded) {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) {
                      return const MainScreen();
                    }));
                  } else if (state is Error) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (BuildContext context) {
                        return LoginScreen();
                      }),
                    );
                  }
                },
                child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Center(
                      child:
                      Text('Книга Жестов', style: TextStyles.title60Bold),
                    )),
              ),
            )));
  }
}
