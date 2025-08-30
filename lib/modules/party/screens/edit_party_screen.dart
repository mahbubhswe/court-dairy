import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/app_button.dart';
import '../../../widgets/app_text_from_field.dart';
import '../controllers/edit_party_controller.dart';
import '../../../models/party.dart';

class EditPartyScreen extends StatelessWidget {
  final Party party;
  const EditPartyScreen({super.key, required this.party});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditPartyController(party));
    return Scaffold(
      appBar: AppBar(
        title: const Text('পক্ষ সম্পাদনা'),
      ),
      body: Obx(() {
        return Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                spacing: 16,
                children: [
                  GestureDetector(
                    onTap: controller.showImagePicker,
                    child: Obx(() {
                      final image = controller.photo.value;
                      return CircleAvatar(
                        radius: 50,
                        backgroundImage: image != null
                            ? FileImage(File(image.path))
                            : (party.photoUrl != null
                                ? NetworkImage(party.photoUrl!) as ImageProvider
                                : null),
                        child: image == null && party.photoUrl == null
                            ? const Icon(Icons.camera_alt, size: 40)
                            : null,
                      );
                    }),
                  ),
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
                ],
              ),
            ),
            if (controller.isLoading.value)
              const Center(child: CircularProgressIndicator()),
          ],
        );
      }),
      bottomNavigationBar: Obx(() => SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: AppButton(
                label: 'আপডেট করুন',
                onPressed: controller.enableBtn.value
                    ? controller.updateParty
                    : null,
              ),
            ),
          )),
    );
  }
}
