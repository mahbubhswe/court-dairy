import '../../../widgets/dynamic_multi_step_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/court_case.dart';
import '../../../models/party.dart';
import '../controllers/edit_case_controller.dart';

class EditCaseScreen extends StatelessWidget {
  const EditCaseScreen(this.caseItem, {super.key});

  final CourtCase caseItem;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditCaseController(caseItem));

    Widget caseTypeChips() {
      return Wrap(
        spacing: 8,
        children: controller.caseTypes.map((type) {
          return Obx(() => ChoiceChip(
                label: Text(type),
                selected: controller.selectedCaseType.value == type,
                onSelected: (_) => controller.selectedCaseType.value = type,
              ));
        }).toList(),
      );
    }

    Widget partyDropdown(Rx<Party?> selected) {
      return Obx(() => DropdownButton<Party>(
            value: selected.value,
            hint: const Text('Select'),
            items: controller.parties
                .map((p) => DropdownMenuItem(
                      value: p,
                      child: Text(p.name),
                    ))
                .toList(),
            onChanged: (v) => selected.value = v,
          ));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Case')),
      body: DynamicMultiStepForm(
        steps: [
          FormStep(
            title: const Text('Case Info'),
            content: Column(
              children: [
                caseTypeChips(),
                TextField(
                  controller: controller.caseTitle,
                  decoration: const InputDecoration(labelText: 'Case Title'),
                ),
                TextField(
                  controller: controller.courtName,
                  decoration: const InputDecoration(labelText: 'Court Name'),
                ),
                TextField(
                  controller: controller.caseNumber,
                  decoration: const InputDecoration(labelText: 'Case Number'),
                ),
                TextField(
                  controller: controller.caseStatus,
                  decoration: const InputDecoration(labelText: 'Case Status'),
                ),
                TextField(
                  controller: controller.caseSummary,
                  decoration: const InputDecoration(labelText: 'Summary'),
                ),
                Obx(() => ListTile(
                      title: Text(controller.filedDate.value == null
                          ? 'Filed Date'
                          : controller.filedDate.value
                              .toString()
                              .split(' ')
                              .first),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        final picked = await showDatePicker(
                            context: context,
                            initialDate: controller.filedDate.value ?? DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100));
                        if (picked != null) controller.filedDate.value = picked;
                      },
                    )),
              ],
            ),
          ),
          FormStep(
            title: const Text('Parties'),
            content: Column(
              children: [
                const Text('Plaintiff'),
                partyDropdown(controller.selectedPlaintiff),
                const SizedBox(height: 16),
                const Text('Defendant'),
                partyDropdown(controller.selectedDefendant),
              ],
            ),
          ),
          FormStep(
            title: const Text('More'),
            content: Column(
              children: [
                Obx(() => ListTile(
                      title: Text(controller.hearingDate.value == null
                          ? 'Hearing Date'
                          : controller.hearingDate.value
                              .toString()
                              .split(' ')
                              .first),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        final picked = await showDatePicker(
                            context: context,
                            initialDate:
                                controller.hearingDate.value ?? DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100));
                        if (picked != null) controller.hearingDate.value = picked;
                      },
                    )),
                TextField(
                  controller: controller.judgeName,
                  decoration: const InputDecoration(labelText: 'Judge Name'),
                ),
                TextField(
                  controller: controller.courtOrder,
                  decoration: const InputDecoration(labelText: 'Court Order'),
                ),
                TextField(
                  controller: controller.document,
                  decoration: const InputDecoration(labelText: 'Document'),
                ),
              ],
            ),
          ),
        ],
        onSubmit: controller.updateCase,
      ),
    );
  }
}
