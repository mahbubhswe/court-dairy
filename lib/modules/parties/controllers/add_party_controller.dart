import 'package:courtdiary/constants/app_collections.dart';
import 'package:courtdiary/services/firebase_services.dart';
import 'package:courtdiary/widgets/app_snackber.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/party.dart';

class AddPartyController extends GetxController {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  // Method to add a party (you can modify this to save it to a database)
  Future<void> addParty() async {
    Party newParty = Party(
      name: nameController.text.trim(),
      phone: phoneController.text.trim(),
      address: addressController.text.trim(),
      lawyerId: FirebaseAuth.instance.currentUser!.uid,
    );

    // Save the party to a database, or do other operations
    await addDocument(
        collectionName: AppCollections.PARTIES, data: newParty.toMap());
    AppSnackbar.show(
        title: 'Success',
        message: 'Party saved successfully!',
        textColor: Colors.teal);
    // Reset form fields after adding party
    nameController.clear();
    phoneController.clear();
    addressController.clear();
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.onClose();
  }
}
