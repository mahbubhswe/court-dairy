import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/app_button.dart';
import '../../../widgets/app_text_from_field.dart';
import '../controllers/add_party_controller.dart';

class PartyScreen extends StatelessWidget {
  const PartyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddPartyController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('নতুন পক্ষ যুক্ত করুন'),
      ),
      body: Obx(() {
        return Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                spacing: 16,
                children: [
                  AppTextFromField(
                    controller: controller.name,
                    label: 'নাম',
                    hintText: 'পক্ষের নাম লিখুন',
                    prefixIcon: Icons.person,
                  ),
                  AppTextFromField(
                    controller: controller.phone,
                    label: 'মোবাইল',
                    hintText: 'মোবাইল নম্বর লিখুন',
                    prefixIcon: Icons.phone,
                    keyboardType: TextInputType.phone,
                  ),
                  AppTextFromField(
                    controller: controller.address,
                    label: 'ঠিকানা',
                    hintText: 'ঠিকানা লিখুন',
                    prefixIcon: Icons.home,
                    isMaxLines: 3,
                  ),
                  const SizedBox(height: 20),
                  AppButton(
                    label: 'সেভ করুন',
                    onPressed: controller.enableBtn.value
                        ? controller.addParty
                        : null,
                  ),
                ],
              ),
            ),
            if (controller.isLoading.value)
              const Center(child: CircularProgressIndicator()),
          ],
        );
      }),
    );
  }
}

