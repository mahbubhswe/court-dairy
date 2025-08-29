import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/transaction.dart';
import '../../../services/app_firebase.dart';
import '../services copy/transaction_service.dart';

class AddTransactionController extends GetxController {
  final RxnString type = RxnString();
  final amount = TextEditingController();
  final RxnString paymentMethod = RxnString();
  final note = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxBool enableBtn = false.obs;

  @override
  void onInit() {
    super.onInit();
    amount.addListener(_validate);
    ever(type, (_) => _validate());
    ever(paymentMethod, (_) => _validate());
  }

  void _validate() {
    enableBtn.value =
        type.value != null &&
        amount.text.trim().isNotEmpty &&
        paymentMethod.value != null;
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
        type: type.value!,
        amount: double.tryParse(amount.text.trim()) ?? 0,
        note: note.text.trim().isEmpty ? null : note.text.trim(),
        paymentMethod: paymentMethod.value!,
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
    amount.dispose();
    note.dispose();
    super.onClose();
  }
}
