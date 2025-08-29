import 'package:courtdiary/constants/app_collections.dart';
import 'package:courtdiary/services/firebase_services.dart';
import 'package:courtdiary/widgets/app_snackber.dart';
import 'package:courtdiary/widgets/custom_text_form_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showAddCourtDialog({required BuildContext context}) {
  final TextEditingController courtController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Text(
        'Add a New Court',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyMedium!,
      ),
      content: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: CustomTextFormField(
            controller: courtController,
            labelText: 'Court Name',
            hintText: 'Enter a court name',
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            if (formKey.currentState!.validate()) {
              Navigator.of(context).pop();

              await updateArrayField(
                collectionName: AppCollections.LAWYERS,
                id: FirebaseAuth.instance.currentUser!.uid,
                field: 'courts',
                value: courtController.text.trim(),
                isAdd: true,
              );

              AppSnackbar.show(
                  title: 'Success',
                  message: 'Payment added successfully!',
                  textColor: Theme.of(context).colorScheme.onSurface);
              Get.back();
            }
          },
          child: Text('Save'),
        ),
      ],
    ),
  );
}
