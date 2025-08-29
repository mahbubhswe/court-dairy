import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin notification =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );

    await notification.initialize(initializationSettings);
    tz.initializeTimeZones();
    await requestPermissions();
  }

  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduleDateTime,
  }) async {
    // Convert DateTime to TZDateTime
    tz.TZDateTime scheduleDate = tz.TZDateTime.from(scheduleDateTime, tz.local);

    // Schedule the notification
    await notification.zonedSchedule(
      id,
      title,
      body,
      scheduleDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'your_channel_id',
          'Payment Date Reminder',
          channelDescription: 'your_channel_description',
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static Future<void> cancelNotification(int id) async {
    // Cancel the notification with the given ID
    await notification.cancel(id);
  }

  static Future<void> requestPermissions() async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }

    if (await Permission.scheduleExactAlarm.isDenied) {
      await Permission.scheduleExactAlarm.request();
    }
  }


  static Future<void> scheduleDailyNotification({
    required int id,
    required String title,
    required String body,
    required DateTime time,
  }) async {
    final bool isAlreadyScheduled = await isNotificationScheduled(id);
    if (!isAlreadyScheduled) {
      final tz.TZDateTime now = tz.TZDateTime.now(tz.local);

      // Schedule the notification for the next occurrence of the specified time
      tz.TZDateTime scheduleTime = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        time.hour,
        time.minute,
      );

      if (scheduleTime.isBefore(now)) {
        // If the time has already passed for today, schedule it for tomorrow
        scheduleTime = scheduleTime.add(const Duration(days: 1));
      }

      await notification.zonedSchedule(
        id,
        title,
        body,
        scheduleTime,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'daily_notification_channel',
            'Daily Notifications',
            channelDescription: 'Notifications for daily reminders',
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
        matchDateTimeComponents:
            DateTimeComponents.time, // Ensures daily recurrence
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode
            .alarmClock, // Alarm clock mode for high accuracy
      );
    }
  }

  /// Checks if a notification with the given ID exists.
  static Future<bool> isNotificationScheduled(int id) async {
    final List<PendingNotificationRequest> pendingNotifications =
        await notification.pendingNotificationRequests();

    // Check if any notification matches the given ID
    return pendingNotifications.any((notification) => notification.id == id);
  }

    // New method to show a simple local notification immediately
  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    await notification.show(
      id,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'Account Activation',
          'acc',
          channelDescription: 'Notification channel description',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  }

}
