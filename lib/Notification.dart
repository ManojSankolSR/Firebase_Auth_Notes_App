import 'dart:convert';

import 'package:bottom/Models/DataModel.dart';
import 'package:bottom/Models/RemainderModel.dart';
import 'package:bottom/Screens/Notifiactionclick.dart';
import 'package:bottom/Remainders/NewNoteScreen.dart';
import 'package:bottom/Screens/NewNoteScreen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path/path.dart';
import 'package:timezone/timezone.dart' as tz;

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

class Notificationservice {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final AndroidInitializationSettings androidInitializationSettings =
      AndroidInitializationSettings('show');

  void initialiseNotification() async {
    InitializationSettings initializationSettings =
        InitializationSettings(android: androidInitializationSettings);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
        onDidReceiveBackgroundNotificationResponse:
            onDidReceiveNotificationResponse);
    print("init");
  }

  static void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (notificationResponse.payload != null) {
      var row = jsonDecode(notificationResponse.payload!);

      print('notification payload: $row["rid"]');
      Navigator.push(
          navigatorKey.currentContext!,
          PageTransition(
              child: NotifcationClick(
                  remainder: RemainderModel(
                rid: row['rid'] as int,
                id: row['id'] as String,
                date: DateTime.parse(row['Added_Date'] as String),
                title: row['Title'] as String,
                note: row['Note'] as String,
                rdate: DateTime.parse(row["Remainder_date"] as String),
              )),
              type: PageTransitionType.bottomToTop));
    } else {}
  }

  void sendNotifi() async {
    const sound = 'ring.mp3';
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails("channel_id_52", "dbfood254",
            enableVibration: true,
            playSound: true,
            sound: RawResourceAndroidNotificationSound('ring'),
            importance: Importance.max,
            priority: Priority.max);

    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
        2, "title", "body", notificationDetails);
  }

  void shownot() async {
    final li =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    if (kDebugMode) {
      print(li.map((e) => print(e.id)));
    }
  }

  void sendscheduledNotfication(int id, DateTime datetime, String title,
      String body, String payload) async {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails("channel_id_65", "dbfood254",
            enableVibration: true,
            playSound: true,
            sound: RawResourceAndroidNotificationSound('ring'),
            importance: Importance.max,
            priority: Priority.max);

    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        payload: payload,
        tz.TZDateTime.from(datetime, tz.local),
        notificationDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);

    print(await flutterLocalNotificationsPlugin.getActiveNotifications());
  }

  void delRemainder(int id) async {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails("channel_id_125", "dbfood52",
            enableVibration: true,
            playSound: true,
            sound: RawResourceAndroidNotificationSound('ring'),
            importance: Importance.max,
            priority: Priority.max);

    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.cancel(id);
    print(await flutterLocalNotificationsPlugin.getActiveNotifications());
  }
}
