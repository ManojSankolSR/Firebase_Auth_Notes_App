// import 'dart:convert';

// import 'package:bottom/Models/DataModel.dart';
// import 'package:bottom/Models/RemainderModel.dart';
// import 'package:bottom/Screens/Notifiactionclick.dart';
// import 'package:bottom/Remainders/NewNoteScreen.dart';
// import 'package:bottom/Screens/NewNoteScreen.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:page_transition/page_transition.dart';
// import 'package:path/path.dart';
// import 'package:timezone/timezone.dart' as tz;
import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bottom/Models/RemainderModel.dart';
import 'package:bottom/Providers/RemainderProvider.dart';
import 'package:bottom/Screens/NotesScreen.dart';
import 'package:bottom/Screens/Notifiactionclick.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

// class Notificationservice {
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   final AndroidInitializationSettings androidInitializationSettings =
//       AndroidInitializationSettings('show');

//   void initialiseNotification() async {
//     InitializationSettings initializationSettings =
//         InitializationSettings(android: androidInitializationSettings);
//     flutterLocalNotificationsPlugin.initialize(initializationSettings,
//         onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
//         onDidReceiveBackgroundNotificationResponse:
//             onDidReceiveNotificationResponse);
//     print("init");
//   }

//   static void onDidReceiveNotificationResponse(
//       NotificationResponse notificationResponse) async {
//     final String? payload = notificationResponse.payload;
//     if (notificationResponse.payload != null) {
//       var row = jsonDecode(notificationResponse.payload!);

//       print('notification payload: $row["rid"]');
//       Navigator.push(
//           navigatorKey.currentContext!,
//           PageTransition(
//               child: NotifcationClick(
//                   remainder: RemainderModel(
//                 rid: row['rid'] as int,
//                 id: row['id'] as String,
//                 date: DateTime.parse(row['Added_Date'] as String),
//                 title: row['Title'] as String,
//                 note: row['Note'] as String,
//                 rdate: DateTime.parse(row["Remainder_date"] as String),
//               )),
//               type: PageTransitionType.bottomToTop));
//     } else {}
//   }

//   void sendNotifi() async {
//     const sound = 'ring.mp3';
//     flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.requestPermission();
//     AndroidNotificationDetails androidNotificationDetails =
//         AndroidNotificationDetails("channel_id_52", "dbfood254",
//             enableVibration: true,
//             playSound: true,
//             sound: RawResourceAndroidNotificationSound('ring'),
//             importance: Importance.max,
//             priority: Priority.max);

//     NotificationDetails notificationDetails =
//         NotificationDetails(android: androidNotificationDetails);
//     await flutterLocalNotificationsPlugin.show(
//         2, "title", "body", notificationDetails);
//   }

//   void shownot() async {
//     final li =
//         await flutterLocalNotificationsPlugin.pendingNotificationRequests();
//     if (kDebugMode) {
//       print(li.map((e) => print(e.id)));
//     }
//   }

//   void sendscheduledNotfication(int id, DateTime datetime, String title,
//       String body, String payload) async {
//     flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.requestPermission();
//     AndroidNotificationDetails androidNotificationDetails =
//         AndroidNotificationDetails("channel_id_65", "dbfood254",
//             enableVibration: true,
//             playSound: true,
//             sound: RawResourceAndroidNotificationSound('ring'),
//             importance: Importance.max,
//             priority: Priority.max);

//     NotificationDetails notificationDetails =
//         NotificationDetails(android: androidNotificationDetails);

//     await flutterLocalNotificationsPlugin.zonedSchedule(
//         id,
//         title,
//         body,
//         payload: payload,
//         tz.TZDateTime.from(datetime, tz.local),
//         notificationDetails,
//         uiLocalNotificationDateInterpretation:
//             UILocalNotificationDateInterpretation.absoluteTime);

//     print(await flutterLocalNotificationsPlugin.getActiveNotifications());
//   }

//   void delRemainder(int id) async {
//     flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.requestPermission();
//     AndroidNotificationDetails androidNotificationDetails =
//         const AndroidNotificationDetails("channel_id_125", "dbfood52",
//             enableVibration: true,
//             playSound: true,
//             sound: RawResourceAndroidNotificationSound('ring'),
//             importance: Importance.max,
//             priority: Priority.max);

//     NotificationDetails notificationDetails =
//         NotificationDetails(android: androidNotificationDetails);
//     await flutterLocalNotificationsPlugin.cancel(id);
//     // print(await flutterLocalNotificationsPlugin.getActiveNotifications());
//   }
// }

class Notificationservice {
  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    print("body :receivedNotification.body");
  }

  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    if (receivedAction.buttonKeyPressed == "cancel") {
      print("cancel");
      await AwesomeNotifications().dismiss(receivedAction.id!);
    }
    if (receivedAction.buttonKeyPressed == "show_remainder") {
      print(receivedAction.payload);
      navigatorKey.currentState?.push(MaterialPageRoute(
        builder: (context) {
          Map<String, String?>? row = receivedAction.payload;
          return NotifcationClick(
              remainder: RemainderModel(
            rid: int.parse(row!['rid']!),
            id: row['id'] as String,
            date: DateTime.parse(row['Added_Date'] as String),
            title: row['Title'] as String,
            note: row['Note'] as String,
            rdate: DateTime.parse(row["Remainder_date"] as String),
          ));
        },
      ));
    }
  }

  Future<bool> initialiseNotification() async {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        // This is just a basic example. For real apps, you must show some
        // friendly dialog box before call the request method.
        // This is very important to not harm the user experience
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    // await setlistners();
    return AwesomeNotifications().initialize(
        null,
        [
          NotificationChannel(
              importance: NotificationImportance.Max,
              defaultRingtoneType: DefaultRingtoneType.Alarm,
              soundSource: 'resource://raw/ring',
              criticalAlerts: true,
              enableVibration: true,
              vibrationPattern: highVibrationPattern,
              playSound: true,
              channelGroupKey: 'Notes_sound_channel_group',
              channelKey: 'Notes_sound_channel',
              channelName: 'Notes notifications',
              channelDescription: 'Notification channel for basic tests',
              defaultColor: Color(0xFF9D50DD),
              ledColor: Colors.white)
        ],
        // Channel groups are only visual and are not required
        channelGroups: [
          NotificationChannelGroup(
              channelGroupKey: 'Notes_sound_channel_group',
              channelGroupName: 'Notes_group')
        ],
        debug: true);
  }

  Future sendscheduledNotfication(int rid, DateTime datetime, String title,
      String note, String body, Map<String, String> payload) async {
    return await AwesomeNotifications().createNotification(
        schedule: NotificationCalendar.fromDate(
            date: datetime,
            allowWhileIdle: true,
            preciseAlarm: true,
            repeats: true),
        actionButtons: [
          NotificationActionButton(key: "cancel", label: "Cancel"),
          NotificationActionButton(
              key: "show_remainder", label: "Show Remainder"),
        ],
        content: NotificationContent(
          payload: payload,
          displayOnForeground: true,
          displayOnBackground: true,
          customSound: "resource://raw/ring",
          criticalAlert: true,
          backgroundColor: Colors.pinkAccent,
          category: NotificationCategory.Reminder,
          id: rid,
          channelKey: 'Notes_sound_channel',
          actionType: ActionType.Default,
          title: title,
          body: note,
          notificationLayout: NotificationLayout.BigText,
        ));
  }

  Future delRemainder(int id) async {
    return await AwesomeNotifications().cancel(id);
  }
}
