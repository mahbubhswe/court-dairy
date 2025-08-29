import 'package:courtdiary/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import '../../../widgets/custom_text_form_field.dart';
import '../controllers/add_party_controller.dart';

class AddPartyView extends StatelessWidget {
  const AddPartyView({super.key});

  @override
  Widget build(BuildContext context) {
    final AddPartyController addPartyController = Get.put(AddPartyController());

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Form(
        key: addPartyController.formKey,
        child: Column(
          spacing: 12.0,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextFormField(
              labelText: 'Party Name',
              hintText: 'Enter party name',
              controller: addPartyController.nameController,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Name should not be empty';
                }
                return null;
              },
            ),
            CustomTextFormField(
              labelText: 'Party Phone',
              hintText: 'Enter party phone',
              controller: addPartyController.phoneController,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null ||
                    value.trim().isEmpty ||
                    value.length != 11 ||
                    !(value.startsWith('018') ||
                        value.startsWith('015') ||
                        value.startsWith('016') ||
                        value.startsWith('017') ||
                        value.startsWith('019') ||
                        value.startsWith('013'))) {
                  return 'Found invalid phone number';
                }
                return null;
              },
            ),
            CustomTextFormField(
              labelText: 'Party Address',
              hintText: 'Enter party address',
              textInputAction: TextInputAction.done,
              controller: addPartyController.addressController,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Address should not be empty';
                }
                return null;
              },
            ),
            AppButton(
                title: 'Add Party',
                onTap: () {
                  if (addPartyController.formKey.currentState!.validate()) {
                    PanaraConfirmDialog.show(
                      context,
                      title: "Are You Sure?",
                      message: "Do you want to add",
                      confirmButtonText: "Confirm",
                      cancelButtonText: "Cancel",
                      onTapCancel: () {
                        Navigator.pop(context);
                      },
                      onTapConfirm: () {
                        Navigator.pop(context);
                        addPartyController.addParty();
                        Navigator.pop(context);
                      },
                      panaraDialogType: PanaraDialogType.normal,
                      barrierDismissible:
                          false, // optional parameter (default is true)
                    );
                  }
                })
          ],
        ),
      ),
    );
  }
}
