import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sigest/locator.dart';
import 'package:sigest/models/settings.dart';
import 'package:sigest/models/user.dart';
import 'package:flutter/foundation.dart' show kIsWeb;


import 'package:hive_flutter/hive_flutter.dart';
import 'package:sigest/views/scenes/splash.dart';
import 'package:sigest/views/styles.dart';

import 'helpers/notification_service.dart';
import 'helpers/serializers.dart';
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
late NotificationService notificationService;

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
  if (!kIsWeb) {
    await initNotifications();
  }

  runApp(const MyApp());
}

Future<void> initNotifications() async {
  SettingsModel? settings =
  Hive.box<SettingsModel>('settings').get('current');
  bool notificationsEnabled = settings == null ? true : settings
      .notificationsEnabled;
  notificationService = NotificationService();
  notificationService.initializePlatformNotifications();

  if (notificationsEnabled &&
      !await notificationService.hasActiveNotifications()) {
    print('create notification');

    notificationService.showScheduledNotification(id: NotificationService.scheduledNotificationId,
        title: 'Книга Жестов',
        body: NotificationService.getRandomNotificationBody(),
        payload: 'Приступим!',
        time: Serializer.stringToTimeOfDay(settings?.notificationTime ?? '18:00'));
  } else {
    print('not create notification');
  }
}

Future<void> loadConfig() async {
  String conf = 'config/app_settings.json';

  if (!kIsWeb) {
    conf = 'assets/' + conf;
  }

  final contents = await rootBundle.loadString(
    conf,
  );

  config = jsonDecode(contents);
}

Future<List<void>> cacheAssets() async {
  List<String> assets = [
    'images/triangle.svg',
    'images/unit.svg',
    'images/vocabulary/A.svg',
    'images/vocabulary/B.svg',
    'images/vocabulary/V.svg',
    'images/vocabulary/G.svg',
    'images/vocabulary/D.svg',
    'images/vocabulary/E.svg',
    'images/vocabulary/Yo.svg',
    'images/vocabulary/Zh.svg',
    'images/vocabulary/Z.svg',
    'images/vocabulary/I.svg',
    'images/vocabulary/J.svg',
    'images/vocabulary/K.svg',
    'images/vocabulary/L.svg',
    'images/vocabulary/M.svg',
    'images/vocabulary/N.svg',
    'images/vocabulary/O.svg',
    'images/vocabulary/P.svg',
    'images/vocabulary/R.svg',
    'images/vocabulary/S.svg',
    'images/vocabulary/T.svg',
    'images/vocabulary/U.svg',
    'images/vocabulary/F.svg',
    'images/vocabulary/H.svg',
    'images/vocabulary/Ts.svg',
    'images/vocabulary/Ch.svg',
    'images/vocabulary/Sh.svg',
    'images/vocabulary/Shch.svg',
    'images/vocabulary/Ss.svg',
    'images/vocabulary/Y.svg',
    'images/vocabulary/Hs.svg',
    'images/vocabulary/Aa.svg',
    'images/vocabulary/You.svg',
    'images/vocabulary/Ya.svg',
  ];

  if (!kIsWeb) {
    for (int i = 0; i < assets.length; i++) {
      assets[i] = 'assets/' + assets[i];
    }
  }

  return Future.wait(assets
      .map((asset) =>
      precachePicture(
        ExactAssetPicture(
          SvgPicture.svgStringDecoderBuilder,
          asset,
        ),
        null,
      ))
      .toList());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey(
      debugLabel: "Main Navigator");

  @override
  void initState() {
    if (!kIsWeb) {
      listenToNotificationStream();
    }
    super.initState();
  }

  void listenToNotificationStream() {
    notificationService.behaviorSubject.listen((payload) {
      navigatorKey.currentState?.pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const SplashScreen()), (r) => false
      );
    });
  }

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
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
            title: 'Книга Жестов',
            theme: ThemeData(
              pageTransitionsTheme: const PageTransitionsTheme(
                builders: <TargetPlatform, PageTransitionsBuilder>{
                  TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
                  TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                  TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
                  TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
                  TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
                },
              ),
              colorScheme: const ColorScheme.light(
                  secondary: ColorStyles.gray, primary: ColorStyles.black),
              fontFamily: 'Comfortaa',
              textTheme: const TextTheme(
                bodyMedium: TextStyles.text14MediumLight,
                bodySmall: TextStyles.text16RegularLight ,
                headlineSmall: TextStyles.text16BoldLight,
                headlineMedium: TextStyles.text16BoldLight,
                headlineLarge: TextStyles.text16SemiBoldLight,
                titleSmall: TextStyles.title18Bold,
                titleMedium: TextStyles.title20Bold,
                titleLarge: TextStyles.title21Regular,
              ),
            ),
            darkTheme: ThemeData(
              pageTransitionsTheme: const PageTransitionsTheme(
                builders: <TargetPlatform, PageTransitionsBuilder>{
                  TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
                  TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                  TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
                  TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
                  TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
                },
              ),
              colorScheme: const ColorScheme.dark(
                  secondary: ColorStyles.white, primary: ColorStyles.white),
              fontFamily: 'Comfortaa',
              textTheme: const TextTheme(
                bodyMedium: TextStyles.text14MediumDark,
                bodySmall: TextStyles.text16RegularDark,
                headlineSmall: TextStyles.text16BoldDark,
                headlineMedium: TextStyles.text16BoldDark,
                headlineLarge: TextStyles.text16SemiBoldDark,
                titleSmall: TextStyles.title18Bold,
                titleMedium: TextStyles.title20Bold,
                titleLarge: TextStyles.title21Regular,
              ),
            ),
            home: const SplashScreen());
      },
    );
  }
}
