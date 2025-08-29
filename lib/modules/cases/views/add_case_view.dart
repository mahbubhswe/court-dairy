import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:courtdiary/models/party.dart';
import 'package:courtdiary/modules/layout/widgets/add_court_dailog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:text_form_field_wrapper/text_form_field_wrapper.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/custom_text_form_field.dart';
import '../../layout/controllers/layout_controller.dart';
import '../../parties/controllers/parties_view_controller.dart';
import '../controllers/add_case_controller.dart';
import 'package:dropdown_flutter/custom_dropdown.dart';

class AddCaseView extends StatelessWidget {
  const AddCaseView({super.key});

  @override
  Widget build(BuildContext context) {
    final AddCaseController addCaseController = Get.put(AddCaseController());
    final LayoutController layoutController = Get.put(LayoutController());
    final PartiesViewController partiesViewController =
        Get.put(PartiesViewController());

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: addCaseController.formKey,
          child: Column(
            spacing: 8,
            children: [
              SimpleShadow(
                offset: Offset(1, 1),
                sigma: 1,
                opacity: 0.5,
                color: Colors.grey,
                child: Row(
                  children: [
                    Expanded(
                      child: DropdownFlutter<String>.search(
                        hintText: 'Select Court',
                        items: layoutController.courtList,
                        validator: (p0) {
                          if (addCaseController.courtName.value.isEmpty) {
                            return 'Select';
                          }
                          return null;
                        },
                        onChanged: (String? newValue) {
                          addCaseController.courtName.value = newValue!;
                        },
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          showAddCourtDialog(context: context);
                        },
                        icon: Icon(HugeIcons.strokeRoundedAddSquare))
                  ],
                ),
              ),
              SimpleShadow(
                  offset: Offset(1, 1),
                  sigma: 1,
                  opacity: 0.5,
                  color: Colors.grey,
                  child: DropdownFlutter<String>.search(
                    hintText: 'Select Party',
                    validator: (p0) {
                      if (addCaseController.partyId.value.isEmpty) {
                        return 'Select';
                      }
                      return null;
                    },
                    items: partiesViewController.partyList
                        .map((Party party) => party.name)
                        .toList(),
                    onChanged: (value) {
                      Party? party = partiesViewController.partyList.firstWhere(
                          (member) => member.name == value,
                          orElse: () => Party(
                              name: '', phone: '', address: '', lawyerId: ''));

                      addCaseController.partyName.value = party.name;
                      addCaseController.partyNumber.value = party.phone;
                      addCaseController.partyId.value =
                          party.getDynamicField(key: 'id');
                    },
                  )),
              SimpleShadow(
                offset: Offset(1, 1),
                sigma: 1,
                opacity: 0.5,
                color: Colors.grey,
                child: DropdownFlutter<String>.search(
                  hintText: 'Party Type',
                  initialItem: addCaseController.partyType.value,
                  items: ['Plainttif', 'Defendant'],
                  onChanged: (String? newValue) {
                    addCaseController.partyType.value = newValue!;
                  },
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomTextFormField(
                      labelText: 'Case Number',
                      hintText: 'Enter Case Number',
                      controller: addCaseController.caseNumberController,
                      position: TextFormFieldPosition.left,
                      validator: (p0) {
                        if (addCaseController
                            .caseNumberController.text.isEmpty) {
                          return "You can't keep empty";
                        }
                        return null;
                      },
                    ),
                  ),
                  Expanded(
                    child: CustomTextFormField(
                      labelText: 'Under Section',
                      hintText: 'Enter Case Section',
                      controller: addCaseController.underSectionController,
                      position: TextFormFieldPosition.right,
                      validator: (p0) {
                        if (addCaseController
                            .underSectionController.text.isEmpty) {
                          return "You can't keep empty";
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              CustomTextFormField(
                labelText: 'Case Name',
                hintText: 'Enter Case Name',
                controller: addCaseController.caseNameController,
                validator: (p0) {
                  if (addCaseController.caseNameController.text.isEmpty) {
                    return "You can't keep empty";
                  }
                  return null;
                },
              ),
              CustomTextFormField(
                labelText: 'Plainttif Name',
                hintText: 'Enter Plainttif Name',
                controller: addCaseController.plaintiffNameController,
                validator: (p0) {
                  if (addCaseController.plaintiffNameController.text.isEmpty) {
                    return "You can't keep empty";
                  }
                  return null;
                },
              ),
              CustomTextFormField(
                labelText: 'Defendant Name',
                hintText: 'Enter Defendant Name',
                controller: addCaseController.defendantNameController,
                validator: (p0) {
                  if (addCaseController.defendantNameController.text.isEmpty) {
                    return "You can't keep empty";
                  }
                  return null;
                },
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(() => Text(
                          'Next Hearing Date: ${DateFormat('dd, MMM yyyy').format(addCaseController.nextDate.value.toDate())}')),
                      IconButton(
                          onPressed: () async {
                            // Show the date picker
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate:
                                  addCaseController.previousDate.value.toDate(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2101),
                            );

                            if (pickedDate != null) {
                              // Update the Rx<Timestamp> value with the selected date
                              addCaseController.nextDate.value =
                                  Timestamp.fromDate(pickedDate);
                            }
                          },
                          icon: Icon(HugeIcons.strokeRoundedCalendar03))
                    ],
                  ),
                ),
              ),
              CustomTextFormField(
                labelText: 'Next Actions',
                hintText: 'Enter next action',
                controller: addCaseController.nextActionController,
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(() => Text(
                          'Previous Hearing Date: ${DateFormat('dd, MMM yyyy').format(addCaseController.previousDate.value.toDate())}')),
                      IconButton(
                          onPressed: () async {
                            // Show the date picker
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate:
                                  addCaseController.previousDate.value.toDate(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2101),
                            );

                            if (pickedDate != null) {
                              // Update the Rx<Timestamp> value with the selected date
                              addCaseController.previousDate.value =
                                  Timestamp.fromDate(pickedDate);
                            }
                          },
                          icon: Icon(HugeIcons.strokeRoundedCalendar03))
                    ],
                  ),
                ),
              ),
              CustomTextFormField(
                labelText: 'Previous Actions',
                hintText: 'Enter Previous action',
                controller: addCaseController.previousActionController,
              ),
              SimpleShadow(
                offset: Offset(1, 1),
                sigma: 1,
                opacity: 0.5,
                color: Colors.grey,
                child: DropdownFlutter<String>.search(
                  hintText: 'Case Priority',
                  items: ['High', 'Low', 'Medium'],
                  initialItem: addCaseController.casePriority.value,
                  onChanged: (String? newValue) {
                    addCaseController.casePriority.value = newValue!;
                  },
                ),
              ),
              AppButton(
                title: 'Add Case',
                onTap: () {
                  if (addCaseController.formKey.currentState!.validate()) {
                    PanaraConfirmDialog.show(
                      context,
                      title: "Are You Sure?",
                      message: "Do you want to add the case?",
                      confirmButtonText: "Confirm",
                      cancelButtonText: "Cancel",
                      onTapCancel: () {
                        Navigator.pop(context);
                      },
                      onTapConfirm: () async {
                        Get.back();
                        Get.back();
                        await addCaseController.addCase();

                        // Call a method to add the case to the database
                        // Here, you should handle the case creation logic.
                      },
                      panaraDialogType: PanaraDialogType.normal,
                      barrierDismissible:
                          false, // optional parameter (default is true)
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
