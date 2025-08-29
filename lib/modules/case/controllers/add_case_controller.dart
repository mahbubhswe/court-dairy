import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/case.dart';
import '../../../models/party.dart';
import '../../../services/app_firebase.dart';
import '../../../services/firebase_export.dart';
import '../../party/services/party_service.dart';
import '../services/case_service.dart';

class AddCaseController extends GetxController {
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
    caseNumber.addListener(validate);
    caseName.addListener(validate);
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
    final list = List<String>.from(doc.data()?['courts'] ?? []);
    courts.value = list;
  }

  Future<void> addCase() async {
    if (!enableBtn.value || isLoading.value) return;
    final user = AppFirebase().currentUser;
    if (user == null) return;
    try {
      isLoading.value = true;
      final party = selectedParty.value!;
      final c = Case(
        caseNumber: caseNumber.text.trim(),
        caseName: caseName.text.trim(),
        courtName: selectedCourt.value,
        partyName: party.name,
        partyNumber: party.phone,
        partyId: party.docId!,
        lawyerId: user.uid,
        isNotify: false,
        isSendSms: false,
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
        createdAt: Timestamp.now(),
        caseStatus: caseStatus.text.trim(),
        partyType: partyType.text.trim(),
        notificationId: 0,
      );
      await CaseService.addCase(c);
      Get.back();
      Get.snackbar('Success', 'Case added');
    } catch (e) {
      Get.snackbar('Error', 'Failed to add case');
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
