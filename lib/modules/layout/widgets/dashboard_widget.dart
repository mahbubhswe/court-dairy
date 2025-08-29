import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../cases/controllers/cases_view_controller.dart';
import '../../parties/controllers/parties_view_controller.dart';
import '../controllers/layout_controller.dart';
import 'dashboard_item.dart';

class DashboardWidget extends StatelessWidget {
  const DashboardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final CaseViewController caseViewController = Get.put(CaseViewController());
    final PartiesViewController partiesViewController =
        Get.put(PartiesViewController());
    final LayoutController layoutController = Get.put(LayoutController());

    return Obx(() {
      final totalCashIn =
          caseViewController.caseList.fold<int>(0, (count, caseData) {
        return count +
            caseData.payments
                .fold<int>(0, (sum, payment) => sum + payment.amount.toInt());
      });

      final totalCost = layoutController.costList.fold<int>(0, (count, item) {
        return count + item.amount.toInt();
      });

      return Container(
        padding: const EdgeInsets.symmetric(vertical: 7),
        child: Column(
          children: [
            // First Row with 3 items
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DashboardItem(
                  title: 'মোট পার্টি',
                  count: partiesViewController.partyList.length,
                ),
                DashboardItem(
                  title: 'মোট কেস',
                  count: caseViewController.caseList.length,
                ),
                DashboardItem(
                  title: 'একটিভ কেস',
                  count: caseViewController.caseList.fold<int>(0,
                      (count, caseData) {
                    return caseData.caseStatus == "Active" ? count + 1 : count;
                  }),
                ),
              ],
            ),

            // Second Row with 3 items
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DashboardItem(title: 'মোট জমা', count: totalCashIn),
                DashboardItem(title: 'মোট খরচ', count: totalCost),
                DashboardItem(
                    title: 'ব্যালেন্স', count: totalCashIn - totalCost),
              ],
            ),
          ],
        ),
      );
    });
  }
}
