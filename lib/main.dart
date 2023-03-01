import 'package:flutter/material.dart';
import 'package:sigest/models/user.dart';
import 'package:sigest/views/scenes/auth/login.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(UserModelAdapter());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Книга Жестов',
        theme: ThemeData(scaffoldBackgroundColor: Colors.pink),
      home: LoginScreen(),
    );
  }
}