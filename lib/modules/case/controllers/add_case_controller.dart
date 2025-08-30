import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../models/court_case.dart';
import '../../../models/party.dart';
import '../../../services/app_firebase.dart';
import '../../party/services/party_service.dart';
import '../services/case_service.dart';

class AddCaseController extends GetxController {
  final caseTitle = TextEditingController();
  final courtName = TextEditingController();
  final caseNumber = TextEditingController();
  final caseSummary = TextEditingController();
  final judgeName = TextEditingController();
  final courtOrder = TextEditingController();

  final RxnString selectedCaseType = RxnString();
  final RxnString selectedCourtType = RxnString();
  final RxnString selectedCaseStatus = RxnString();
  final Rx<DateTime?> filedDate = Rx<DateTime?>(null);
  final Rx<DateTime?> hearingDate = Rx<DateTime?>(null);

  final Rx<Party?> selectedPlaintiff = Rx<Party?>(null);
  final Rx<Party?> selectedDefendant = Rx<Party?>(null);

  final parties = <Party>[].obs;
  final caseTypes = ['Civil', 'Criminal', 'Family', 'Other'];
  final courtTypes = ['District', 'Appeal', 'High Court'];
  final caseStatuses = ['Ongoing', 'Disposed', 'Completed'];

  final documents = <String>[].obs;

  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    final user = AppFirebase().currentUser;
    if (user != null) {
      PartyService.getParties(user.uid).listen((list) {
        parties.value = list;
      });
    }
  }

  Future<void> pickDocuments() async {
    final picker = ImagePicker();
    final files = await picker.pickMultiImage();
    if (files.isEmpty) return;
    final user = AppFirebase().currentUser;
    if (user == null) return;
    for (final file in files) {
      final path =
          'cases/${user.uid}/${DateTime.now().millisecondsSinceEpoch}_${file.name}';
      final ref = AppFirebase().storage.ref().child(path);
      await ref.putFile(File(file.path));
      final url = await ref.getDownloadURL();
      documents.add(url);
    }
  }

  Future<bool> addCase() async {
    final user = AppFirebase().currentUser;
    if (user == null || isLoading.value) return false;
    try {
      isLoading.value = true;
      final caseModel = CourtCase(
        caseType: selectedCaseType.value ?? '',
        caseTitle: caseTitle.text.trim(),
        courtType: selectedCourtType.value ?? '',
        courtName: courtName.text.trim(),
        caseNumber: caseNumber.text.trim(),
        filedDate: Timestamp.fromDate(filedDate.value ?? DateTime.now()),
        caseStatus: selectedCaseStatus.value ?? '',
        plaintiff: selectedPlaintiff.value!,
        defendant: selectedDefendant.value!,
        hearingDates: hearingDate.value != null
            ? [Timestamp.fromDate(hearingDate.value!)]
            : <Timestamp>[],
        judgeName: judgeName.text.trim(),
        documentsAttached: documents.toList(),
        courtOrders:
            courtOrder.text.isNotEmpty ? [courtOrder.text.trim()] : <String>[],
        caseSummary: caseSummary.text.trim(),
      );

      await CaseService.addCase(caseModel, user.uid);
      return true;
    } catch (e) {
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
