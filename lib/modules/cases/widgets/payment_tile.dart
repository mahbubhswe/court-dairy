import 'package:courtdiary/models/payment.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';

class PaymentTile extends StatelessWidget {
  final Payment payment;
  const PaymentTile({super.key, required this.payment});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: HugeIcon(
            icon: HugeIcons.strokeRoundedMoney04,
            color: Theme.of(context).colorScheme.onSurface),
        title: Text('৳ ${payment.amount.toString()}'),
        subtitle: Text(payment.comment),
        trailing: Text(
          DateFormat('dd, MMMM yyyy').format(payment.timestamp.toDate()),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}
