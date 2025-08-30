import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

import '../../../widgets/app_button.dart';
import '../../../widgets/app_text_from_field.dart';
import '../controllers/add_party_controller.dart';

class AddPartyScreen extends StatelessWidget {
  const AddPartyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddPartyController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('নতুন পক্ষ যুক্ত করুন'),
      ),
      body: Obx(() {
        return SingleChildScrollView(
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
                    backgroundImage:
                        image != null ? FileImage(File(image.path)) : null,
                    child:
                        image == null ? const Icon(Icons.camera_alt, size: 40) : null,
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
        );
      }),
      bottomNavigationBar: Obx(() => SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: AppButton(
                label: 'সেভ করুন',
                isLoading: controller.isLoading.value,
                onPressed: controller.enableBtn.value
                    ? () {
                        PanaraConfirmDialog.show(
                          context,
                          title: 'নিশ্চিত করুন',
                          message: 'পক্ষ যুক্ত করতে চান?',
                          confirmButtonText: 'হ্যাঁ',
                          cancelButtonText: 'না',
                          onTapCancel: () {
                            Navigator.of(context).pop();
                          },
                          onTapConfirm: () async {
                            Navigator.of(context).pop();
                            final success = await controller.addParty();
                            if (success) {
                              PanaraInfoDialog.show(
                                context,
                                title: 'সফল হয়েছে',
                                message: 'পক্ষ যুক্ত করা হয়েছে',
                                panaraDialogType: PanaraDialogType.success,
                                barrierDismissible: false,
                                onTapDismiss: () {
                                  Navigator.of(context).pop();
                                  Get.back();
                                },
                              );
                            } else {
                              PanaraInfoDialog.show(
                                context,
                                title: 'ত্রুটি',
                                message: 'পক্ষ যুক্ত করতে ব্যর্থ হয়েছে',
                                panaraDialogType: PanaraDialogType.error,
                                barrierDismissible: false,
                                onTapDismiss: () {
                                  Navigator.of(context).pop();
                                },
                              );
                            }
                          },
                          panaraDialogType: PanaraDialogType.normal,
                        );
                      }
                    : null,
              ),
            ),
          )),
    );
  }
}
