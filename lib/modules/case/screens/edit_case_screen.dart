import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/app_button.dart';
import '../../../widgets/app_text_from_field.dart';
import '../../../models/party.dart';
import '../../../models/case.dart';
import '../controllers/edit_case_controller.dart';

class EditCaseScreen extends StatelessWidget {
  final Case caseData;
  const EditCaseScreen({super.key, required this.caseData});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditCaseController(caseData));
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Case')),
      body: Obx(() {
        return Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                spacing: 16,
                children: [
                  AppTextFromField(
                    controller: controller.caseNumber,
                    label: 'Case Number',
                  ),
                  AppTextFromField(
                    controller: controller.caseName,
                    label: 'Case Name',
                  ),
                  DropdownButtonFormField<Party>(
                    value: controller.selectedParty.value,
                    decoration: const InputDecoration(labelText: 'Party'),
                    items: controller.parties
                        .map((p) => DropdownMenuItem(
                              value: p,
                              child: Text(p.name),
                            ))
                        .toList(),
                    onChanged: (p) {
                      controller.selectedParty.value = p;
                      controller.validate();
                    },
                  ),
                  DropdownButtonFormField<String>(
                    value: controller.selectedCourt.value.isEmpty
                        ? null
                        : controller.selectedCourt.value,
                    decoration: const InputDecoration(labelText: 'Court'),
                    items: controller.courts
                        .map((s) => DropdownMenuItem(
                              value: s,
                              child: Text(s),
                            ))
                        .toList(),
                    onChanged: (v) {
                      controller.selectedCourt.value = v ?? '';
                      controller.validate();
                    },
                  ),
                  AppButton(
                    label: 'Update',
                    onPressed: controller.enableBtn.value
                        ? controller.updateCase
                        : null,
                  ),
                ],
              ),
            ),
            if (controller.isLoading.value)
              const Center(child: CircularProgressIndicator()),
          ],
        );
      }),
    );
  }
}
