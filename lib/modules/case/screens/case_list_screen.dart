import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/case_tile.dart';
import '../../../widgets/data_not_found.dart';
import '../controllers/case_controller.dart';
import 'case_profile_screen.dart';
import 'edit_case_screen.dart';

class CaseListScreen extends StatefulWidget {
  const CaseListScreen({super.key});

  @override
  State<CaseListScreen> createState() => _CaseListScreenState();
}

class _CaseListScreenState extends State<CaseListScreen> {
  final controller = Get.put(CaseController());
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    controller.loadAllCases();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
      initialDate: selectedDate ?? now,
    );
    if (date != null) {
      setState(() => selectedDate = date);
      controller.loadAllCases(date: date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Cases'),
        actions: [
          IconButton(onPressed: _pickDate, icon: const Icon(Icons.filter_alt))
        ],
      ),
      body: Obx(() {
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
    );
  }
}
