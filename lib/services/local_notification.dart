import 'dart:io' show Platform;
import 'package:flutter/services.dart';
import 'package:android_intent_plus/android_intent.dart';
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

  Future<void> _openExactAlarmSettings() async {
    const intent = AndroidIntent(
      action: 'android.settings.REQUEST_SCHEDULE_EXACT_ALARM',
      data: 'package:com.appseba.courtdiary',
    );
    try {
      await intent.launch();
    } catch (_) {
      // Ignore if the settings screen can't be opened
    }
  }

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

    // Android 13+ needs runtime notification permission
    // Android 12+ may require special exact alarm permission
    if (Platform.isAndroid) {
      final androidPlugin = notificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      // Request POST_NOTIFICATIONS (Android 13+)
      await androidPlugin?.requestNotificationsPermission();

      // Proactively request exact alarm permission on Android 12+
      // If the method isn't supported by the current plugin version, it is a no-op.
      try {
        final canScheduleExact =
            await androidPlugin?.canScheduleExactNotifications() ?? true;
        if (!canScheduleExact) {
          try {
            await androidPlugin?.requestExactAlarmsPermission();
          } catch (_) {
            await _openExactAlarmSettings();
          }
        }
      } catch (_) {
        await _openExactAlarmSettings();
      }
    }
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
    // Prefer inexact periodic to avoid requiring exact alarm permission
    notificationsPlugin.periodicallyShow(
      id,
      title,
      body,
      RepeatInterval.daily,
      notificationDetails(),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
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
    try {
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
    } on PlatformException catch (e) {
      // Handle Android 12+ exact alarm restriction gracefully
      if (e.code == 'exact_alarms_not_permitted' && Platform.isAndroid) {
        final androidPlugin = notificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>();
        try {
          await androidPlugin?.requestExactAlarmsPermission();
        } catch (_) {
          await _openExactAlarmSettings();
        }
        // Fallback to inexact schedule at roughly the same time
        await notificationsPlugin.zonedSchedule(
          id,
          title,
          body,
          scheduledDate,
          notificationDetails(),
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          matchDateTimeComponents: DateTimeComponents.time,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          payload: payload,
        );
      } else {
        rethrow;
      }
    }
  }
}
