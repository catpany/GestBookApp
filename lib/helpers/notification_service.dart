import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sigest/main.dart';
import 'package:timezone/data/latest.dart';
import 'package:timezone/timezone.dart';

@pragma('vm:entry-point')
void onDidReceiveBackgroundNotificationResponse(NotificationResponse response) {
  if (response.payload != null) {
    notificationService.behaviorSubject.add(response.payload ?? 'default');
  }
}

class NotificationService {
  final _localNotifications = FlutterLocalNotificationsPlugin();
  final BehaviorSubject<String> behaviorSubject = BehaviorSubject();

  static int scheduledNotificationId = 0;

  static String getRandomNotificationBody() {
    List<String> texts = ['Пора приступить к занятиям!', 'Время поучиться!', 'Пора заниматься!'];

    return texts.elementAt(Random().nextInt(texts.length));
  }

  Future<bool> hasActiveNotifications() async {
    List<ActiveNotification> notifications =
        await _localNotifications.getActiveNotifications();
    for (var notification in notifications) {
      print(notification.id);
    }

    return notifications.isNotEmpty;
  }

  void cancelNotification(int id) {
    _localNotifications.cancel(id);
  }

  Future<void> initializePlatformNotifications() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: androidInitializationSettings);

    initializeTimeZones();
    setLocalLocation(
        getLocation(await FlutterNativeTimezone.getLocalTimezone()));

    await _localNotifications.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
        onDidReceiveBackgroundNotificationResponse:
            onDidReceiveBackgroundNotificationResponse);
  }

  void onDidReceiveNotificationResponse(NotificationResponse response) {
    print(response.id);
    if (response.payload != null) {
      behaviorSubject.add(response.payload ?? 'default');
    }
  }

  NotificationDetails _notificationDetails() {
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails(
      'gestbookNotifications',
      'gestbookScheduledNot',
      groupKey: 'com.example.flutter_push_notifications',
      channelDescription: 'gestbook notifications',
      playSound: true,
    );

    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidNotificationDetails);

    return platformChannelSpecifics;
  }

  Future<void> showScheduledNotification(
      {required int id,
      required String title,
      required String body,
      required String payload,
      required TimeOfDay time}) async {
    final platformDetails = _notificationDetails();

    await _localNotifications.zonedSchedule(
        id,
        title,
        body,
        TZDateTime.from(
            DateTime.now().copyWith(hour: time.hour, minute: time.minute),
            local),
        platformDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time);
  }
}
