import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/app_button.dart';
import '../../../widgets/app_text_from_field.dart';
import '../../../models/party.dart';
import '../controllers/add_case_controller.dart';

class AddCaseScreen extends StatelessWidget {
  const AddCaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddCaseController());
    return Scaffold(
      appBar: AppBar(title: const Text('Add Case')),
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
                    hintText: 'Enter case number',
                  ),
                  AppTextFromField(
                    controller: controller.caseName,
                    label: 'Case Name',
                    hintText: 'Enter case name',
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
                  AppTextFromField(
                    controller: controller.plaintiffName,
                    label: 'Plaintiff',
                  ),
                  AppTextFromField(
                    controller: controller.defendantName,
                    label: 'Defendant',
                  ),
                  AppButton(
                    label: 'Save',
                    onPressed: controller.enableBtn.value
                        ? controller.addCase
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
