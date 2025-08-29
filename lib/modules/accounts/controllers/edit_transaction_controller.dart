import 'package:courtdiary/modules/accounts/services/transaction_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/transaction.dart';
import '../../../services/app_firebase.dart';
import '../../../utils/activation_guard.dart';

class EditTransactionController extends GetxController {
  final Transaction transaction;
  EditTransactionController(this.transaction);

  final RxnString type = RxnString();
  final amount = TextEditingController();
  final RxnString paymentMethod = RxnString();
  final note = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxBool enableBtn = false.obs;

  @override
  void onInit() {
    super.onInit();
    type.value = transaction.type;
    amount.text = transaction.amount.toString();
    paymentMethod.value = transaction.paymentMethod;
    note.text = transaction.note ?? '';

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

  Future<void> updateTransaction() async {
    if (!enableBtn.value || isLoading.value) return;
    if (!ActivationGuard.check()) return;
    try {
      isLoading.value = true;
      final user = AppFirebase().currentUser;
      if (user == null) {
        throw Exception('No authenticated user');
      }

      final updated = Transaction(
        docId: transaction.docId,
        type: type.value!,
        amount: double.tryParse(amount.text.trim()) ?? 0,
        note: note.text.trim().isEmpty ? null : note.text.trim(),
        paymentMethod: paymentMethod.value!,
        createdAt: transaction.createdAt,
        partyId: transaction.partyId,
      );

      await TransactionService.updateTransaction(updated, user.uid);

      Get.back();
      Get.snackbar(
        'সফল হয়েছে',
        'লেনদেন আপডেট করা হয়েছে',
        backgroundColor: Colors.white,
        colorText: Colors.green,
      );
    } catch (e) {
      Get.snackbar(
        'ত্রুটি',
        'লেনদেন আপডেট করতে ব্যর্থ হয়েছে',
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
