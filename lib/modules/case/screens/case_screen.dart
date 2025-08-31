import 'package:courtdiary/widgets/data_not_found.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/case_controller.dart';
import '../widgets/case_tile.dart';
import 'all_case_screen.dart';

class CaseScreen extends StatelessWidget {
  final bool showHeader;
  const CaseScreen({super.key, this.showHeader = true});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CaseController>();
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showHeader)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Your Cases',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                      onPressed: () => Get.to(() => AllCaseScreen()),
                      style: TextButton.styleFrom(
                        foregroundColor:
                            Theme.of(context).colorScheme.onSurface,
                      ),
                      child: Text("See All"))
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
              child: controller.filteredCases.isEmpty
                  ? const Center(
                      key: ValueKey('empty_cases'),
                      child: DataNotFound(
                          title: "Sorry", subtitle: "No cases found"),
                    )
                  : ListView.builder(
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
      label: Text(label, style: const TextStyle(fontSize: 12)),
      selected: controller.selectedFilter.value == key,
      onSelected: (_) => controller.selectedFilter.value = key,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
      labelPadding: const EdgeInsets.symmetric(horizontal: 8),
    ),
  );
}
