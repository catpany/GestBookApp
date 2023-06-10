import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sigest/locator.dart';
import 'package:sigest/models/settings.dart';
import 'package:sigest/models/user.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:sigest/views/scenes/splash.dart';
import 'package:sigest/views/styles.dart';

import 'models/auth.dart';
import 'models/exercise.dart';
import 'models/favorites.dart';
import 'models/gesture-info.dart';
import 'models/gesture.dart';
import 'models/lesson-info.dart';
import 'models/lesson.dart';
import 'models/level.dart';
import 'models/saved.dart';
import 'models/unit.dart';
import 'models/units.dart';

late Map<String, dynamic> config;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await loadConfig();
  await Hive.initFlutter();
  await initLocator(config["env"]);

  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(AuthModelAdapter());
  Hive.registerAdapter(LessonModelAdapter());
  Hive.registerAdapter(UnitModelAdapter());
  Hive.registerAdapter(UnitsModelAdapter());
  Hive.registerAdapter(SettingsModelAdapter());
  Hive.registerAdapter(GestureInfoModelAdapter());
  Hive.registerAdapter(GestureModelAdapter());
  Hive.registerAdapter(FavoritesModelAdapter());
  Hive.registerAdapter(SavedModelAdapter());
  Hive.registerAdapter(ExerciseModelAdapter());
  Hive.registerAdapter(LevelModelAdapter());
  Hive.registerAdapter(LessonInfoModelAdapter());
  await cacheAssets();
  await Hive.openBox<SettingsModel>('settings');

  runApp(const MyApp());
}

Future<void> loadConfig() async {
  final contents = await rootBundle.loadString(
    'assets/config/app_settings.json',
  );

  config = jsonDecode(contents);
}

Future<List<void>> cacheAssets() async {
  List<String> assets = [
    'assets/images/triangle.svg',
    'assets/images/unit.svg',
    'assets/images/vocabulary/А.svg',
    'assets/images/vocabulary/Б.svg',
    'assets/images/vocabulary/В.svg',
    'assets/images/vocabulary/Г.svg',
    'assets/images/vocabulary/Д.svg',
    'assets/images/vocabulary/Е.svg',
    'assets/images/vocabulary/Ё.svg',
    'assets/images/vocabulary/Ж.svg',
    'assets/images/vocabulary/З.svg',
    'assets/images/vocabulary/И.svg',
    'assets/images/vocabulary/Й.svg',
    'assets/images/vocabulary/К.svg',
    'assets/images/vocabulary/Л.svg',
    'assets/images/vocabulary/М.svg',
    'assets/images/vocabulary/Н.svg',
    'assets/images/vocabulary/О.svg',
    'assets/images/vocabulary/П.svg',
    'assets/images/vocabulary/Р.svg',
    'assets/images/vocabulary/С.svg',
    'assets/images/vocabulary/Т.svg',
    'assets/images/vocabulary/У.svg',
    'assets/images/vocabulary/Ф.svg',
    'assets/images/vocabulary/Х.svg',
    'assets/images/vocabulary/Ц.svg',
    'assets/images/vocabulary/Ч.svg',
    'assets/images/vocabulary/Ш.svg',
    'assets/images/vocabulary/Щ.svg',
    'assets/images/vocabulary/Ь.svg',
    'assets/images/vocabulary/Ъ.svg',
    'assets/images/vocabulary/Э.svg',
    'assets/images/vocabulary/Ю.svg',
    'assets/images/vocabulary/Я.svg',
  ];

  return Future.wait(assets
      .map((asset) => precachePicture(
            ExactAssetPicture(
              SvgPicture.svgStringDecoderBuilder,
              asset,
            ),
            null,
          ))
      .toList());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable:
          Hive.box<SettingsModel>('settings').listenable(keys: ['current']),
      builder: (context, box, widget) {
        SettingsModel? settings =
            Hive.box<SettingsModel>('settings').get('current');
        bool darkMode = settings == null ? false : settings.isDarkMode;
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
            title: 'Книга Жестов',
            theme: ThemeData(
              colorScheme: const ColorScheme.light(
                  secondary: ColorStyles.gray, primary: ColorStyles.black),
              fontFamily: 'Jost',
              textTheme: const TextTheme(
                bodyLarge: TextStyles.text14SemiBoldLight,
                bodyMedium: TextStyles.text16MediumLight,
                bodySmall: TextStyles.text16RegularLight,
                headlineMedium: TextStyles.text16MediumLight,
                headlineLarge: TextStyles.text16SemiBoldLight,
                displaySmall: TextStyles.text12Regular,
                titleSmall: TextStyles.title18Medium,
                titleMedium: TextStyles.title20SemiBold,
                titleLarge: TextStyles.title21Regular,
              ),
            ),
            darkTheme: ThemeData(
              colorScheme: const ColorScheme.dark(
                  secondary: ColorStyles.white, primary: ColorStyles.white),
              fontFamily: 'Jost',
              textTheme: const TextTheme(
                bodyLarge: TextStyles.text14SemiBoldDark,
                bodyMedium: TextStyles.text16MediumDark,
                bodySmall: TextStyles.text16RegularDark,
                headlineMedium: TextStyles.text16MediumDark,
                headlineLarge: TextStyles.text16SemiBoldDark,
                displaySmall: TextStyles.text12Regular,
                titleSmall: TextStyles.title18Medium,
                titleMedium: TextStyles.title20SemiBold,
                titleLarge: TextStyles.title21Regular,
              ),
            ),
            home: const SplashScreen());
      },
    );
  }
}
