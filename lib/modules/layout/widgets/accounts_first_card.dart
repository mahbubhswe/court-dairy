import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../themes/theme_controller.dart';
import 'accounts_card.dart';

class AccountsFirstCard extends StatelessWidget {
  AccountsFirstCard({super.key});
  final themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
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
                AccountsCard(
                  title: 'মোট পার্টি',
                  amount: 0,
                ),
                AccountsCard(
                  title: 'মোট কেস',
                  amount: 0,
                ),
                AccountsCard(
                  title: 'মোট কোর্ট',
                  amount: 0,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AccountsCard(
                  title: 'মোট জমা',
                  amount: 0,
                ),
                AccountsCard(
                  title: 'মোট খরচ',
                  amount: 0,
                ),
                AccountsCard(
                  title: 'বর্তমান ব্যালেন্স',
                  amount: 0,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
