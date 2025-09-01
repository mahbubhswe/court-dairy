import 'package:hugeicons/hugeicons.dart';

import '../../../widgets/dynamic_multi_step_form.dart';
import '../../../widgets/app_text_from_field.dart';
import '../../../widgets/app_type_ahead_field.dart';
import '../../../constants/app_colors.dart';
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

    Widget titledChipRow({
      required String title,
      required List<String> options,
      required RxnString selected,
    }) {
      final appBarColor = Theme.of(context).appBarTheme.backgroundColor ??
          Theme.of(context).colorScheme.primary;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Obx(() {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: options.map((t) {
                  final isSelected = selected.value == t;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(t),
                      selected: isSelected,
                      onSelected: (_) => selected.value = t,
                      shape: StadiumBorder(
                        side: BorderSide(
                          color: isSelected ? Colors.transparent : appBarColor,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            );
          }),
        ],
      );
    }

    Widget caseStatusDropdown() {
      return Obx(() => DropdownButtonFormField<String>(
            value: controller.selectedCaseStatus.value,
            isExpanded: true,
            borderRadius: BorderRadius.circular(12),
            menuMaxHeight: 320,
            icon: const Icon(Icons.keyboard_arrow_down_rounded),
            decoration: InputDecoration(
              labelText: 'Case Status',
              hintText: 'Select case status',
              prefixIcon: const Icon(Icons.flag_outlined),
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.7),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 1.4,
                ),
              ),
            ),
            items: controller.caseStatuses
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (v) => controller.selectedCaseStatus.value = v,
          ));
    }

    Widget partyDropdown({
      required Rx<Party?> selected,
      required String label,
      required String hint,
      required IconData icon,
    }) {
      return Obx(() => DropdownButtonFormField<Party>(
            value: selected.value,
            isExpanded: true,
            borderRadius: BorderRadius.circular(12),
            menuMaxHeight: 320,
            icon: const Icon(Icons.keyboard_arrow_down_rounded),
            decoration: InputDecoration(
              labelText: label,
              hintText: hint,
              prefixIcon: Icon(icon),
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.7),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 1.4,
                ),
              ),
            ),
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
                  spacing: 10,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    titledChipRow(
                      title: 'Case Type',
                      options: controller.caseTypes,
                      selected: controller.selectedCaseType,
                    ),
                    titledChipRow(
                      title: 'Court Type',
                      options: controller.courtTypes,
                      selected: controller.selectedCourtType,
                    ),
                    AppTextFromField(
                      controller: controller.caseTitle,
                      label: 'Case Title',
                      hintText: 'Enter case title',
                      prefixIcon: Icons.title,
                    ),
                    AppTypeAheadField(
                      controller: controller.courtName,
                      label: 'Court Name',
                      hintText: 'Enter court name',
                      prefixIcon: Icons.account_balance,
                      suggestions: controller.allCourtNames,
                    ),
                    AppTextFromField(
                      controller: controller.caseNumber,
                      label: 'Case Number',
                      hintText: 'Enter case number',
                      prefixIcon: Icons.numbers,
                      keyboardType: TextInputType.text,
                    ),
                    caseStatusDropdown(),
                    AppTextFromField(
                      controller: controller.caseSummary,
                      label: 'Summary',
                      hintText: 'Enter summary',
                      prefixIcon: Icons.description_outlined,
                      isMaxLines: 3,
                    ),
                    Obx(() => ListTile(
                          title: Text(controller.filedDate.value == null
                              ? 'Filed Date'
                              : controller.filedDate.value
                                  .toString()
                                  .split(' ')
                                  .first),
                          trailing:
                              const Icon(HugeIcons.strokeRoundedCalendar01),
                          onTap: () async {
                            final picked = await showDatePicker(
                                context: context,
                                initialDate: controller.filedDate.value ??
                                    DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100));
                            if (picked != null)
                              controller.filedDate.value = picked;
                          },
                        )),
                  ],
                ),
              ),
              FormStep(
                title: const Text('Parties'),
                content: Column(
                  children: [
                    partyDropdown(
                      selected: controller.selectedPlaintiff,
                      label: 'Plaintiff',
                      hint: 'Select plaintiff',
                      icon: Icons.person_outline,
                    ),
                    const SizedBox(height: 16),
                    partyDropdown(
                      selected: controller.selectedDefendant,
                      label: 'Defendant',
                      hint: 'Select defendant',
                      icon: Icons.person_outline,
                    ),
                  ],
                ),
              ),
              FormStep(
                title: const Text('More'),
                content: Column(
                  spacing: 10,
                  children: [
                    Obx(() => ListTile(
                          title: Text(controller.hearingDate.value == null
                              ? 'Hearing Date'
                              : controller.hearingDate.value
                                  .toString()
                                  .split(' ')
                                  .first),
                          trailing:
                              const Icon(HugeIcons.strokeRoundedCalendar01),
                          onTap: () async {
                            final picked = await showDatePicker(
                                context: context,
                                initialDate: controller.hearingDate.value ??
                                    DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100));
                            if (picked != null)
                              controller.hearingDate.value = picked;
                          },
                        )),
                    AppTypeAheadField(
                      controller: controller.judgeName,
                      label: 'Judge Name',
                      hintText: 'Enter judge name',
                      prefixIcon: Icons.gavel,
                      suggestions: controller.allJudgeNames,
                    ),
                    AppTextFromField(
                      controller: controller.courtOrder,
                      label: 'Court Order',
                      hintText: 'Enter court order',
                      prefixIcon: Icons.article_outlined,
                      isMaxLines: 3,
                    ),
                  ],
                ),
              ),
            ],
            isLoading: controller.isLoading.value,
            controlsInBottom: true,
            stepIconColor: AppColors.fixedPrimary,
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
                      buttonText: 'Okey',
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
                      buttonText: 'Okey',
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
