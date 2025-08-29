import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showNewUserDialog() {
  Future.delayed(const Duration(seconds: 5), () {
    if (Get.context != null) {
      Get.dialog(
        Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.celebration, size: 50, color: Colors.green),
                const SizedBox(height: 16),
                const Text(
                  "Welcome 🎉",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Your account has been created successfully!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text("Got it"),
                ),
              ],
            ),
          ),
        ),
        barrierDismissible: false,
      );
    }
  });
}
