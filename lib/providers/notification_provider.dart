import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:permission_handler/permission_handler.dart';

class LocalNotifications {
  // //shedule on click
  static Future<void> sendSheduledNotification(
      String title, String body) async {
    final _status = await Permission.notification.request();

    if (_status != PermissionStatus.granted) {
      print("notification perission denied");
      return;
    }
    final _flutterLocalNotificationPlugin = FlutterLocalNotificationsPlugin();
    const _androidInitializationSettings =
        AndroidInitializationSettings("app_icon");

    final _darwinInitializationSettings = DarwinInitializationSettings();
    InitializationSettings _initilizationSettings = InitializationSettings(
      android: _androidInitializationSettings,
      iOS: _darwinInitializationSettings,
    );
    await _flutterLocalNotificationPlugin.initialize(_initilizationSettings);

    final _androidNotificationDetails = AndroidNotificationDetails(
      'high_importance_channel3',
      'show_notification3',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      sound: RawResourceAndroidNotificationSound('not'),
    );

    final _iosNotificationDetails = DarwinNotificationDetails(
      badgeNumber: 1,
    );

    NotificationDetails _notificationDetails = NotificationDetails(
      android: _androidNotificationDetails,
      iOS: _iosNotificationDetails,
    );

    _flutterLocalNotificationPlugin.periodicallyShow(
      0,
      title,
      body,
      RepeatInterval.hourly,
      _notificationDetails,
    );
  }

  static void showNotification() async {
    final _status = await Permission.notification.request();

    if (_status != PermissionStatus.granted) {
      print("notification perission denied");
      return;
    }
    final _flutterLocalNotificationPlugin = FlutterLocalNotificationsPlugin();
    const _androidInitializationSettings =
        AndroidInitializationSettings('mipmap/ic_launcher');

    final _darwinInitializationSettings = DarwinInitializationSettings();
    InitializationSettings _initilizationSettings = InitializationSettings(
      android: _androidInitializationSettings,
      iOS: _darwinInitializationSettings,
    );
    await _flutterLocalNotificationPlugin.initialize(_initilizationSettings);

    final _androidNotificationDetails = AndroidNotificationDetails(
      'high_importance_channel4',
      'show_notification4',
      importance: Importance.max,
      priority: Priority.high,
      enableVibration: true,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('not'),
    );

    final _iosNotificationDetails = DarwinNotificationDetails(
      badgeNumber: 1,
    );

    NotificationDetails _notificationDetails = NotificationDetails(
      android: _androidNotificationDetails,
      iOS: _iosNotificationDetails,
    );

    _flutterLocalNotificationPlugin.show(
      0,
      'Welcome Arshad',
      'Read news articles ',
      _notificationDetails,
    );
  }

  // //shedule
  // void scheduleNotifications() async {
  //   const AndroidNotificationDetails androidPlatformChannelSpecifics =
  //       AndroidNotificationDetails(
  //     'channel_id',
  //     'channel_name',
  //     importance: Importance.max,
  //     priority: Priority.high,
  //   );

  //   const NotificationDetails platformChannelSpecifics =
  //       NotificationDetails(android: androidPlatformChannelSpecifics);

  //   final String timeZoneName = await tz.TZDateTime.now(tz.local).timeZoneName;
  //   final tz.Location timeZone = tz.getLocation(timeZoneName);

  //   for (int i = 0; i < 24; i++) {
  //     final tz.TZDateTime notificationTime =
  //         tz.TZDateTime.now(timeZone).add(Duration(hours: i + 1));

  //     await flutterLocalNotificationsPlugin.zonedSchedule(
  //       i,
  //       'Notification Title',
  //       'Notification Body',
  //       notificationTime,
  //       platformChannelSpecifics,
  //       //androidAllowWhileIdle: true,
  //       uiLocalNotificationDateInterpretation:
  //           UILocalNotificationDateInterpretation.absoluteTime,
  //       matchDateTimeComponents: DateTimeComponents.time,
  //       payload: 'Notification Payload',

  //       //androidAllowWhileIdle: true,
  //     );
  //  }
  // }
}
