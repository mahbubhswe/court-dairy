import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../themes/theme_controller.dart';
import 'accounts_card.dart';

class AccountsSecondCard extends StatelessWidget {
  AccountsSecondCard({super.key});
  final themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: themeController.isDarkMode
          ? Colors.black
          : const Color.fromARGB(255, 241, 238, 238),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          spacing: 5,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() => AccountsCard(
                      title: 'মোট স্টক',
                      amount:0,
                    )),
                Obx(() => AccountsCard(
                      title: 'মোট বিক্রি',
                      amount:0,
                    )),
                Obx(() => AccountsCard(
                      title: 'বর্তমান স্টক',
                      amount:0)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() => AccountsCard(
                      title: 'মোট ক্রয়',
                      amount:0
                    )),
                Obx(() => AccountsCard(
                      title: 'মোট বিক্রি',
                      amount:0
                    )),
                Obx(() => AccountsCard(
                      title: 'মোট লাভ',
                      amount:0
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
