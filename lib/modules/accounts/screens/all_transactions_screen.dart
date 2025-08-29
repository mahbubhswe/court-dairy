import 'package:courtdiary/widgets/data_not_found.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../services/app_firebase.dart';
import '../../../utils/transaction_types.dart';
import '../controllers/transaction_controller.dart';
import '../services/transaction_service.dart';
import '../widgets/transaction_tile.dart';
import 'edit_transaction_screen.dart';
import '../../../utils/activation_guard.dart';

class AllTransactionsScreen extends StatelessWidget {
  AllTransactionsScreen({super.key});

  final controller = Get.find<TransactionController>();
  final RxString typeFilter = 'All'.obs;
  final RxString dateFilter = 'All'.obs;

  @override
  Widget build(BuildContext context) {
    final types = ['All', ...getTransactionTypes()];
    final dates = ['All', 'Today', 'This Week', 'This Month'];
    return Scaffold(
      appBar: AppBar(title: const Text('All Transactions')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Obx(
                    () => DropdownButtonFormField<String>(
                      value: typeFilter.value,
                      decoration: const InputDecoration(labelText: 'Type'),
                      items: types
                          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (v) => typeFilter.value = v ?? 'All',
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Obx(
                    () => DropdownButtonFormField<String>(
                      value: dateFilter.value,
                      decoration: const InputDecoration(labelText: 'Date'),
                      items: dates
                          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (v) => dateFilter.value = v ?? 'All',
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              final filtered = controller.transactions.where((t) {
                final now = DateTime.now();
                bool typeMatch =
                    typeFilter.value == 'All' || t.type == typeFilter.value;
                bool dateMatch = true;
                switch (dateFilter.value) {
                  case 'Today':
                    dateMatch = t.createdAt.year == now.year &&
                        t.createdAt.month == now.month &&
                        t.createdAt.day == now.day;
                    break;
                  case 'This Week':
                    final start = now.subtract(Duration(days: now.weekday - 1));
                    final end = start.add(const Duration(days: 7));
                    dateMatch = t.createdAt.isAfter(start) &&
                        t.createdAt.isBefore(end);
                    break;
                  case 'This Month':
                    dateMatch = t.createdAt.year == now.year &&
                        t.createdAt.month == now.month;
                    break;
                  default:
                    dateMatch = true;
                }
                return typeMatch && dateMatch;
              }).toList();

              if (filtered.isEmpty) {
                return const DataNotFound(
                    title: 'Sorry', subtitle: 'No Transaction Found');
              }

              return ListView.builder(
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final transaction = filtered[index];
                  return TransactionTile(
                    transaction: transaction,
                    onEdit: () {
                      if (ActivationGuard.check()) {
                        Get.to(() =>
                            EditTransactionScreen(transaction: transaction));
                      }
                    },
                    onDelete: () async {
                      if (!ActivationGuard.check()) return;
                      final user = AppFirebase().currentUser;
                      if (user != null && transaction.docId != null) {
                        await TransactionService.deleteTransaction(
                            transaction.docId!, user.uid);
                      }
                    },
                  );
                },
              );
            }),
          )
        ],
      ),
    );
  }
}

