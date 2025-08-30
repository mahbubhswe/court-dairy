import '../../../widgets/dynamic_multi_step_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

import '../controllers/add_case_controller.dart';
import '../../../models/party.dart';

class AddCaseScreen extends StatelessWidget {
  const AddCaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddCaseController());

    Widget chipGrid(List<String> options, RxnString selected) {
      final width = (MediaQuery.of(context).size.width - 48) / 2;
      return Wrap(
        spacing: 8,
        runSpacing: 8,
        children: options
            .map((type) => SizedBox(
                  width: width,
                  child: Obx(() => ChoiceChip(
                        label: Text(type),
                        selected: selected.value == type,
                        onSelected: (_) => selected.value = type,
                      )),
                ))
            .toList(),
      );
    }

    Widget caseTypeChips() => chipGrid(controller.caseTypes, controller.selectedCaseType);

    Widget courtTypeChips() => chipGrid(controller.courtTypes, controller.selectedCourtType);

    Widget caseStatusDropdown() {
      return Obx(() => DropdownButtonFormField<String>(
            value: controller.selectedCaseStatus.value,
            decoration: const InputDecoration(labelText: 'Case Status'),
            items: controller.caseStatuses
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (v) => controller.selectedCaseStatus.value = v,
          ));
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
      appBar: AppBar(title: const Text('Add Case')),
      body: Obx(() => DynamicMultiStepForm(
            steps: [
          FormStep(
            title: const Text('Case Info'),
            content: Column(
              children: [
                caseTypeChips(),
                const SizedBox(height: 8),
                courtTypeChips(),
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
                caseStatusDropdown(),
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
                ElevatedButton(
                  onPressed: controller.pickDocuments,
                  child: const Text('Upload Documents'),
                ),
                const SizedBox(height: 8),
                Obx(() => Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: controller.documents
                          .map((url) => Image.network(
                                url,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ))
                          .toList(),
                    )),
              ],
            ),
          ),
            ],
            isLoading: controller.isLoading.value,
            onSubmit: () {
              PanaraConfirmDialog.show(
                context,
                title: 'নিশ্চিত করুন',
                message: 'কেস যুক্ত করতে চান?',
                confirmButtonText: 'হ্যাঁ',
                cancelButtonText: 'না',
                onTapCancel: () {
                  Navigator.of(context).pop();
                },
                onTapConfirm: () async {
                  Navigator.of(context).pop();
                  final success = await controller.addCase();
                  if (success) {
                    PanaraInfoDialog.show(
                      context,
                      title: 'সফল হয়েছে',
                      message: 'কেস যুক্ত করা হয়েছে',
                      panaraDialogType: PanaraDialogType.success,
                      barrierDismissible: false,
                      onTapDismiss: () {
                        Navigator.of(context).pop();
                        Get.back();
                      },
                    );
                  } else {
                    PanaraInfoDialog.show(
                      context,
                      title: 'ত্রুটি',
                      message: 'কেস যুক্ত করতে ব্যর্থ হয়েছে',
                      panaraDialogType: PanaraDialogType.error,
                      barrierDismissible: false,
                      onTapDismiss: () {
                        Navigator.of(context).pop();
                      },
                    );
                  }
                },
                panaraDialogType: PanaraDialogType.normal,
              );
            },
          )),
    );
  }
}
