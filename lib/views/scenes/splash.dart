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
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [ColorStyles.orange, ColorStyles.accent])),
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.transparent,
              body: BlocListener<SplashCubit, MainState>(
                listener: (context, state) {
                  if (state is DataLoaded || state is DataLoadingError) {
                    Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                            transitionDuration:
                                const Duration(milliseconds: 1500),
                            transitionsBuilder: (BuildContext context,
                                    Animation<double> animation,
                                    __,
                                    Widget child) =>
                                FadeTransition(
                                    opacity: CurvedAnimation(
                                      parent: animation,
                                      curve: Curves.easeIn,
                                    ),
                                    child: child),
                            pageBuilder: (BuildContext context, _, __) {
                              return MainScreen(params: {'offline': state is DataLoadingError});
                            }));
                  } else if (state is Error) {
                    Navigator.of(context).pushReplacement(PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 1500),
                        transitionsBuilder: (BuildContext context,
                                Animation<double> animation,
                                __,
                                Widget child) =>
                            FadeTransition(
                                opacity: CurvedAnimation(
                                  parent: animation,
                                  curve: Curves.easeIn,
                                ),
                                child: child),
                        pageBuilder: (BuildContext context, _, __) {
                          return LoginScreen();
                        }));
                  }
                },
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Center(
                      child: Image.asset('assets/images/launch_image.png',
                          width: 150, height: 150),
                    )),
              ),
            )));
  }
}
