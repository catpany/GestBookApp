import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sigest/views/scenes/auth/login.dart';

import 'bloc/auth/login/login_cubit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sigest',
        theme: ThemeData(scaffoldBackgroundColor: Colors.pink),
      home: BlocProvider(
        create: (context) => LoginCubit(),
        child: LoginScreen(),
      )
    );
  }
}