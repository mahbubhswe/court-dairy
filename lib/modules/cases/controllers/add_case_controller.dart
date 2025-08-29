import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:courtdiary/constants/app_collections.dart';
import 'package:courtdiary/models/case.dart';
import 'package:courtdiary/services/firebase_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class AddCaseController extends GetxController {
  // Form key
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Controllers for form fields
  TextEditingController caseNumberController = TextEditingController();
  TextEditingController underSectionController = TextEditingController();
  TextEditingController caseNameController = TextEditingController();
  TextEditingController plaintiffNameController = TextEditingController();
  TextEditingController defendantNameController = TextEditingController();
  TextEditingController nextActionController =
      TextEditingController(text: 'New Case');
  TextEditingController previousActionController =
      TextEditingController(text: "New Case");

  // Reactive variables for dropdowns or other state-managed fields
  RxString courtName = ''.obs;
  RxString partyName = ''.obs;
  RxString partyNumber = ''.obs;
  RxString partyId = ''.obs;
  RxString casePriority = 'Medium'.obs;
  RxString partyType = 'Plainttif'.obs;

  // Reactive variables for next and previous dates as Timestamp
  Rx<Timestamp> nextDate = Timestamp.now().obs;
  Rx<Timestamp> previousDate = Timestamp.now().obs;

  int generateUniqueInt() {
    var uuid = Uuid().v1(); // Generate UUID v1
    return uuid.hashCode.abs(); // Use hashCode as an integer value
  }

  // Method to add a case
  Future<void> addCase() async {
    try {
      int uniqueId = generateUniqueInt();

      Case newCase = Case(
        caseNumber: caseNumberController.text.trim(),
        caseName: caseNameController.text.trim(),
        courtName: courtName.value,
        partyName: partyName.value,
        partyNumber: partyNumber.value,
        payments: [], // Empty list of payments initially
        partyId: partyId.value,
        lawyerId: FirebaseAuth.instance.currentUser!.uid,
        isNotify: false,
        isSendSms: false,
        plaintiffName: plaintiffNameController.text.trim(),
        defendantName: defendantNameController.text.trim(),
        underSection: underSectionController.text.trim(),
        nextDate: nextDate.value, // Firestore Timestamp
        previousDate: previousDate.value, // Firestore Timestamp
        nextAction: nextActionController.text.trim(),
        previousAction: previousActionController.text.trim(),
        casePriority: casePriority.value,
        caseOutcome: 'Pending',
        lastUpdated: Timestamp.now(),
        caseStatus: 'Active',
        createdAt: Timestamp.now(), partyType: partyType.value,
        notificationId: uniqueId,
      );

      // Save the case to Firestore
      await addDocument(
        collectionName: AppCollections.CASES,
        data: newCase.toMap(),
      );
      // Reset form fields
      Get.snackbar('Success', 'Case added successfully.');
      clearForm();
    } catch (e) {
      Get.snackbar('Error', 'Failed to add case: $e');
    }
  }

  // Helper method to clear form fields
  void clearForm() {
    caseNumberController.clear();
    caseNameController.clear();
    plaintiffNameController.clear();
    defendantNameController.clear();
    nextActionController.clear();
    previousActionController.clear();
    underSectionController.clear();
    courtName.value = '';
    partyName.value = '';
    partyNumber.value = '';
    partyId.value = '';
  }

  @override
  void onClose() {
    // Dispose controllers when the controller is closed
    caseNumberController.dispose();
    caseNameController.dispose();
    plaintiffNameController.dispose();
    defendantNameController.dispose();
    nextActionController.dispose();
    previousActionController.dispose();
    super.onClose();
  }
}
