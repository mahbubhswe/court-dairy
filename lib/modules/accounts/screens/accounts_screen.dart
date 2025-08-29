import 'package:courtdiary/widgets/data_not_found.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../services/app_firebase.dart';
import '../controllers/transaction_controller.dart';
import '../services/transaction_service.dart';
import '../widgets/transaction_tile.dart';
import 'all_transactions_screen.dart';
import 'edit_transaction_screen.dart';

class AccountsScreen extends StatelessWidget {
  const AccountsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TransactionController());
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Recent Transactions',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () {
                    Get.to(() => AllTransactionsScreen());
                  },
                  child: const Text('All Transactions'),
                ),
              ],
            ),
          ),
          Expanded(
            child: controller.transactions.isEmpty
                ? const DataNotFound(
                    title: 'Sorry', subtitle: 'No Transaction Found')
                : ListView.builder(
                    itemCount: controller.transactions.length > 10
                        ? 10
                        : controller.transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = controller.transactions[index];
                      return TransactionTile(
                        transaction: transaction,
                        onEdit: () {
                          Get.to(() =>
                              EditTransactionScreen(transaction: transaction));
                        },
                        onDelete: () async {
                          final user = AppFirebase().currentUser;
                          if (user != null && transaction.docId != null) {
                            await TransactionService.deleteTransaction(
                                transaction.docId!, user.uid);
                          }
                        },
                      );
                    },
                  ),
          ),
        ],
      );
    });
  }
}
