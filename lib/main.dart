import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sigest/models/user.dart';
import 'package:sigest/views/scenes/auth/login.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:sigest/views/styles.dart';

import 'models/auth.dart';
import 'models/lesson.dart';
import 'models/unit.dart';
import 'models/units.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(AuthModelAdapter());
  Hive.registerAdapter(LessonModelAdapter());
  Hive.registerAdapter(UnitModelAdapter());
  Hive.registerAdapter(UnitsModelAdapter());

  WidgetsFlutterBinding.ensureInitialized();
  cacheAssets();

  runApp(const MyApp());
}

Future<List<void>> cacheAssets() {
  List<String> assets = [
    'assets/images/triangle.svg',
    'assets/images/unit.svg'
  ];

  return Future.wait(
    assets.map((asset) => precachePicture(
        ExactAssetPicture(
          SvgPicture.svgStringDecoderBuilder,
          asset,
        ),
        null,
      )).toList()
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Книга Жестов',
        theme: ThemeData(scaffoldBackgroundColor: Colors.pink, colorScheme: const ColorScheme.light(secondary: ColorStyles.gray, primary: ColorStyles.black),),
      home: LoginScreen(),
    );
  }
}