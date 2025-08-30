import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/case_controller.dart';
import '../widgets/case_tile.dart';
import 'add_case_screen.dart';

class CaseScreen extends StatelessWidget {
  const CaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CaseController());
    return Scaffold(
      appBar: AppBar(title: const Text('Cases')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.cases.isEmpty) {
          return const Center(child: Text('No cases found'));
        }
        return ListView.builder(
          itemCount: controller.cases.length,
          itemBuilder: (_, i) => CaseTile(caseItem: controller.cases[i]),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => const AddCaseScreen()),
        child: const Icon(Icons.add),
      ),
    );
  }
}
