import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/app_images.dart';
import '../modules/auth/controllers/auth_controller.dart';
import '../modules/auth/screens/auth_view.dart';
import '../modules/layout/screens/layout_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return AnimatedSplashScreen(
      splash: Image.asset(
        AppImages.logo,
        height: 150,
      ),
      nextScreen: Obx(() {
        if (authController.user.value != null) {
          return LayoutScreen();
        } else {
          return AuthScreen();
        }
      }),
      splashIconSize: 150,
      duration: 2000,
      splashTransition: SplashTransition.fadeTransition,
      animationDuration: const Duration(milliseconds: 600),
    );
  }
}
