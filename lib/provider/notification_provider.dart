import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:meeting_room/model/slot.dart' hide Priority;
import 'package:meeting_room/util/essentials.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationProvider with ChangeNotifier {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationProvider() {
    init();
  }

  init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_launcher');
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(onDidReceiveLocalNotification: null);
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: null);
  }

  cancelAllAlert() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  scheduleAlert(
      BuildContext context, Slot slot, tz.TZDateTime scheduleTime) async {
    printIfDebug(slot.timeRange.start.format(context));
    printIfDebug("scheduledAlertTime: " +
        DateFormat("yyyy.MM.dd HH:mm:ss").format(scheduleTime));
    await flutterLocalNotificationsPlugin.zonedSchedule(
        int.parse(slot.id).remainder(100000),
        "[Meeting starts in ${alertName(slot.alert)}] " + slot.title,
        slot.desc,
        scheduleTime,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'com.meetingplanner',
            'Meeting Planner',
            'Meeting Schedules',
            importance: Importance.max,
            priority: getAlertPriority(slot.priority.id),
          ),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }
}
