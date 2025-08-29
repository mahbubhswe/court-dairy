import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:courtdiary/constants/app_collections.dart';
import 'package:courtdiary/models/cost.dart';
import 'package:courtdiary/services/firebase_services.dart';
import 'package:courtdiary/widgets/app_snackber.dart';
import 'package:courtdiary/widgets/custom_text_form_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showCostInputDialog({required BuildContext context}) {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController commentController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Text(
        'Enter Payment Details',
        textAlign: TextAlign.center,
        style: Theme.of(context)
            .textTheme
            .bodyMedium!
            .copyWith(fontWeight: FontWeight.bold, fontSize: 21),
      ),
      content: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            spacing: 12,
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextFormField(
                controller: amountController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Amount cannot be empty';
                  }
                  final parsedValue = double.tryParse(value);
                  if (parsedValue == null || parsedValue <= 0) {
                    return 'Enter a valid amount';
                  }
                  return null;
                },
                labelText: 'Amount',
                hintText: 'Enter amount',
              ),
              CustomTextFormField(
                controller: commentController,
                labelText: 'Comment',
                hintText: 'Enter a comment',
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(
            foregroundColor: Colors.redAccent,
          ),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            if (formKey.currentState!.validate()) {
              final amount = double.parse(amountController.text);
              final comment = commentController.text.trim();
              Navigator.of(context).pop();

              Cost newCost = Cost(
                timestamp: Timestamp.now(),
                amount: amount,
                comment: comment,
              );

              await updateArrayField(
                collectionName: AppCollections.LAWYERS,
                id: FirebaseAuth.instance.currentUser!.uid,
                field: 'costs',
                value: newCost.toMap(),
                isAdd: true,
              );

              AppSnackbar.show(
                title: 'Success',
                message: 'Cost saved successfully!',
                textColor: Colors.teal,
              );
              Get.back();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text('Save'),
        ),
      ],
    ),
  );
}
