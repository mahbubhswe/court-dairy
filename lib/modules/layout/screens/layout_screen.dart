import 'package:courtdiary/modules/accounts/screens/accounts_screen.dart';
import 'package:courtdiary/modules/case/screens/case_screen.dart';
import 'package:courtdiary/themes/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../screens/calculator_screen.dart';
import '../../../screens/customer_service_screen.dart';
import '../../../constants/app_texts.dart';
import '../../party/screens/party_screen.dart';
import '../widgets/app_drawer.dart';
import '../controllers/layout_controller.dart';
import '../widgets/dashboard.dart';

class LayoutScreen extends StatelessWidget {
  LayoutScreen({super.key});
  final themeController = Get.find<ThemeController>();
  final layoutController = Get.put(LayoutController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 40,
        titleSpacing: 0,
        title: const Text('Court Dairy'),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => CalculatorScreen(), fullscreenDialog: true);
            },
            icon: const Icon(HugeIcons.strokeRoundedCalculator01),
            tooltip: AppTexts.calculator,
          ),
          IconButton(
            onPressed: () {
              Get.to(() => const CustomerServiceScreen());
            },
            icon: const Icon(HugeIcons.strokeRoundedCustomerService01),
            tooltip: AppTexts.customerService,
          ),
        ],
      ),
      drawer: AppDrawer(),
      floatingActionButton: Obx(() {
        final visible = layoutController.isDashboardVisible.value;
        return AnimatedScale(
          scale: visible ? 1 : 0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          child: AnimatedOpacity(
            opacity: visible ? 1 : 0,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            child: FloatingActionButton(
              onPressed: () {},
              child: const Icon(Icons.receipt_long_rounded),
            ),
          ),
        );
      }),
      body: Column(
        children: [
          Obx(() {
            return AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: layoutController.isDashboardVisible.value
                  ? Dashboard()
                  : const SizedBox.shrink(),
            );
          }),
          Expanded(
            child: DefaultTabController(
              length: 3,
              child: Column(
                children: [
                  const TabBar(
                    tabs: [
                      Tab(text: AppTexts.tabParty),
                      Tab(text: AppTexts.tabCase),
                      Tab(text: AppTexts.tabAccounts),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [CaseScreen(), PartyScreen(), AccountsScreen()],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
