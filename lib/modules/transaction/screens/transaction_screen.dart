import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/transaction_controller.dart';
import 'edit_transaction_screen.dart';

class TransactionScreen extends StatelessWidget {
  const TransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TransactionController());
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (controller.transactions.isEmpty) {
        return const Center(child: Text('কোন লেনদেন পাওয়া যায়নি'));
      }
      return ListView.builder(
        itemCount: controller.transactions.length,
        itemBuilder: (context, index) {
          final transaction = controller.transactions[index];
          return ListTile(
            title: Text('${transaction.type} - ${transaction.amount}'),
            subtitle: Text(transaction.paymentMethod),
            onTap: () {
              Get.to(() => EditTransactionScreen(transaction: transaction));
            },
          );
        },
      );
    });
  }
}
