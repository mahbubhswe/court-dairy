import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/court_case.dart';
import '../../../models/party.dart';
import '../../../services/app_firebase.dart';
import '../../party/services/party_service.dart';
import '../services/case_service.dart';

class EditCaseController extends GetxController {
  EditCaseController(this.caseModel);

  final CourtCase caseModel;

  late final TextEditingController caseTitle;
  late final TextEditingController courtName;
  late final TextEditingController caseNumber;
  late final TextEditingController caseStatus;
  late final TextEditingController caseSummary;
  late final TextEditingController judgeName;
  late final TextEditingController courtOrder;
  late final TextEditingController document;

  final RxnString selectedCaseType = RxnString();
  final Rx<DateTime?> filedDate = Rx<DateTime?>(null);
  final Rx<DateTime?> hearingDate = Rx<DateTime?>(null);

  final Rx<Party?> selectedPlaintiff = Rx<Party?>(null);
  final Rx<Party?> selectedDefendant = Rx<Party?>(null);

  final parties = <Party>[].obs;
  final caseTypes = ['Civil', 'Criminal', 'Family', 'Other'];

  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    caseTitle = TextEditingController(text: caseModel.caseTitle);
    courtName = TextEditingController(text: caseModel.courtName);
    caseNumber = TextEditingController(text: caseModel.caseNumber);
    caseStatus = TextEditingController(text: caseModel.caseStatus);
    caseSummary = TextEditingController(text: caseModel.caseSummary);
    judgeName = TextEditingController(text: caseModel.judgeName);
    courtOrder = TextEditingController(
        text: caseModel.courtOrders.isNotEmpty ? caseModel.courtOrders.first : '');
    document = TextEditingController(
        text: caseModel.documentsAttached.isNotEmpty
            ? caseModel.documentsAttached.first
            : '');
    selectedCaseType.value = caseModel.caseType;
    filedDate.value = caseModel.filedDate.toDate();
    if (caseModel.hearingDates.isNotEmpty) {
      hearingDate.value = caseModel.hearingDates.first.toDate();
    }
    selectedPlaintiff.value = caseModel.plaintiff;
    selectedDefendant.value = caseModel.defendant;

    final user = AppFirebase().currentUser;
    if (user != null) {
      PartyService.getParties(user.uid).listen((list) {
        parties.value = list;
      });
    }
  }

  Future<bool> updateCase() async {
    final user = AppFirebase().currentUser;
    if (user == null || isLoading.value) return false;
    try {
      isLoading.value = true;
      caseModel
        ..caseType = selectedCaseType.value ?? ''
        ..caseTitle = caseTitle.text.trim()
        ..courtName = courtName.text.trim()
        ..caseNumber = caseNumber.text.trim()
        ..filedDate = Timestamp.fromDate(filedDate.value ?? DateTime.now())
        ..caseStatus = caseStatus.text.trim()
        ..plaintiff = selectedPlaintiff.value!
        ..defendant = selectedDefendant.value!
        ..hearingDates = hearingDate.value != null
            ? [Timestamp.fromDate(hearingDate.value!)]
            : <Timestamp>[]
        ..judgeName = judgeName.text.trim()
        ..documentsAttached =
            document.text.isNotEmpty ? [document.text.trim()] : <String>[]
        ..courtOrders =
            courtOrder.text.isNotEmpty ? [courtOrder.text.trim()] : <String>[]
        ..caseSummary = caseSummary.text.trim();

      await CaseService.updateCase(caseModel, user.uid);
      return true;
    } catch (e) {
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
