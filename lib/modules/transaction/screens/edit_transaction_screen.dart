import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/app_button.dart';
import '../../../widgets/app_text_from_field.dart';
import '../controllers/edit_transaction_controller.dart';
import '../../../models/transaction.dart';

class EditTransactionScreen extends StatelessWidget {
  final Transaction transaction;
  const EditTransactionScreen({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditTransactionController(transaction));
    return Scaffold(
      appBar: AppBar(
        title: const Text('লেনদেন আপডেট করুন'),
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
                    controller: controller.type,
                    label: 'ধরণ',
                    hintText: 'লেনদেনের ধরণ লিখুন',
                    prefixIcon: Icons.category,
                  ),
                  AppTextFromField(
                    controller: controller.amount,
                    label: 'পরিমাণ',
                    hintText: 'পরিমাণ লিখুন',
                    prefixIcon: Icons.money,
                    keyboardType: TextInputType.number,
                  ),
                  AppTextFromField(
                    controller: controller.paymentMethod,
                    label: 'পেমেন্ট পদ্ধতি',
                    hintText: 'পেমেন্ট পদ্ধতি লিখুন',
                    prefixIcon: Icons.payment,
                  ),
                  AppTextFromField(
                    controller: controller.note,
                    label: 'নোট',
                    hintText: 'নোট লিখুন',
                    prefixIcon: Icons.note,
                    isMaxLines: 3,
                  ),
                  const SizedBox(height: 20),
                  AppButton(
                    label: 'আপডেট করুন',
                    onPressed: controller.enableBtn.value
                        ? controller.updateTransaction
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
