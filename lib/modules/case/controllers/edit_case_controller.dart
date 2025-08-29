import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/case.dart';
import '../../../models/party.dart';
import '../../../services/app_firebase.dart';
import '../../../services/firebase_export.dart';
import '../../party/services/party_service.dart';
import '../services/case_service.dart';

class EditCaseController extends GetxController {
  EditCaseController(this.caseData);

  final Case caseData;

  final caseNumber = TextEditingController();
  final caseName = TextEditingController();
  final plaintiffName = TextEditingController();
  final defendantName = TextEditingController();
  final underSection = TextEditingController();
  final nextAction = TextEditingController();
  final previousAction = TextEditingController();
  final casePriority = TextEditingController();
  final caseOutcome = TextEditingController();
  final caseStatus = TextEditingController();
  final partyType = TextEditingController();

  final Rx<DateTime?> nextDate = Rx<DateTime?>(null);
  final Rx<DateTime?> previousDate = Rx<DateTime?>(null);

  final Rx<Party?> selectedParty = Rx<Party?>(null);
  final RxString selectedCourt = ''.obs;

  final RxList<Party> parties = <Party>[].obs;
  final RxList<String> courts = <String>[].obs;

  final RxBool isLoading = false.obs;
  final RxBool enableBtn = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadParties();
    _loadCourts();
    _fillData();
    caseNumber.addListener(validate);
    caseName.addListener(validate);
  }

  void _fillData() {
    caseNumber.text = caseData.caseNumber;
    caseName.text = caseData.caseName;
    plaintiffName.text = caseData.plaintiffName;
    defendantName.text = caseData.defendantName;
    underSection.text = caseData.underSection;
    nextAction.text = caseData.nextAction;
    previousAction.text = caseData.previousAction;
    casePriority.text = caseData.casePriority;
    caseOutcome.text = caseData.caseOutcome;
    caseStatus.text = caseData.caseStatus;
    partyType.text = caseData.partyType;
    nextDate.value = caseData.nextDate.toDate();
    previousDate.value = caseData.previousDate.toDate();
    selectedCourt.value = caseData.courtName;
  }

  void validate() {
    enableBtn.value = caseNumber.text.trim().isNotEmpty &&
        caseName.text.trim().isNotEmpty &&
        selectedParty.value != null &&
        selectedCourt.value.isNotEmpty;
  }

  void _loadParties() {
    final user = AppFirebase().currentUser;
    if (user == null) return;
    PartyService.getParties(user.uid).listen((data) {
      parties.value = data;
      selectedParty.value = data.firstWhereOrNull((p) => p.docId == caseData.partyId);
    });
  }

  Future<void> _loadCourts() async {
    final user = AppFirebase().currentUser;
    if (user == null) return;
    final doc = await AppFirebase()
        .firestore
        .collection('lawyers')
        .doc(user.uid)
        .get();
    courts.value = List<String>.from(doc.data()?['courts'] ?? []);
  }

  Future<void> updateCase() async {
    if (!enableBtn.value || isLoading.value) return;
    final user = AppFirebase().currentUser;
    if (user == null) return;
    try {
      isLoading.value = true;
      final party = selectedParty.value!;
      final c = Case(
        docId: caseData.docId,
        caseNumber: caseNumber.text.trim(),
        caseName: caseName.text.trim(),
        courtName: selectedCourt.value,
        partyName: party.name,
        partyNumber: party.phone,
        partyId: party.docId!,
        lawyerId: user.uid,
        isNotify: caseData.isNotify,
        isSendSms: caseData.isSendSms,
        plaintiffName: plaintiffName.text.trim(),
        defendantName: defendantName.text.trim(),
        underSection: underSection.text.trim(),
        nextDate: Timestamp.fromDate(nextDate.value ?? DateTime.now()),
        previousDate: Timestamp.fromDate(previousDate.value ?? DateTime.now()),
        nextAction: nextAction.text.trim(),
        previousAction: previousAction.text.trim(),
        casePriority: casePriority.text.trim(),
        caseOutcome: caseOutcome.text.trim(),
        lastUpdated: Timestamp.now(),
        createdAt: caseData.createdAt,
        caseStatus: caseStatus.text.trim(),
        partyType: partyType.text.trim(),
        notificationId: caseData.notificationId,
      );
      await CaseService.updateCase(c);
      Get.back();
      Get.snackbar('Success', 'Case updated');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update case');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    caseNumber.dispose();
    caseName.dispose();
    plaintiffName.dispose();
    defendantName.dispose();
    underSection.dispose();
    nextAction.dispose();
    previousAction.dispose();
    casePriority.dispose();
    caseOutcome.dispose();
    caseStatus.dispose();
    partyType.dispose();
    super.onClose();
  }
}
