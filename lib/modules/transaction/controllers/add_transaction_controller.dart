import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/transaction.dart';
import '../../../services/app_firebase.dart';
import '../services/transaction_service.dart';

class AddTransactionController extends GetxController {
  final type = TextEditingController();
  final amount = TextEditingController();
  final paymentMethod = TextEditingController();
  final note = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxBool enableBtn = false.obs;

  @override
  void onInit() {
    super.onInit();
    type.addListener(_validate);
    amount.addListener(_validate);
    paymentMethod.addListener(_validate);
  }

  void _validate() {
    enableBtn.value = type.text.trim().isNotEmpty &&
        amount.text.trim().isNotEmpty &&
        paymentMethod.text.trim().isNotEmpty;
  }

  Future<void> addTransaction() async {
    if (!enableBtn.value || isLoading.value) return;
    try {
      isLoading.value = true;
      final user = AppFirebase().currentUser;
      if (user == null) {
        throw Exception('No authenticated user');
      }

      final transaction = Transaction(
        type: type.text.trim(),
        amount: double.tryParse(amount.text.trim()) ?? 0,
        note: note.text.trim().isEmpty ? null : note.text.trim(),
        paymentMethod: paymentMethod.text.trim(),
        createdAt: DateTime.now(),
      );

      await TransactionService.addTransaction(transaction, user.uid);

      Get.back();
      Get.snackbar(
        'সফল হয়েছে',
        'লেনদেন যুক্ত করা হয়েছে',
        backgroundColor: Colors.white,
        colorText: Colors.green,
      );
    } catch (e) {
      Get.snackbar(
        'ত্রুটি',
        'লেনদেন যুক্ত করতে ব্যর্থ হয়েছে',
        backgroundColor: Colors.white,
        colorText: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    type.dispose();
    amount.dispose();
    paymentMethod.dispose();
    note.dispose();
    super.onClose();
  }
}
