import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
            macOS: null);
    tz.initializeTimeZones();
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  Future<void> showNotification(
      int id, String title, String body, DateTime scheduleDate) async {
    var date = tz.TZDateTime.from(
        DateTime(
            scheduleDate.year, scheduleDate.month, scheduleDate.day - 1, 0, 0),
        tz.local);
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      date,
      const NotificationDetails(
        // Android details
        android: AndroidNotificationDetails('main_channel', 'Main Channel',
            channelDescription: "Events",
            importance: Importance.max,
            priority: Priority.max),
        // iOS details
        iOS: IOSNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),

      // Type of time interpretation
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle:
          true, // To show notification even when the app is closed
    );
  }

  Future<void> showNowNotification(int id, String title, String body) async {
    var date =
        tz.TZDateTime.from(DateTime.now().add(const Duration(seconds: 5)), tz.local);
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      date,
      const NotificationDetails(
        // Android details
        android: AndroidNotificationDetails('main_channel', 'Main Channel',
            channelDescription: "Events",
            importance: Importance.max,
            priority: Priority.max),
        // iOS details
        iOS: IOSNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),

      // Type of time interpretation
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle:
          true, // To show notification even when the app is closed
    );
  }

  Future selectNotification(String? payload) async {
    //Handle notification tapped logic here
  }
}
