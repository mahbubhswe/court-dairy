import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/court_case.dart';
import '../../../models/party.dart';
import '../../../services/app_firebase.dart';
import '../../party/services/party_service.dart';
import '../services/case_service.dart';

class AddCaseController extends GetxController {
  final caseTitle = TextEditingController();
  final courtName = TextEditingController();
  final courtType = TextEditingController();
  final caseNumber = TextEditingController();
  final caseStatus = TextEditingController();
  final caseSummary = TextEditingController();
  final judgeName = TextEditingController();
  final courtOrder = TextEditingController();
  final document = TextEditingController();

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
    final user = AppFirebase().currentUser;
    if (user != null) {
      PartyService.getParties(user.uid).listen((list) {
        parties.value = list;
      });
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
        courtType: courtType.text.trim(),
        courtName: courtName.text.trim(),
        caseNumber: caseNumber.text.trim(),
        filedDate: Timestamp.fromDate(filedDate.value ?? DateTime.now()),
        caseStatus: caseStatus.text.trim(),
        plaintiff: selectedPlaintiff.value!,
        defendant: selectedDefendant.value!,
        hearingDates: hearingDate.value != null
            ? [Timestamp.fromDate(hearingDate.value!)]
            : <Timestamp>[],
        judgeName: judgeName.text.trim(),
        documentsAttached:
            document.text.isNotEmpty ? [document.text.trim()] : <String>[],
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
