import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/app_button.dart';
import '../../../widgets/app_text_from_field.dart';
import '../../../widgets/app_dropdown.dart';
import '../../../utils/payment_methods.dart';
import '../../../utils/transaction_types.dart';
import '../controllers/add_transaction_controller.dart';

class AddTransactionScreen extends StatelessWidget {
  const AddTransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddTransactionController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('নতুন লেনদেন যুক্ত করুন'),
      ),
      body: Obx(() {
        return Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                spacing: 16,
                children: [
                  AppDropdown(
                    value: controller.type.value,
                    label: 'ধরণ',
                    hintText: 'লেনদেনের ধরণ নির্বাচন করুন',
                    items: getTransactionTypes(isTransaction: true),
                    prefixIcon: Icons.category,
                    onChanged: (val) => controller.type.value = val,
                  ),
                  AppTextFromField(
                    controller: controller.amount,
                    label: 'পরিমাণ',
                    hintText: 'পরিমাণ লিখুন',
                    prefixIcon: Icons.money,
                    keyboardType: TextInputType.number,
                  ),
                  AppDropdown(
                    value: controller.paymentMethod.value,
                    label: 'পেমেন্ট পদ্ধতি',
                    hintText: 'পেমেন্ট পদ্ধতি নির্বাচন করুন',
                    items: paymentMethods,
                    prefixIcon: Icons.payment,
                    onChanged: (val) => controller.paymentMethod.value = val,
                  ),
                  AppTextFromField(
                    controller: controller.note,
                    label: 'নোট',
                    hintText: 'নোট লিখুন',
                    prefixIcon: Icons.note,
                    isMaxLines: 3,
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
            if (controller.isLoading.value)
              const Center(child: CircularProgressIndicator()),
          ],
        );
      }),
      bottomNavigationBar: Obx(
        () => Padding(
          padding: const EdgeInsets.all(16),
          child: AppButton(
            label: 'সেভ করুন',
            onPressed:
                controller.enableBtn.value ? controller.addTransaction : null,
          ),
        ),
      ),
    );
  }
}
