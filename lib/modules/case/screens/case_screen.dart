import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/data_not_found.dart';
import '../../../widgets/case_tile.dart';
import '../controllers/case_controller.dart';
import 'case_list_screen.dart';
import 'case_profile_screen.dart';
import 'edit_case_screen.dart';

class CaseScreen extends StatelessWidget {
  const CaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CaseController());
    return Column(
      children: [
        Expanded(
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            if (controller.cases.isEmpty) {
              return const DataNotFound(title: 'Sorry', subtitle: 'No Case Found');
            }
            return ListView.builder(
              itemCount: controller.cases.length,
              itemBuilder: (context, index) {
                final c = controller.cases[index];
                return CaseTile(
                  data: c,
                  onTap: () => Get.to(() => CaseProfileScreen(caseData: c)),
                  onEdit: () => Get.to(() => EditCaseScreen(caseData: c)),
                  onDelete: () => controller.deleteCase(c),
                );
              },
            );
          }),
        ),
        TextButton(
          onPressed: () => Get.to(() => const CaseListScreen()),
          child: const Text('See All'),
        ),
      ],
    );
  }
}
