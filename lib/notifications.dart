import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class SilentNoti{

  static Future initialize(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var androidInitialize = const AndroidInitializationSettings('mipmap/ic_launcher');
    var initializationSettings = InitializationSettings(android: androidInitialize);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }
  static Future showBigTextNotification({var id = 0, required String title, required String body, var payload, required FlutterLocalNotificationsPlugin fln}) async {
    AndroidNotificationDetails androidPlatformSpecifics = const AndroidNotificationDetails(
      'delvr-silent',
      'delvr_notification_channel-silent',
      playSound: false,
      enableVibration: false,
      importance: Importance.max,
      priority: Priority.high,
    );

    var not = NotificationDetails(android: androidPlatformSpecifics);
    await fln.show(0, title, body, not);
  }
}

class VibrateNoti{

  static Future initialize(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var androidInitialize = const AndroidInitializationSettings('mipmap/ic_launcher');
    var initializationSettings = InitializationSettings(android: androidInitialize);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }
  static Future showBigTextNotification({var id = 1, required String title, required String body, var payload, required FlutterLocalNotificationsPlugin fln}) async {
    AndroidNotificationDetails androidPlatformSpecifics = const AndroidNotificationDetails(
      'delvr-vibrate',
      'delvr_notification_channel-vibrate',
      playSound: false,
      enableVibration: true,
      importance: Importance.max,
      priority: Priority.high,
    );

    var not = NotificationDetails(android: androidPlatformSpecifics);
    await fln.show(0, title, body, not);
  }
}

class SoundNoti{

  static Future initialize(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var androidInitialize = const AndroidInitializationSettings('mipmap/ic_launcher');
    var initializationSettings = InitializationSettings(android: androidInitialize);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }
  static Future showBigTextNotification({var id = 2, required String title, required String body, var payload, required FlutterLocalNotificationsPlugin fln}) async {
    AndroidNotificationDetails androidPlatformSpecifics = const AndroidNotificationDetails(
      'delvr-sound',
      'delvr_notification_channel-sound',
      playSound: true,
      enableVibration: true,
      importance: Importance.max,
      priority: Priority.high,
    );

    var not = NotificationDetails(android: androidPlatformSpecifics);
    await fln.show(0, title, body, not);
  }
}

class OnlySoundNoti{

  static Future initialize(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var androidInitialize = const AndroidInitializationSettings('mipmap/ic_launcher');
    var initializationSettings = InitializationSettings(android: androidInitialize);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }
  static Future showBigTextNotification({var id = 3, required String title, required String body, var payload, required FlutterLocalNotificationsPlugin fln}) async {
    AndroidNotificationDetails androidPlatformSpecifics = const AndroidNotificationDetails(
      'delvr-onlysound',
      'delvr_notification_channel-onlysound',
      playSound: true,
      enableVibration: false,
      importance: Importance.max,
      priority: Priority.high,
    );

    var not = NotificationDetails(android: androidPlatformSpecifics);
    await fln.show(0, title, body, not);
  }
}