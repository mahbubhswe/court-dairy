import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/app_button.dart';
import '../../../widgets/app_text_from_field.dart';
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
                  DropdownButtonFormField<String>(
                    value: controller.type.value,
                    isExpanded: true,
                    borderRadius: BorderRadius.circular(12),
                    menuMaxHeight: 320,
                    icon: const Icon(Icons.keyboard_arrow_down_rounded),
                    decoration: InputDecoration(
                      labelText: 'ধরণ',
                      hintText: 'লেনদেনের ধরণ নির্বাচন করুন',
                      prefixIcon: const Icon(Icons.category),
                      filled: true,
                      fillColor: Theme.of(context)
                          .colorScheme
                          .surface
                          .withOpacity(0.7),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.outlineVariant,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 1.4,
                        ),
                      ),
                    ),
                    items: getTransactionTypes()
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ))
                        .toList(),
                    onChanged: (v) => controller.type.value = v,
                  ),
                  AppTextFromField(
                    controller: controller.amount,
                    label: 'পরিমাণ',
                    hintText: 'পরিমাণ লিখুন',
                    prefixIcon: Icons.money,
                    keyboardType: TextInputType.number,
                  ),
                  DropdownButtonFormField<String>(
                    value: controller.paymentMethod.value,
                    isExpanded: true,
                    borderRadius: BorderRadius.circular(12),
                    menuMaxHeight: 320,
                    icon: const Icon(Icons.keyboard_arrow_down_rounded),
                    decoration: InputDecoration(
                      labelText: 'পেমেন্ট পদ্ধতি',
                      hintText: 'পেমেন্ট পদ্ধতি নির্বাচন করুন',
                      prefixIcon: const Icon(Icons.payment),
                      filled: true,
                      fillColor: Theme.of(context)
                          .colorScheme
                          .surface
                          .withOpacity(0.7),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.outlineVariant,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 1.4,
                        ),
                      ),
                    ),
                    items: paymentMethods
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ))
                        .toList(),
                    onChanged: (v) => controller.paymentMethod.value = v,
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
      bottomNavigationBar: Obx(() => SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: AppButton(
                label: 'সেভ করুন',
                onPressed: controller.enableBtn.value
                    ? controller.addTransaction
                    : null,
              ),
            ),
          )),
    );
  }
}
