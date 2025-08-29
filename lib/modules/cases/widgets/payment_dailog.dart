import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:courtdiary/constants/app_collections.dart';
import 'package:courtdiary/models/payment.dart';
import 'package:courtdiary/services/firebase_services.dart';
import 'package:courtdiary/widgets/app_snackber.dart';
import 'package:courtdiary/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showAmountInputDialog(
    {required BuildContext context, required String name, required String id}) {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController commentController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Column(
        children: [
          Text(
            name,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontWeight: FontWeight.bold, fontSize: 21),
          ),
          Text(
            'Enter Payment Details',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium!,
          ),
        ],
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
                keyboardType: TextInputType.number,
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
                hintText: 'Enter a amount',
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
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            if (formKey.currentState!.validate()) {
              final amount = double.parse(amountController.text);
              final comment = commentController.text.trim();
              Navigator.of(context).pop();

              Payment payment = Payment(
                timestamp: Timestamp.now(),
                amount: amount,
                comment: comment,
              );

              await updateArrayField(
                collectionName: AppCollections.CASES,
                id: id,
                field: 'payments',
                value: payment.toMap(),
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
