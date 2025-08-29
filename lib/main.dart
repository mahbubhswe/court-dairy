import 'package:courtdiary/services/theme_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:get_storage/get_storage.dart';
import 'firebase_options.dart';
import 'modules/auth/views/auth_view.dart';
import 'services/in_app_update_service.dart';
import 'services/notification_service.dart';
import 'themes/app_themes.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationService.init();
  await InAppUpdateService.checkForUpdate();
  await OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize('336ac4cc-8050-48c2-b917-da0d46a275cf');
  await OneSignal.Notifications.requestPermission(true);
  GetStorage.init();
  // bool isHas = await NotificationService.isNotificationScheduled(5583);
  // if (!isHas) {
  //   // Schedule the notification
  //   final DateTime dailyTime =
  //       DateTime.now().copyWith(hour: 22, minute: 0); // 10 PM today
  //   await NotificationService.scheduleDailyNotification(
  //     id: 5583,
  //     title: 'Court Diary',
  //     body: "Update your today's cases",
  //     time: dailyTime,
  //   );
  // }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Court Diary',
      debugShowCheckedModeBanner: false,
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: ThemeService().theme,
      builder: (context, child) {
        final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
        AppThemes.updateSystemUIOverlay(isDarkTheme);
        return child!;
      },
      home: AnimatedSplashScreen(
        splashIconSize: 125,
        splash: Image.asset(
          'assets/images/logo.png',
        ),
        nextScreen: const AuthView(),
        splashTransition: SplashTransition.fadeTransition,
      ),
    );
  }
}
