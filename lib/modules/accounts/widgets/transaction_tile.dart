import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/transaction.dart';

class TransactionTile extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const TransactionTile({
    super.key,
    required this.transaction,
    required this.onEdit,
    required this.onDelete,
  });

  IconData _iconForType(String type) {
    switch (type) {
      case 'Expense':
        return Icons.remove_circle_outline;
      case 'Deposit':
        return Icons.add_circle_outline;
      case 'Capital Withdrawal':
        return Icons.account_balance_wallet_outlined;
      case 'Money Transfer':
        return Icons.swap_horiz;
      default:
        return Icons.attach_money;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(_iconForType(transaction.type)),
      title: Text('${transaction.type} - ${transaction.amount}'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(DateFormat('dd MMM yyyy').format(transaction.createdAt)),
          Text('Payment: ${transaction.paymentMethod}'),
          if (transaction.note != null && transaction.note!.isNotEmpty)
            Text(transaction.note!),
        ],
      ),
      trailing: PopupMenuButton<String>(
        onSelected: (value) {
          if (value == 'edit') {
            onEdit();
          } else if (value == 'delete') {
            onDelete();
          }
        },
        itemBuilder: (context) => const [
          PopupMenuItem(value: 'edit', child: Text('Edit')),
          PopupMenuItem(value: 'delete', child: Text('Delete')),
        ],
      ),
    );
  }
}

