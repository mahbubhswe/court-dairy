// custom_snackbar.dart
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppSnackbar {
  static AudioPlayer audioPlayer = AudioPlayer();
  static void show({
    required String title,
    required String message,
    required Color textColor,
    Function()? onTap,
  }) {
    audioPlayer.play(AssetSource('sounds/done.mp3'));
    Get.snackbar(
      title,
      message,
      duration: const Duration(seconds: 3),
      colorText: textColor,
      snackPosition: SnackPosition.TOP,
      borderRadius: 12,
      margin: const EdgeInsets.all(12),
      icon: Icon(
        Icons.notifications_active_rounded,
        color: textColor,
        size: 30.0,
      ),
    );
  }
}
