import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationService {
  LocalNotificationService._internal();
  static final LocalNotificationService _instance =
      LocalNotificationService._internal();
  factory LocalNotificationService() => _instance;

  final notificationsPlugin = FlutterLocalNotificationsPlugin();
  bool isInit = false;
  bool get isInited => isInit;

  Future<void> initialize({Function(String?)? onTap}) async {
    if (isInit) return;
    tz.initializeTimeZones();
    const androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInitializationSettings = DarwinInitializationSettings();

    const initSetting = InitializationSettings(
        android: androidInitializationSettings, iOS: iosInitializationSettings);
    await notificationsPlugin.initialize(initSetting,
        onDidReceiveNotificationResponse: (details) {
      onTap?.call(details.payload);
    });
    isInit = true;
  }

  NotificationDetails notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails(
          'seba_pos_local_notification_channel',
          'Local Notification',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails());
  }

  Future<void> showNotification(
      {required String title, required String body}) async {
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    int id = timestamp % 2147483647;
    notificationsPlugin.show(id, title, body, notificationDetails());
  }

  Future<void> scheduleDailyNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    await notificationsPlugin.cancel(id);
    notificationsPlugin.periodicallyShow(
      id,
      title,
      body,
      RepeatInterval.daily,
      notificationDetails(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: payload,
    );
  }

  Future<void> scheduleDailyAtTime({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
    String? payload,
  }) async {
    await notificationsPlugin.cancel(id);
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
        tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    await notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      notificationDetails(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
  }
}
