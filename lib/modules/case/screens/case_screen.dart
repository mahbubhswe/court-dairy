import 'package:courtdiary/widgets/data_not_found.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/case_controller.dart';
import '../widgets/case_tile.dart';
import 'all_case_screen.dart';

class CaseScreen extends StatelessWidget {
  const CaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CaseController>();
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (controller.cases.isEmpty) {
        return const DataNotFound(title: "Sorry", subtitle: "No cases found");
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Your Cases',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                    onPressed: () => Get.to(() => AllCaseScreen()),
                    child: Text("See ALl"))
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                filterChip(
                    'today', "Today's (${controller.todayCount})", controller),
                filterChip('tomorrow', 'Tomorrow (${controller.tomorrowCount})',
                    controller),
                filterChip(
                    'week', 'This Week (${controller.weekCount})', controller),
                filterChip('month', 'This Month (${controller.monthCount})',
                    controller),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: ListView.builder(
                key: ValueKey(controller.selectedFilter.value),
                itemCount: controller.filteredCases.length,
                itemBuilder: (_, i) {
                  final caseItem = controller.filteredCases[i];
                  return TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 300),
                    builder: (context, value, child) =>
                        Opacity(opacity: value, child: child),
                    child: CaseTile(caseItem: caseItem),
                  );
                },
              ),
            ),
          ),
        ],
      );
    });
  }
}

Widget filterChip(String key, String label, CaseController controller) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 4),
    child: ChoiceChip(
      label: Text(label),
      selected: controller.selectedFilter.value == key,
      onSelected: (_) => controller.selectedFilter.value = key,
    ),
  );
}
