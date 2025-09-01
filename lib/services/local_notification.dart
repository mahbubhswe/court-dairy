import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  final notificationsPlugin = FlutterLocalNotificationsPlugin();
  bool isInit = false;
  bool get isInited => isInit;

  Future<void> initialize({Function(String?)? onTap}) async {
    if (isInit) return;
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
    notificationsPlugin.periodicallyShow(id, title, body, RepeatInterval.daily,
        notificationDetails(),
        androidAllowWhileIdle: true, payload: payload);
  }
}
