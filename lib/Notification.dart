import 'dart:convert';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bottom/Models/RemainderModel.dart';
import 'package:bottom/Providers/RemainderProvider.dart';
import 'package:bottom/Screens/NotesScreen.dart';
import 'package:bottom/Screens/Notifiactionclick.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

class Notificationservice {
  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {}

  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    if (receivedAction.buttonKeyPressed == "cancel") {
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
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
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
          wakeUpScreen: true,
          payload: payload,
          displayOnForeground: true,
          displayOnBackground: true,
          customSound: "resource://raw/ring",
          criticalAlert: true,
          backgroundColor: Colors.pinkAccent,
          category: NotificationCategory.Alarm,
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
