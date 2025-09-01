import '../../../widgets/dynamic_multi_step_form.dart';
import '../../../widgets/app_type_ahead_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

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
      final appBarColor = Theme.of(context).appBarTheme.backgroundColor ??
          Theme.of(context).colorScheme.primary;
      return Wrap(
        spacing: 8,
        children: controller.caseTypes.map((type) {
          return Obx(() {
            final isSelected = controller.selectedCaseType.value == type;
            return ChoiceChip(
              label: Text(type),
              selected: isSelected,
              onSelected: (_) => controller.selectedCaseType.value = type,
              shape: StadiumBorder(
                side: BorderSide(
                  color:
                      isSelected ? Colors.transparent : appBarColor,
                ),
              ),
            );
          });
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
      body: Obx(() => DynamicMultiStepForm(
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
                AppTypeAheadField(
                  controller: controller.courtName,
                  label: 'Court Name',
                  hintText: 'Enter court name',
                  prefixIcon: Icons.account_balance,
                  suggestions: controller.allCourtNames,
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
                AppTypeAheadField(
                  controller: controller.judgeName,
                  label: 'Judge Name',
                  hintText: 'Enter judge name',
                  prefixIcon: Icons.gavel,
                  suggestions: controller.allJudgeNames,
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
            isLoading: controller.isLoading.value,
            onSubmit: () {
              PanaraConfirmDialog.show(
                context,
                title: 'নিশ্চিত করুন',
                message: 'কেস আপডেট করতে চান?',
                confirmButtonText: 'হ্যাঁ',
                cancelButtonText: 'না',
                onTapCancel: () {
                  Navigator.of(context).pop();
                },
                onTapConfirm: () async {
                  Navigator.of(context).pop();
                  final success = await controller.updateCase();
                  if (success) {
                    PanaraInfoDialog.show(
                      context,
                      title: 'সফল হয়েছে', buttonText: 'Okey',
                      message: 'কেস আপডেট করা হয়েছে',
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
                      title: 'ত্রুটি', buttonText: 'Okey',
                      message: 'কেস আপডেট করতে ব্যর্থ হয়েছে',
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
