import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../themes/theme_controller.dart';
import '../../case/controllers/case_controller.dart';
import '../../party/controllers/party_controller.dart';
import '../../accounts/controllers/transaction_controller.dart';
import 'accounts_card.dart';

class AccountsSecondCard extends StatelessWidget {
  AccountsSecondCard({super.key});
  final themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    // Use same dynamic metrics for now
    final caseController = Get.find<CaseController>();
    final partyController = Get.isRegistered<PartyController>()
        ? Get.find<PartyController>()
        : Get.put(PartyController());
    final transactionController = Get.isRegistered<TransactionController>()
        ? Get.find<TransactionController>()
        : Get.put(TransactionController());

    double sumWhere(String type) {
      return transactionController.transactions
          .where((t) => t.type == type)
          .fold<double>(0, (p, e) => p + e.amount);
    }

    return Obx(() {
      final totalParties = partyController.parties.length.toDouble();
      final totalCases = caseController.cases.length.toDouble();
      final totalCourts = caseController.cases
          .map((c) => c.courtName)
          .toSet()
          .length
          .toDouble();
      final totalDeposit = sumWhere('Deposit');
      final totalExpense = sumWhere('Expense') + sumWhere('Withdrawal');
      final balance = totalDeposit - totalExpense;

      String countTitle(String singularLabel, double value) {
        final v = value.toInt();
        if (v == 0) return 'কোনো $singularLabel নেই';
        return '$vটি $singularLabel';
      }

      String moneyTitle(String base, double value) {
        if (value == 0) {
          if (base == 'জমা') return 'কোনো জমা নেই';
          if (base == 'খরচ') return 'কোনো খরচ নেই';
          return 'ব্যালেন্স নেই';
        }
        if (base == 'ব্যালেন্স' && value < 0) return 'ঋণাত্মক ব্যালেন্স';
        return 'মোট $base';
      }

      return Material(
        color: cs.surface,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            spacing: 5,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AccountsCard(title: countTitle('পার্টি', totalParties), amount: totalParties),
                  AccountsCard(title: countTitle('কেস', totalCases), amount: totalCases),
                  AccountsCard(title: countTitle('কোর্ট', totalCourts), amount: totalCourts),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AccountsCard(title: moneyTitle('জমা', totalDeposit), amount: totalDeposit),
                  AccountsCard(title: moneyTitle('খরচ', totalExpense), amount: totalExpense),
                  AccountsCard(title: moneyTitle('ব্যালেন্স', balance), amount: balance),
                ],
              )
            ],
          ),
        ),
      );
    });
  }
}
